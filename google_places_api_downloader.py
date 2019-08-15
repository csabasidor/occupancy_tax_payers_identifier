import requests
import json
import pandas as pd
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

#CREATE A TEMPORARY GRID WITH APPROPRIATE DISTANCES OVER THE CHOSEN POLYGON AREA
# CHANGE okres_0 to your table
# BE CAREFUL WIRH SRIDS
df2 = psql.read_sql("with base_grid as \
                        (SELECT I_Grid_Point_Distance(geom, 1000, 1000) as geom from okres_0 where idn3 in ('802', '803', '804', '805')) \
                    SELECT \
                        ST_X(ST_Transform(ST_SetSRID(ST_GeomFromText(ST_AsText( (ST_Dump(geom)).geom )), 102067), 4326)), \
                        ST_Y(ST_Transform(ST_SetSRID(ST_GeomFromText(ST_AsText( (ST_Dump(geom)).geom )), 102067), 4326)), \
                        ST_Transform(ST_SetSRID(ST_GeomFromText(ST_AsText( (ST_Dump(geom)).geom )), 102067), 4326) as geom \
                    from base_grid", conn_1)

df2 = pd.DataFrame(df2)
conn_1.close()

#CREATE A LIST FROM THE EXTRACTED GRID POINTS
c_or_lat_lon = [list(r) for r in df2[['st_y', 'st_x']].values]


#CREATE PARTS OF URLS FOR THE API TO CALL
text_search_url = "https://maps.googleapis.com/maps/api/place/textsearch/output?parameters"

#ADD YOUR API KEY
api_key = 'API KEY'

url_base = 'https://maps.googleapis.com/maps/api/place/'
search_type = 'nearbysearch/json?location='
url_and = '&'
dist = 'radius='
distance_m = '1000'
types = 'type='

#ENTER THE DESIRED CATEGORIES OF PLACES
types_n = 'lodging'
#keywords = 'keyword='
#keywords_n = 'burger'

keys = 'key='
next_p_url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
next_p = "pagetoken="



global list_of_base_urls
list_of_base_urls = []

global list_of_next_pages
list_of_next_pages = []

global dataframes_list
dataframes_list = []

# CREATE A SERACH URL FOR EACH POINT
def url_points():
    #print(len(c_or_lat_lon))
    x = 0
    url = url = url_base + search_type + str(c_or_lat_lon[x])[1:-1] + url_and + dist + distance_m + url_and + types + types_n + url_and + keys + api_key
    list_of_base_urls.append(url)
    print(url)
    while x < len(c_or_lat_lon) - 1:
        x = x + 1
        url = url = url_base + search_type + str(c_or_lat_lon[x])[1:-1] + url_and + dist + distance_m + url_and + types + types_n + url_and + keys + api_key
        list_of_base_urls.append(url)
        print(url)
    
url_points()


       
#CREATE PRIMITIVE FUNC TO PROCESS THE CALLS
def url_kokocinka():
    print("sleep 3 seconds")
    time.sleep(3)
    #EXTRACT THE INITIAL PAGES' CONTENT
    def page_content():
        
        x = 0
        req = requests.get(list_of_base_urls[url_x])
        global js
        js = req.json()
        global data
        data = js['results']
        
        if data == []:
            print("ZERO result in 1000m radius at url no. " + str(url_x) +" of " + str(len(list_of_base_urls)) + " at TIME " + str(datetime.now() - startTime))
            return
        else:
            limit = len(data)
            dataf(x)
        while x < limit - 1:
            x = x +1
            print("working on url no. " + str(url_x) +" of " + str(len(list_of_base_urls)) + " at TIME " + str(datetime.now() - startTime))
            dataf(x)
        if 'next_page_token' in js:
            next_p = js['next_page_token']
            #print(next_p)
            print("working on url no. " + str(url_x) +" of " + str(len(list_of_base_urls)) + " at TIME " + str(datetime.now() - startTime))
            next_pages()

#EXTRACT DATA TO A TABLE
    def dataf(x):
        
        def colls():
            df.loc[:,'id'] = id
            df.loc[:,'place_id'] = place_id
            df.loc[:,'name'] = name
            df.loc[:,'street'] = street
            df.loc[:,'rating_avg'] = rating_avg
            df.loc[:,'ratings_n'] = ratings_n
            #df.loc[:,'types'] = str(types)
            dataframes_list.append(df)
        try:      
            df = pd.DataFrame.from_dict(data[x]['geometry']['location'], orient='index')
            df = df.T
            id = data[x]['id']
            place_id = data[x]['place_id']
            name = data[x]['name']
            street = data[x]['vicinity']
        except(KeyError):
            street = 'NaN'        
        try:
            rating_avg = data[x]['rating']
        except(KeyError):
            rating_avg = 'NaN'
        try:
            ratings_n = data[x]['user_ratings_total']
        except(KeyError):
            ratings_n = 'NaN'
              
        
        colls()
#EXTRACT DATA FROM NEXT PAGES
       
    def next_pages():
        print("sleep 3 sec")
        time.sleep(3)
        list_of_next_pages.append(js['next_page_token'])
        new_url = next_p_url + keys + api_key + url_and + next_p + str(js['next_page_token'])
        print(new_url)
        req_paging = requests.get(str(new_url))
        js_paging = req_paging.json()
        global data
        data = js_paging['results']
        if data == []:
            return
        else:
            x = 0
            limit = len(data)
            dataf(x)
        while x < limit - 1:
            x = x +1
            dataf(x)
            
            
        if 'next_page_token' in js_paging:
            list_of_next_pages.append(js_paging['next_page_token'])
            print("sleep 3 sec")
            time.sleep(3)

            new_url = next_p_url + keys + api_key + url_and + next_p + js_paging['next_page_token']
            req_paging = requests.get(new_url)
                
            data = js_paging['results']
            if data == []:
                return
            else:
                x = 0
                limit = len(data)
                dataf(x)
            while x < limit - 1:
                x = x +1
                dataf(x)
                
            else:
                return
        
    url_x = 0
    page_content()
    while url_x < len(list_of_base_urls) - 1:
        url_x = url_x + 1
        page_content()


url_kokocinka()

datas = pd.concat(dataframes_list)
datas.drop_duplicates(subset='id', keep="first")
datas.reset_index(level=0, inplace=True)




print(datas)

#DOWNLOAD THE EXTRACTED DATA TO YOUR DATABASE OR CSV
datas.to_sql('googleplacestest', engine, if_exists='append')
print( "exported into database " + str(datetime.now() - startTime))

conn = engine.connect()

#DELETE DUPLICATES
stmt_delete_duplicates = "DELETE FROM googleplacestest a USING googleplacestest b WHERE a.ctid < b.ctid AND a.id = b.id;"
results = conn.execute(stmt_delete_duplicates)


#Create the geographic variable as geom to facebookPlaceSearchAPI's export
##BE AWARE OF THE SRIDS!!!!
stmt_geom_column = "alter table googleplacestest add column geom geometry;"
results = conn.execute(stmt_geom_column)
stmt_geom_variable = "UPDATE googleplacestest SET geom = subquery.geoma FROM (SELECT *, ST_SetSRID(ST_MakePoint(lng, lat),4326) as geoma from googleplacestest) AS subquery WHERE googleplacestest.id=subquery.id;"
results = conn.execute(stmt_geom_variable)

#THIS PART is optional, it works for slovak adminisrative boundaries ID source: https://www.geoportal.sk/sk/zbgis_smd/na-stiahnutie/ just dowload the esri shp table and import to postgis
# The aim is to add official IDs of administrative segmentation

stmt = "alter table googleplacestest add column district_id integer;"
results = conn.execute(stmt)
stmt = "alter table googleplacestest add column region_id integer;"
results = conn.execute(stmt)
stmt = "alter table googleplacestest add column municipality_id integer;"
results = conn.execute(stmt)
stmt = "alter table googleplacestest add column district_name text;"
results = conn.execute(stmt)
stmt = "alter table googleplacestest add column region_name text;"
results = conn.execute(stmt)
stmt = "alter table googleplacestest add column municipality_name text;"
results = conn.execute(stmt)

#GET THE LIST OF ID FROM EXTRAXTED FB DATA
conn_1 = pg.connect("dbname=DATABASE_NAME user=USER_NAME host=HOST port=PORT password=PASSWORD")

results = psql.read_sql("select array_agg('''' || level_0 || '''') from googleplacestest;", conn_1)

gid = results['array_agg'].tolist()

#UPDATE ADMINISTRATIVE SEGMENATION FOR EACH PLACE VIA ST_WITHIN
def update_admin():
    x = 0
    stmt = "UPDATE googleplacestest SET district_id = subquery.idn3, district_name = subquery.nm3, region_id = subquery.idn2, region_name = subquery.nm2, municipality_id = subquery.idn4, municipality_name = subquery.nm4 FROM (SELECT * FROM  googleplacestest a JOIN obec_0 b ON ST_Within(ST_Transform(a.geom, 4326), ST_Transform(b.geom, 4326)) where a.level_0=" +gid[0][x] + ") AS subquery WHERE googleplacestest.level_0=subquery.level_0;"
    results = conn.execute(stmt)
    print( str(x) + "is a success")
    while x < len(gid[0]) - 1:
        x = x + 1
        stmt = "UPDATE googleplacestest SET district_id = subquery.idn3, district_name = subquery.nm3, region_id = subquery.idn2, region_name = subquery.nm2, municipality_id = subquery.idn4, municipality_name = subquery.nm4 FROM (SELECT * FROM  googleplacestest a JOIN obec_0 b ON ST_Within(ST_Transform(a.geom, 4326), ST_Transform(b.geom, 4326)) where a.level_0=" +gid[0][x] + ") AS subquery WHERE googleplacestest.level_0=subquery.level_0;"
        results = conn.execute(stmt)
        print( str(x) + "is a success")
update_admin()

conn_1.close()
conn.close()
#AFTERWARDS YOU SHOULD CLEAN THE DATASET IN POSTGRES OF NONSENSE(bad tags, duplicate object with differently formatted names, duplicate object registrations, etc)
#the below example will help suspicious objects


#with words as (
#SELECT s.token, name, id
#FROM   googleplacestest t, unnest(string_to_array(t.name, ' ')) s(token))
#select token, count(*)
	#from words
	#group by token
	#order by token desc
