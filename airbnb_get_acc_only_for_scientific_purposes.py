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


global list_acc_urls
list_acc_urls = []

global dataframes_list
dataframes_list = []


with open('l_acc_url.txt', 'r') as f:
    for item in f:
        list_acc_urls.append(item)


pprint(len(list_acc_urls))


#YOU RUN THE SCRIPT BY GROUPS OF MAX 50 LINKS per 2 hours
#DIVIDE THE list_acc_urls into groups of 50s and run the script every 2hours

#list_acc_urls = list_acc_urls[0:51]
#pprint(len(list_acc_urls1))
#list_acc_urls = list_acc_urls[51:102]

#list_acc_urls = list_acc_urls[102:153]
#list_acc_urls = list_acc_urls[153:204]

#list_acc_urls = list_acc_urls[204:255]
#list_acc_urls = list_acc_urls[227:255]

list_acc_urls = list_acc_urls[255:]






#GET THE CONTENT OF PAGES THAT ARE GOING TO BE SCRAPED
browser = webdriver.Chrome('ADD ROOT TO WEBDRIVER') #ADD ROOT TO WEBDRIVER
def get_acc():
    x = 0
    def get_acc_data():    
        browser.get(list_acc_urls[x])
        pprint(str(datetime.now() - startTime) + ": Wokring on " + str(x) + " hotel from " + str(len(list_acc_urls)))

        html = browser.page_source
        soup = BeautifulSoup(html, 'html.parser')

        city = soup.findAll("div", {"class": "_czm8crp"})

        #print(str(city))
        try:
            host = soup.findAll("div", {"class": "_8b6uza1"})
            host = host[0].text
        except(IndexError):
            host = 'NaN'
        host_name = {"host": host}
        #print(host_name)
        
        name = soup.findAll("span", {"class": "_18hrqvin"})
        name = name[0].text
        city = soup.findAll("div", {"class": "_czm8crp"})
        city = city[0].text
        reviews= soup.findAll("span", {"class": "_s1tlw0m"})
        reviews = reviews[0].text
        size = soup.findAll("div", {"class": "_1p3joamp"})
        size = size[0].text
        try:
            rew_n, rew = reviews.split()
        except(ValueError):
            rew_n= 'NaN'
        #print(rew_n)
        try:            
            rating = soup.findAll("div", {"itemprop": "ratingValue"})
            rating = rating[0]['content']
        except(IndexError):
            rating = 'NaN'
        #print(host)
        #print(name)
        #print(city)
        #print(reviews)
        #print(rating)
        import re

        since = soup.findAll("div", text=re.match(r'W+', 'Členem'), attrs = {"class": "_czm8crp"})

        for item in since:
            if "Členem" in str(item.text):
                try:
                    a, b = item.text.split("·")
                    print(b)
                    print(b)
                    ax, ay = b.split(":")
                    print(ay)
                    member_since_month, member_since_year = ay.split()
                except(ValueError):
                     a, b = item.text.split(":")
                     member_since_month, member_since_year = b.split()
                     print(member_since_month)
                     print(member_since_year)
            else:
                pass

        df = pd.DataFrame.from_dict(host_name, orient='Index')
        df = df.T
        df.loc[:, 'name'] = name
        df.loc[:, 'city'] = city
        df.loc[:, 'reviews'] = rew_n
        df.loc[:, 'rating'] = rating
        df.loc[:, 'member_since_month'] = member_since_month
        df.loc[:, 'member_since_year'] = member_since_year
        df.loc[:, 'size'] = size
        df.loc[:, 'url'] = list_acc_urls[x]
        

        #print(df)
        dataframes_list.append(df)
    get_acc_data()
    while x < len(list_acc_urls) - 1:
        x = x +1
        get_acc_data()
get_acc()
        
                        




datas = pd.concat(dataframes_list)
datas.reset_index(level=0, inplace=True)
print(datas)


#EXPORT THEM TO YOUR DATABASE
	
datas.to_sql('airbnbtest', engine, if_exists='append')
print( "exported into database in: " + str(datetime.now() - startTime))

#AFTER COMPLETING THE WHOLE LIST CONTINUE TO clean_airbnb.py
