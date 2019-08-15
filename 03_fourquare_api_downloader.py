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
url_base = 'https://api.foursquare.com/v2/venues/explore?&'
client= 'client_id='
#ADD YOUR CLIENT ID
client_id = 'CLIENT ID'
secret = 'client_secret='
#ADD YOUR CLIENT SECRET
client_secret = 'CLIENTID'
version = 'v='
version_id = '20190726'
lan_lot = 'll='
radius = 'radius='
radius_id = '1000'
limit = 'limit='
limit_id = '50'
categories = 'categoryId='
#ENTER THE DESIRED CATEGORIES OF PLACES
category_id = "4bf58dd8d48988d1fa931735"
url_and = '&'
intent = 'intent=global'




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
    url = url = url_base + categories + category_id + url_and + client + client_id + url_and + secret + client_secret + url_and + version + version_id + url_and + intent + url_and + lan_lot + str(c_or_lat_lon[x])[1:-1] + url_and + radius + radius_id + url_and + limit + limit_id
    list_of_base_urls.append(url)
    print(url)
    while x < len(c_or_lat_lon) - 1:
        x = x + 1
        url = url = url_base + categories + category_id + url_and + client + client_id + url_and + secret + client_secret + url_and + version + version_id + url_and + intent + url_and + lan_lot + str(c_or_lat_lon[x])[1:-1] + url_and + radius + radius_id + url_and + limit + limit_id
        list_of_base_urls.append(url)
        print(url)
    
url_points()

#CREATE PRIMITIVE FUNC TO PROCESS THE CALLS
def url_kokocinka():
        #EXTRACT THE INITIAL PAGES' CONTENT
    def page_content():
        
        x = 0
        req = requests.get(list_of_base_urls[url_x])
        global js
        js = req.json()
        pprint(js['response']['totalResults'])
        
        if js['response']['totalResults'] == 0:
            
            print("ZERO result in 1000m radius at url no. " + str(url_x) +" of " + str(len(list_of_base_urls)) + " at TIME " + str(datetime.now() - startTime))
            return
        else:
            global data
            data = js['response']['groups'][0]['items']
            limit = len(data)
            dataf(x)
        while x < limit - 1:
            x = x +1
            dataf(x)
        
#EXTRACT DATA TO A TABLE
    def dataf(x):
        print("working on url no. " + str(url_x) +" of " + str(len(list_of_base_urls)) + " at TIME " + str(datetime.now() - startTime))
        try:
            id = data[x]['venue']['id']
            name = data[x]['venue']['name']
            location = data[x]['venue']['location']
            category_id = data[x]['venue']['categories'][0]['id']
            category_name = data[x]['venue']['categories'][0]['name']
            cat_primary = data[x]['venue']['categories'][0]['primary']
            cat_short = data[x]['venue']['categories'][0]['shortName']
            photos_n = data[x]['venue']['photos']['count']
            photos_n = data[x]['venue']['photos']['count']

            df = pd.DataFrame.from_dict(location, orient = 'Index')

            df = df.T
            df = df.drop(['labeledLatLngs', 'formattedAddress'], axis =1)
            df.loc[:,'id'] = id
            df.loc[:,'name'] = name
            df.loc[:,'category_id'] = category_id
            df.loc[:,'category_name'] = category_name
            df.loc[:,'cat_primary'] = cat_primary
            df.loc[:,'cat_short'] = cat_short       
            df.loc[:, 'photos'] = photos_n
            dataframes_list.append(df)
        except(KeyError):
            website = 'NaN'   

  
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
datas.to_sql('forsquaretest', engine, if_exists='append')
print( "exported into database " + str(datetime.now() - startTime)) 

conn = engine.connect()

#Delete duplicate rows in forsquare's export;
stmt_delete_duplicates = "DELETE FROM googleplacestest a USING forsquaretest b WHERE a.ctid < b.ctid AND a.id = b.id;"
results = conn.execute(stmt_delete_duplicates)

#Create the geographic variable as geom to foursquare's export
##BE AWARE OF THE SRIDS!!!!
stmt_geom_column = "alter table forsquaretest add column geom geometry;"
results = conn.execute(stmt_geom_column)
stmt_geom_variable = "UPDATE forsquaretest SET geom = subquery.geoma FROM (SELECT *, ST_SetSRID(ST_MakePoint(lng, lat),4326) as geoma from forsquaretest) AS subquery WHERE forsquaretest.id=subquery.id;"
results = conn.execute(stmt_geom_variable)

#THIS PART is optional, it works for slovak adminisrative boundaries ID source: https://www.geoportal.sk/sk/zbgis_smd/na-stiahnutie/ just dowload the esri shp table and import to postgis
# The aim is to add official IDs of administrative segmentation

stmt = "alter table forsquaretest add column district_id integer;"
results = conn.execute(stmt)
stmt = "alter table forsquaretest add column region_id integer;"
results = conn.execute(stmt)
stmt = "alter table forsquaretest add column municipality_id integer;"
results = conn.execute(stmt)
stmt = "alter table forsquaretest add column district_name text;"
results = conn.execute(stmt)
stmt = "alter table forsquaretest add column region_name text;"
results = conn.execute(stmt)
stmt = "alter table forsquaretest add column municipality_name text;"
results = conn.execute(stmt)

#GET THE LIST OF ID FROM EXTRAXTED FB DATA
conn_1 = pg.connect("dbname=DATABASE_NAME user=USER_NAME host=HOST port=PORT password=PASSWORD")

results = psql.read_sql("select array_agg('''' || level_0 || '''') from forsquaretest;", conn_1)

gid = results['array_agg'].tolist()


def update_admin():
    x = 0
    stmt = "UPDATE forsquaretest SET district_id = subquery.idn3, district_name = subquery.nm3, region_id = subquery.idn2, region_name = subquery.nm2, municipality_id = subquery.idn4, municipality_name = subquery.nm4 FROM (SELECT * FROM  forsquaretest a JOIN obec_0 b ON ST_Within(ST_Transform(a.geom, 4326), ST_Transform(b.geom, 4326)) where a.level_0=" +gid[0][x] + ") AS subquery WHERE forsquaretest.level_0=subquery.level_0;"
    results = conn.execute(stmt)
    print( str(x) + "is a success")
    while x < len(gid) - 1:
        x = x + 1
        stmt = "UPDATE forsquaretest SET district_id = subquery.idn3, district_name = subquery.nm3, region_id = subquery.idn2, region_name = subquery.nm2, municipality_id = subquery.idn4, municipality_name = subquery.nm4 FROM (SELECT * FROM  forsquaretest a JOIN obec_0 b ON ST_Within(ST_Transform(a.geom, 4326), ST_Transform(b.geom, 4326)) where a.level_0=" +gid[0][x] + ") AS subquery WHERE forsquaretest.level_0=subquery.level_0;"
        results = conn.execute(stmt)
        print( str(x) + "is a success")


 
update_admin()


conn_1.close()
conn.close()


#AFTERWARDS YOU SHOULD CLEAN THE DATASET IN POSTGRES OF NONSENSE(bad tags, duplicate object with differently formatted names, duplicate object registrations, etc)
#the below example will help suspicious objects


#with words as (
#SELECT s.token, name, id
#FROM   forsquaretest t, unnest(string_to_array(t.name, ' ')) s(token))
#select token, count(*)
	#from words
	#group by token
	#order by token desc
