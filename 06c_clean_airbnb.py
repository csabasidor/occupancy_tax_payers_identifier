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

#CREATE YOUR ENGINE 
engine = create_engine('postgresql+psycopg2://postgres:PASSWORD@HOST:PORT/DATABASE_NAME')

#CREATE A TEMPORARY CONNECTION
conn_1 = pg.connect("dbname=DATABASE_NAME user=USER_NAME host=HOST port=PORT password=PASSWORD")


conn = engine.connect()

#DELETE DUPLICATES
stmt_delete_duplicates = "DELETE FROM airbnbtest a USING bookingtest b WHERE a.ctid < b.ctid AND a.url = b.url;"
results = conn.execute(stmt_delete_duplicates)

#THIS PART IS OPTIONAL, AND WORKS ONLY PARIALY FOR ADMINISTRATIVE SEGMENTATION


 The aim is to add official IDs of administrative segmentation

stmt = "alter table airbnbtest add column district_id integer;"
results = conn.execute(stmt)
stmt = "alter table airbnbtest add column region_id integer;"
results = conn.execute(stmt)
stmt = "alter table airbnbtest add column municipality_id integer;"
results = conn.execute(stmt)
stmt = "alter table airbnbtest add column district_name text;"
results = conn.execute(stmt)
stmt = "alter table airbnbtest add column region_name text;"
results = conn.execute(stmt)
stmt = "alter table airbnbtest add column municipality_name text;"
results = conn.execute(stmt)


stmt = "alter table airbnbtest add column newcity text;"
results = conn.execute(stmt)

stmt = "update airbnbtest set newcity = t1.newcitys from (with fukme as (select  url, CASE WHEN city like '%mestská časť%' then split_part(city, 'mestská časť ', 2) WHEN city like '%-%' then split_part(city, '- ', 2) else city  END from airbnbtest order by city asc) select url as aaa, city as newcitys from fukme) t1 where airbnbtest.url = t1.aaa;"
results = conn.execute(stmt)

stmt = "UPDATE airbnbtest SET district_id = subquery.idn3, district_name = subquery.nm3, region_id = subquery.idn2, region_name = subquery.nm2, municipality_id = subquery.idn4, municipality_name = subquery.nm4 from (select *, split_part(nm4, '-', 2) nm from obec_0 where idn2 in('7', '8')) subquery where airbnbtest.newcity = subquery.nm"
results = conn.execute(stmt)

stmt = "alter table airbnbtest add column mms integer;"
results = conn.execute(stmt)


stmt = "update airbnbtest set member_since_month = 'january' where member_since_month ='leden';"
results = conn.execute(stmt)
stmt = "update airbnbtest set member_since_month = 'february' where member_since_month ='únor';"
results = conn.execute(stmt)
stmt = "update airbnbtest set member_since_month = 'march' where member_since_month ='březen';"
results = conn.execute(stmt)
stmt = "update airbnbtest set member_since_month = 'april' where member_since_month ='duben';"
results = conn.execute(stmt)
stmt = "update airbnbtest set member_since_month = 'may' where member_since_month ='květen';"
results = conn.execute(stmt)
stmt = "update airbnbtest set member_since_month = 'june' where member_since_month ='červen';"
results = conn.execute(stmt)
stmt = "update airbnbtest set member_since_month = 'july' where member_since_month ='červenec';"
results = conn.execute(stmt)
stmt = "update airbnbtest set member_since_month = 'august' where member_since_month ='srpen';"
results = conn.execute(stmt)
stmt = "update airbnbtest set member_since_month = 'september' where member_since_month ='září';"
results = conn.execute(stmt)
stmt = "update airbnbtest set member_since_month = 'october' where member_since_month ='říjen';"
results = conn.execute(stmt)
stmt = "update airbnbtest set member_since_month = 'november' where member_since_month ='listopad';"
results = conn.execute(stmt)
stmt = "update airbnbtest set member_since_month = 'december' where member_since_month ='prosinec';"
results = conn.execute(stmt)

stmt = "alter table airbnbtest add column mms integer;"
results = conn.execute(stmt)

stmt = "update airbnbtest set mms = '1' where member_since_month = 'january';"
results = conn.execute(stmt)
stmt = "update airbnbtest set mms = '2' where member_since_month = 'february';"
results = conn.execute(stmt)
stmt = "update airbnbtest set mms = '3' where member_since_month = 'march';"
results = conn.execute(stmt)
stmt = "update airbnbtest set mms = '4' where member_since_month = 'april';"
results = conn.execute(stmt)
stmt = "update airbnbtest set mms = '5' where member_since_month = 'may';"
results = conn.execute(stmt)
stmt = "update airbnbtest set mms = '6' where member_since_month = 'june';"
results = conn.execute(stmt)
stmt = "update airbnbtest set mms = '7' where member_since_month = 'july';"
results = conn.execute(stmt)
stmt = "update airbnbtest set mms = '8' where member_since_month = 'august';"
results = conn.execute(stmt)
stmt = "update airbnbtest set mms = '9' where member_since_month = 'september';"
results = conn.execute(stmt)
stmt = "update airbnbtest set mms = '10' where member_since_month = 'october';"
results = conn.execute(stmt)
stmt = "update airbnbtest set mms = '11' where member_since_month = 'november';"
results = conn.execute(stmt)
stmt = "update airbnbtest set mms = '12' where member_since_month = 'december';"
results = conn.execute(stmt)

stmt = "alter table airbnbtest add column since date;"
results = conn.execute(stmt)

stmt = "UPDATE airbnbtest SET since = subquery.sincdate from (select *, (member_since_year || '-' || mms || '-1')::date sincdate from airbnbtest) subquery where airbnbtest.url = subquery.url"
results = conn.execute(stmt)

conn.close()

