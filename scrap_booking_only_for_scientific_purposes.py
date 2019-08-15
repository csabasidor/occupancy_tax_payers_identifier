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



booking_base_url = "https://www.booking.com"



global list_of_base_urls
list_of_hotel_urls = []

global n_sites
n_sites = []

global dataframes_list
dataframes_list = []

#GO TO BOOKING.COM ENTER SEARCHED CITY AND PASE THE SEARCH SITE
#EXAMPLE ON KOSICE
site = "https://www.booking.com/searchresults.html?label=gen173nr-1FCAEoggI46AdIM1gEaM0BiAEBmAExuAEXyAEM2AEB6AEB-AECiAIBqAIDuALxoZ_qBcACAQ&lang=en-us&sid=34c3a96ef0da2db70da029c9d5908177&sb=1&src=searchresults&src_elem=sb&error_url=https%3A%2F%2Fwww.booking.com%2Fsearchresults.html%3Flabel%3Dgen173nr-1FCAEoggI46AdIM1gEaM0BiAEBmAExuAEXyAEM2AEB6AEB-AECiAIBqAIDuALxoZ_qBcACAQ%3Bsid%3D34c3a96ef0da2db70da029c9d5908177%3Btmpl%3Dsearchresults%3Bac_click_type%3Db%3Bac_position%3D0%3Bcity%3D-843247%3Bclass_interval%3D1%3Bdest_id%3D-553173%3Bdest_type%3Dcity%3Bdtdisc%3D0%3Bfrom_sf%3D1%3Bgroup_adults%3D2%3Bgroup_children%3D0%3Biata%3DPRG%3Binac%3D0%3Bindex_postcard%3D0%3Blabel_click%3Dundef%3Bno_rooms%3D1%3Boffset%3D0%3Bpostcard%3D0%3Braw_dest_type%3Dcity%3Broom1%3DA%252CA%3Bsb_price_type%3Dtotal%3Bsearch_selected%3D1%3Bshw_aparth%3D1%3Bslp_r_match%3D0%3Bsrc%3Dsearchresults%3Bsrc_elem%3Dsb%3Bsrpvid%3D551f3450567e005f%3Bss%3DPrague%252C%2520Czech%2520Republic%3Bss_all%3D0%3Bss_raw%3DPra%3Bssb%3Dempty%3Bsshis%3D0%3Bssne%3DKo%25C5%25A1ice%3Bssne_untouched%3DKo%25C5%25A1ice%26%3B&ss=Trebi%C5%A1ov%2C+Ko%C5%A1ick%C3%BD+kraj%2C+Slovakia&is_ski_area=&ssne=Prague&ssne_untouched=Prague&city=-553173&checkin_year=&checkin_month=&checkout_year=&checkout_month=&group_adults=2&group_children=0&no_rooms=1&from_sf=1&ss_raw=tREBIS&ac_position=1&ac_langcode=en&ac_click_type=b&dest_id=-846570&dest_type=city&place_id_lat=48.62862&place_id_lon=21.72017&search_pageview_id=551f3450567e005f&search_selected=true&search_pageview_id=551f3450567e005f&ac_suggestion_list_length=5&ac_suggestion_theme_list_length=0"



#GET ALL OF THE HOTELS' URLS
def get_acc_url():
    
    x = 0
    limit = len(n_sites)
    
    print(str(datetime.now() - startTime) + ": working on site no. " + str(x+1) + " out of " + number_of_pages)
    def get_url():
        soup = BeautifulSoup((requests.get(n_sites[x])).content, 'lxml')
        acc_divs = soup.findAll("a", {"class": "hotel_name_link url"})
        y = 0
        limit = len(acc_divs)
        hotel_url = booking_base_url + str(acc_divs[y]['href'])
        list_of_hotel_urls.append(hotel_url)
        while y < limit - 1:
            y = y + 1
            hotel_url = booking_base_url + str(acc_divs[y]['href'])
            list_of_hotel_urls.append(hotel_url)
    get_url()
    while x < limit - 1:
        x = x + 1
        print(str(datetime.now() - startTime) + ": working on site no. " + str(x+1) + " out of " + number_of_pages)
        get_url()

                                                
#GET ALL OF THE HOTELS' BASE DATA
def get_acc():
    x = 0
    limit = len(list_of_hotel_urls)
    def get_acc_content():
        acc_soup_attrib = BeautifulSoup((requests.get(list_of_hotel_urls[x])).content, 'lxml')
        global data 
        data = json.loads(acc_soup_attrib.find('script', type='application/ld+json').text)
        pprint(str(datetime.now() - startTime) + ": Wokring on " + str(x) + " hotel ")
        try:
            acc_type = data['@type']
        except(KeyError):
            acc_type = 'NaN'
        try:        
            review_count = data['aggregateRating']['reviewCount']
        except(KeyError):
            review_count = 'NaN'
        try:
            rating = data['aggregateRating']['ratingValue']
        except(KeyError):
            rating = 'NaN'
        try:
            bestrating = data['aggregateRating']['bestRating']
        except(KeyError):
            best_rating = 'NaN'
            
        name = data['name']
        url = data['url']
        min_price = data['priceRange']
        df = pd.DataFrame.from_dict(data['address'], orient='index')
        df = df.T
        #df = df.drop(['streetAddress'], axis =1)
        df.loc[:, 'name'] = name 
        df.loc[:, 'acc_type'] = acc_type
        df.loc[:, 'review_count'] = review_count
        df.loc[:, 'rating'] = rating
        #df.loc[:, 'bestrating'] = bestrating
        df.loc[:, 'url'] = url
        dataframes_list.append(df)
        print(str(datetime.now() - startTime) +": Wokring on " + str(x) + " table ")
    get_acc_content()
    while x < limit - 1:
        x = x + 1
        get_acc_content()



#GET THE NUMBER OF TOTAL PAGES THAT ARE GOING TO BE SCRAPED
browser = webdriver.Chrome('ADD ROOT TO WEBDRIVER') #ADD ROOT TO WEBDRIVER
browser.get(site)
html = browser.page_source
soup = BeautifulSoup(html, 'html.parser')
pagination_divs = soup.findAll("a", {"class": "bui-pagination__link sr_pagination_link"})
global number_of_pages
number_of_pages = pagination_divs[-1].find("div", {"class": "bui-u-inline"}).text




next_pages = list(range(len(n_sites) + 1, int(number_of_pages) + 1))

global nps
nps = []



#GET ALL THE PAGE LINKS
def kokosino():
    x = -3
    def kokos(xxx):
        
        browser.get(xxx)
        html = browser.page_source
        soup = BeautifulSoup(html, 'html.parser')
        new_pagination_divs = soup.findAll("a", {"class": "bui-pagination__link sr_pagination_link"})
        

        def select_p():
            global next_pages
            next_pages = list(item for item in next_pages if item not in nps)
            print(next_pages)
            print(len(n_sites))
            for item in new_pagination_divs:
                if int(item.find("div", {"class": "bui-u-inline"}).text) in next_pages:
                    print(int(item.find("div", {"class": "bui-u-inline"}).text))
                    
                    #print(next_pages)
                    n_sites.append(booking_base_url + item['href'])
                    nps.append(int(item.find("div", {"class": "bui-u-inline"}).text))
                    
        select_p()
      
    kokos(site)
    if int(number_of_pages) < 9:
        pass
    else:
        while len(n_sites) != int(number_of_pages) - 2:
            
            kokos(n_sites[x])
        else:
            kokos(n_sites[-1])


#CALLL THE FUNCTIONS
kokosino()  
browser.quit()
get_acc_url()
get_acc()

#MERGE ALL THE TABLES
datas = pd.concat(dataframes_list)
datas.reset_index(level=0, inplace=True)
print(datas)


#EXPORT THEM TO YOUR DATABASE
datas.to_sql('bookingtest', engine, if_exists='append')
print( "exported into database in: " + str(datetime.now() - startTime))

conn = engine.connect()

#DELETE DUPLICATES
stmt_delete_duplicates = "DELETE FROM bookingtest a USING bookingtest b WHERE a.ctid < b.ctid AND a.url = b.url;"
results = conn.execute(stmt_delete_duplicates)

#CREATE COLUMNS FOR GEOCODING
stmt = "alter table bookingtest add column lat double precision;"
results = conn.execute(stmt)
stmt = "alter table bookingtest add column lon double precision;"
results = conn.execute(stmt)
stmt = "alter table bookingtest add column google_address text;"
results = conn.execute(stmt)
stmt = "alter table bookingtest add column google_id text;"
results = conn.execute(stmt)

#RUN the altered version of shanealynn's python batch geocoding script the use google maps
#DO NOT FORGET TO ADD DB AND API CREDENTIALS
exec(open('shane_lynn_booking_google_geocoder.py').read())

#merge booking extract wirh geocoded extract
stmt = "UPDATE bookingtest SET lat = subquery.latitude, lon = subquery.longitude, google_address = subquery.formatted_address, google_id = subquery.google_place_id FROM (SELECT * FROM  bookingtest a JOIN booking_geoceded b ON a.streetaddress = b.input_string) AS subquery WHERE bookingtest.level_0=subquery.level_0;"
results = conn.execute(stmt)

#Create the geographic variable as geom to bookings's export
##BE AWARE OF THE SRIDS!!!!
stmt_geom_column = "alter table bookingtest add column geom geometry;"
results = conn.execute(stmt_geom_column)
stmt_geom_variable = "UPDATE bookingtest SET geom = subquery.geoma FROM (SELECT *, ST_SetSRID(ST_MakePoint(lon, lat),4326) as geoma from bookingtest) AS subquery WHERE bookingtest.url=subquery.url;"
results = conn.execute(stmt_geom_variable)

#THIS PART is optional, it works for slovak adminisrative boundaries ID source: https://www.geoportal.sk/sk/zbgis_smd/na-stiahnutie/ just dowload the esri shp table and import to postgis
# The aim is to add official IDs of administrative segmentation

stmt = "alter table bookingtest add column district_id integer;"
results = conn.execute(stmt)
stmt = "alter table bookingtest add column region_id integer;"
results = conn.execute(stmt)
stmt = "alter table bookingtest add column municipality_id integer;"
results = conn.execute(stmt)
stmt = "alter table bookingtest add column district_name text;"
results = conn.execute(stmt)
stmt = "alter table bookingtest add column region_name text;"
results = conn.execute(stmt)
stmt = "alter table bookingtest add column municipality_name text;"
results = conn.execute(stmt)


#GET THE LIST OF ID FROM EXTRAXTED FB DATA
results = psql.read_sql("select array_agg('''' || level_0 || '''') from bookingtest;", conn_1)

gid = results['array_agg'].tolist()

conn_1.close()
#UPDATE ADMINISTRATIVE SEGMENATION FOR EACH PLACE VIA ST_WITHIN
conn = engine.connect()




def update_admin():
    x = 0
    stmt = "UPDATE bookingtest SET district_id = subquery.idn3, district_name = subquery.nm3, region_id = subquery.idn2, region_name = subquery.nm2, municipality_id = subquery.idn4, municipality_name = subquery.nm4 FROM (SELECT * FROM  bookingtest a JOIN obec_0 b ON ST_Within(ST_Transform(a.geom, 4326), ST_Transform(b.geom, 4326)) where a.level_0 =" + gid[0][x]+ ") AS subquery WHERE bookingtest.level_0=subquery.level_0;"
    results = conn.execute(stmt)
    print( str(x) + "is a success")
    while x < len(gid) - 1:
        x = x + 1
        stmt = "UPDATE bookingtest SET district_id = subquery.idn3, district_name = subquery.nm3, region_id = subquery.idn2, region_name = subquery.nm2, municipality_id = subquery.idn4, municipality_name = subquery.nm4 FROM (SELECT * FROM  bookingtest a JOIN obec_0 b ON ST_Within(ST_Transform(a.geom, 4326), ST_Transform(b.geom, 4326)) where a.level_0 =" + gid[0][x]+ ") AS subquery WHERE bookingtest.level_0=subquery.level_0;"
        results = conn.execute(stmt)
        print( str(x) + "is a success")
 
update_admin()



conn.close()

