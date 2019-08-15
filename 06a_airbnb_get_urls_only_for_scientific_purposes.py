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



global list_acc_urls
list_acc_urls = []

global n_sites
n_sites = []

global dataframes_list
dataframes_list = []

#GO TO AIRBNB.COM ENTER SEARCHED CITY AND PASE THE SEARCH SITE
#EXAMPLE ON KOSICE
site = "https://cs.airbnb.com/s/Ko%C5%A1ice--Slovensko/homes?refinement_paths%5B%5D=%2Fhomes&query=Ko%C5%A1ice%2C%20Slovensko&place_id=ChIJe5XGZxvgPkcR0IuXxtH3AAQ&search_type=unknown&map_toggle=false&s_tag=71vp9dXz"

airbnb_base_url = "https://cs.airbnb.com"

#GET THE NUMBER OF TOTAL PAGES THAT ARE GOING TO BE SCRAPED
browser = webdriver.Chrome('ADD ROOT TO WEBDRIVER') #ADD ROOT TO WEBDRIVER
browser.get(site)
SCROLL_PAUSE_TIME = 0.5

# Get scroll height
last_height = browser.execute_script("return document.body.scrollHeight")

while True:
    # Scroll down to bottom
    browser.execute_script("window.scrollTo(0, document.body.scrollHeight);")

    # Wait to load page
    time.sleep(SCROLL_PAUSE_TIME)

    # Calculate new scroll height and compare with last scroll height
    new_height = browser.execute_script("return document.body.scrollHeight")
    if new_height == last_height:
        break
    last_height = new_height


html = browser.page_source
soup = BeautifulSoup(html, 'html.parser')
acc_divs = soup.findAll("a", {"class": "_1ol0z3h"})
#acc_urls = acc_divs.findAll("a")

for item in acc_divs:
    list_acc_urls.append(airbnb_base_url + item['href'])

print(list_acc_urls[0])    

#SINCE AT BULK CONNECTIONS AIRBNB SHUTS YOU DOWN, DUMP THE LINKS TO a plain text file
with open('beta.l_acc_url.txt', 'w') as f:
    for item in list_acc_urls:
        f.write("%s\n" % item)

browser.close()
browser.quit()

#CONTINUE TO airbnb_get_acc_only_for_scientific_purposes.py
