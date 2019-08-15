import requests
import json
import pandas as pd
from urllib.request import urlopen
from bs4 import BeautifulSoup
from tabulate import tabulate
import itertools
import itertools
from urllib import parse
import functools
from itertools import groupby
from operator import itemgetter
from pprint import pprint
from datetime import datetime
from datetime import date, timedelta 
pd.set_option('display.max_columns', 500)
pd.set_option('display.width', 1500)
startTime = datetime.now()
import pandas.io.sql as psql
import psycopg2 as pg
from sqlalchemy import create_engine, MetaData, Table
import time
from selenium import webdriver
#CREATE YOUR ENGINE 
engine = create_engine('postgresql+psycopg2://postgres:PASSWORD@HOST:PORT/DATABASE_NAME')

#CREATE A TEMPORARY CONNECTION
conn_1 = pg.connect("dbname=DATABASE_NAME user=USER_NAME host=HOST port=PORT password=PASSWORD")



tripadvisor_base_url = "https://www.tripadvisor.sk"



global list_of_base_urls
list_of_hotel_urls = []

global n_sites
n_sites = []

global dataframes_list
dataframes_list = []


#GO TO TRIPADVISOR.COM ENTER SEARCHED CITY AND PASE THE SEARCH SITE
#EXAMPLE ON KOSICE
site = "https://www.tripadvisor.sk/Hotels-g274927-Kosice_Kosice_Region-Hotels.html"

#GET ALL OF THE HOTELS' URLS
def get_acc_url():
    
    x = 0
    limit = len(n_sites)
    
    print(str(datetime.now() - startTime) + ": working on site no. " + str(x+1) + " out of " + str(number_of_pages))
    def get_url():
        soup = BeautifulSoup((requests.get(n_sites[x])).content, 'lxml')
        acc_divs = soup.findAll("a", {"class": "property_title prominent"})
        y = 0
        limit = len(acc_divs)
        hotel_url = tripadvisor_base_url + str(acc_divs[y]['href'])
        list_of_hotel_urls.append(hotel_url)
        while y < limit - 1:
            y = y + 1
            hotel_url = tripadvisor_base_url + str(acc_divs[y]['href'])
            list_of_hotel_urls.append(hotel_url)
    get_url()
    while x < limit - 1:
        x = x + 1
        print(str(datetime.now() - startTime) + ": working on site no. " + str(x+1) + " out of " + str(number_of_pages))
        get_url()


#GET ALL OF THE HOTELS' BASE DATA
def get_acc():
    x = 0
    limit = len(list_of_hotel_urls)
    def get_acc_content():
        browser.get(list_of_hotel_urls[x])
        html = browser.page_source
        acc_soup_attrib = BeautifulSoup(html, 'html.parser')
        #acc_soup_attrib = BeautifulSoup((requests.get(list_of_hotel_urls[x])).content, 'lxml')
        #global data 
        #data = json.loads(acc_soup_attrib.find('script', type='application/ld+json').text)
        pprint(str(datetime.now() - startTime) + ": Wokring on " + str(x) + " hotel ")
        try:
            name = acc_soup_attrib.findAll("h1", {"class": "ui_header h1"})[0].text
            
        except(KeyError):
            name = 'NaN'
        try:        
            address = acc_soup_attrib.findAll("span", {"class": "detail ui_link level_4"})[0].text
        except(IndexError):
            address = 'NaN'
        try:
            rating = acc_soup_attrib.findAll("span", {"class": "hotels-hotel-review-about-with-photos-Reviews__overallRating--vElGA"})[0].text
        except(IndexError):
            rating = 'NaN'
        try:
            reviews = acc_soup_attrib.findAll("span", {"class": "hotels-hotel-review-about-with-photos-Reviews__seeAllReviews--3PpLR"})[0].text
            review_count, word = reviews.split()
        except(IndexError):
            review_count = 'NaN'
            
        host_name = {"name": name}
        df = pd.DataFrame.from_dict(host_name, orient='index')
        df = df.T
        
        
        df.loc[:, 'address'] = address
        df.loc[:, 'review_count'] = review_count
        df.loc[:, 'rating'] = rating
        #df.loc[:, 'bestrating'] = bestrating
        df.loc[:, 'url'] = list_of_hotel_urls[x]
        dataframes_list.append(df)
        print(str(datetime.now() - startTime) +": Wokring on " + str(x) + " table ")
    get_acc_content()
    while x < limit - 1:
        x = x + 1
        get_acc_content()

#GET THE NUMBER OF TOTAL PAGE THAT ARE GOING TO BE SCRAPED
#DONT FORGET TO ADD WEBDRIVER        
browser = webdriver.Chrome('ROOT TO WEBDRIVER')
browser.get(site)
html = browser.page_source
soup = BeautifulSoup(html, 'html.parser')

first_page = soup.findAll("a", {"class": "pageNum first taLnk "})
middle_pages = soup.findAll("a", {"class": "pageNum taLnk"})
last_page = soup.findAll("a", {"class": "pageNum last taLnk"})

pages = soup.findAll("div", {"class": "pageNumbers"})
pages_url = pages[0].find_all('a')



number_of_pages = int(pages_url[-1].text)

next_pages = list(range(2, number_of_pages + 1))

global nps
nps = []
pprint(n_sites)


def kokosino():
    x = -3
    def kokos(xxx):
        
        browser.get(xxx)
        html = browser.page_source
        soup = BeautifulSoup(html, 'html.parser')
        pages = soup.findAll("div", {"class": "pageNumbers"})
        new_pagination_divs = pages[0].find_all('a')
        

        def select_p():
            global next_pages
            next_pages = list(item for item in next_pages if item not in nps)
            print(next_pages)
            print(len(n_sites))
            for item in new_pagination_divs:
                if int(item.text) in next_pages:
                    print(int(item.text))
                    
                    #print(next_pages)
                    n_sites.append(tripadvisor_base_url + item['href'])
                    nps.append(int(item.text))
                    
        select_p()
      
    kokos(site)
    if int(number_of_pages) == len(n_sites) + 1:
        pass
    else:
        while len(n_sites) + 1 != int(number_of_pages):
            
            kokos(n_sites[x])
        else:
            kokos(n_sites[-1])


#CALLL THE FUNCTIONS
kokosino()  
n_sites.append(site)

pprint(n_sites)

get_acc_url()
print(len(list_of_hotel_urls))

get_acc()

datas = pd.concat(dataframes_list)
datas.reset_index(level=0, inplace=True)
print(datas)

#EXPORT THEM TO YOUR DATABASE
datas.to_sql('tripadvisortest', engine, if_exists='append')
print( "exported into database in: " + str(datetime.now() - startTime))


conn = engine.connect()

#DELETE DUPLICATES
stmt_delete_duplicates = "DELETE FROM tripadvisortest a USING tripadvisortest b WHERE a.ctid < b.ctid AND a.url = b.url;"
results = conn.execute(stmt_delete_duplicates)




#CREATE COLUMNS FOR GEOCODING
stmt = "alter table tripadvisortest add column lat double precision;"
results = conn.execute(stmt)
stmt = "alter table tripadvisortest add column lon double precision;"
results = conn.execute(stmt)
stmt = "alter table tripadvisortest add column google_address text;"
results = conn.execute(stmt)
stmt = "alter table tripadvisortest add column google_id text;"
results = conn.execute(stmt)

#RUN the altered version of shanealynn's python batch geocoding script the use google maps
#DO NOT FORGET TO ADD DB AND API CREDENTIALS
exec(open('shane_lynn_tripadvisor_google_geocoder.py').read())

#merge tripavisor extract wirh geocoded extract
#WARNING IN SOME CASE GOOGLE DOES NOT RECOGNIZE TRIPADVISOR'S INPUT ADDRESS 
stmt = "UPDATE tripadvisortest SET lat = subquery.latitude, lon = subquery.longitude, google_address = subquery.formatted_address, google_id = subquery.google_place_id FROM (SELECT * FROM  tripadvisortest a JOIN tripadvisor_geoceded b ON a.address = b.input_string) AS subquery WHERE tripadvisortest.level_0=subquery.level_0;"
results = conn.execute(stmt)

#Create the geographic variable as geom to tripadvisor's export
##BE AWARE OF THE SRIDS!!!!
stmt_geom_column = "alter table tripadvisortest add column geom geometry;"
results = conn.execute(stmt_geom_column)
stmt_geom_variable = "UPDATE tripadvisortest SET geom = subquery.geoma FROM (SELECT *, ST_SetSRID(ST_MakePoint(lon, lat),4326) as geoma from tripadvisortest) AS subquery WHERE tripadvisortest.url=subquery.url"
results = conn.execute(stmt_geom_variable)

#THIS PART is optional, it works for slovak adminisrative boundaries ID source: https://www.geoportal.sk/sk/zbgis_smd/na-stiahnutie/ just dowload the esri shp table and import to postgis
# The aim is to add official IDs of administrative segmentation
stmt = "alter table tripadvisortest add column district_id integer;"
results = conn.execute(stmt)
stmt = "alter table tripadvisortest add column region_id integer;"
results = conn.execute(stmt)
stmt = "alter table tripadvisortest add column municipality_id integer;"
results = conn.execute(stmt)
stmt = "alter table tripadvisortest add column district_name text;"
results = conn.execute(stmt)
stmt = "alter table tripadvisortest add column region_name text;"
results = conn.execute(stmt)
stmt = "alter table tripadvisortest add column municipality_name text;"
results = conn.execute(stmt)

#GET THE LIST OF ID FROM EXTRAXTED FB DATA
results = psql.read_sql("select array_agg('''' || level_0 || '''') from tripadvisortest;", conn_1)

gid = results['array_agg'].tolist()

conn_1.close()
#UPDATE ADMINISTRATIVE SEGMENATION FOR EACH PLACE VIA ST_WITHIN
conn = engine.connect()

def update_admin():
    x = 0
    stmt = "UPDATE tripadvisortest SET district_id = subquery.idn3, district_name = subquery.nm3, region_id = subquery.idn2, region_name = subquery.nm2, municipality_id = subquery.idn4, municipality_name = subquery.nm4 FROM (SELECT * FROM  tripadvisortest a JOIN obec_0 b ON ST_Within(ST_Transform(a.geom, 4326), ST_Transform(b.geom, 4326)) where a.level_0=" + gid[0][x] + ") AS subquery WHERE tripadvisortest.level_0=subquery.level_0;"
    results = conn.execute(stmt)
    print( str(x) + "is a success")
    while x < len(gid) - 1:
        x = x + 1
        stmt = "UPDATE tripadvisortest SET district_id = subquery.idn3, district_name = subquery.nm3, region_id = subquery.idn2, region_name = subquery.nm2, municipality_id = subquery.idn4, municipality_name = subquery.nm4 FROM (SELECT * FROM  tripadvisortest a JOIN obec_0 b ON ST_Within(ST_Transform(a.geom, 4326), ST_Transform(b.geom, 4326)) where a.level_0=" + gid[0][x] + ") AS subquery WHERE tripadvisortest.level_0=subquery.level_0;"
        results = conn.execute(stmt)
        print( str(x) + "is a success")


 
update_admin()



conn.close()

#AFTERWARDS YOU SHOULD CLEAN THE DATASET IN POSTGRES OF NONSENSE(bad tags, duplicate object with differently formatted names, duplicate object registrations, etc)
#the below example will help

#with words as (
#SELECT s.token, name
#FROM   tripadvisortest t, unnest(string_to_array(t.name, ' ')) s(token))
#select token, count(*)
#	from words
#	group by token
#	order by count desc
