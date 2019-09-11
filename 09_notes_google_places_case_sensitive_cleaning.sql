alter table googleplacestest add column district_id integer;
alter table googleplacestest add column region_id integer;
alter table googleplacestest add column municipality_id integer;

alter table googleplacestest add column district_name text;
alter table googleplacestest add column region_name text;
alter table googleplacestest add column municipality_name text;

select array_agg('''' || level_0 || '''')
from googleplacestest

UPDATE googleplacestest
SET district_id = subquery.idn3,
district_name = subquery.nm3,
region_id = subquery.idn2,
region_name = subquery.nm2,
municipality_id = subquery.idn4,
municipality_name = subquery.nm4
FROM (SELECT *
FROM  googleplacestest a 

JOIN obec_0 b ON 
             ST_Within(ST_Transform(a.geom, 4326), ST_Transform(b.geom, 4326))
where a.level_0 = '1'
) AS subquery
WHERE googleplacestest.level_0=subquery.level_0;


select district_name, count(*)
	from googleplacestest
	group by district_name
	order by count desc
	
with words_stuff as (
with words as (
SELECT s.token, name, id
FROM   googleplacestest t, unnest(string_to_array(t.name, ' ')) s(token))
select token, count(*)
	from words
	group by token
	order by count desc)
	select * from words_stuff where count > 1
	
select array_agg(''''|| id || '''') from googleplacestest where name like '%Apartment%'	
select * from googleplacestest where name like '%Penzión%'	


select * from googleplacestest

delete from googleplacestest where id = '0bbce3df890929f96a4504527e719f9e7811ec54'
delete from googleplacestest where id in ('a08783e573ad093d450594c73c8e8eaf532c038b', '5483e238f487effa5de1fdbeb49c6062f690446e', '7ad6feeceb68500b3308062174a61ead7cc3e8ff','81cd6024863e5535dcedb539f2f5722b6a6050e0')
delete from googleplacestest where id = '6f4cf8376f77a85f195203faacaa49b5a76412ae'
delete from googleplacestest where id in ('d6414a9d2dc3f0ab4589d86df7519e9e3337af46','706dfca70ce331e3d1cb028f0aa5b45acb1be7b2','dfcbb8eb85b453df96e3f39c8d579cb81e214582','13a84d7d6654f01ad538167f596f315df21b6bd0','24c9820093900c4b5eb5f8d087c5a87f0b9e1b6e')
delete from googleplacestest where id = '30600e575c0340f4a54a1de7fd166c25e48f2005'
delete from googleplacestest where id = 'a5c6c7614165936767c1871c4c459a094f765237'
delete from googleplacestest where id = 'b6a35c37a77a43553c185d381534bfea82f244d5'
delete from googleplacestest where id = '04593c26f92f12c2c8ea9b2133448f706650ae7d'
delete from googleplacestest where id = '78e783546d5e858b61e0b55a552607791bebb027'
delete from googleplacestest where id = '27114cd744f21d0a96eca946502aa4bc92a89749'
delete from googleplacestest where id = 'fd37095c84bb8c73f2905d7b733c3dabbef0671b'
delete from googleplacestest where id = 'b6d6e65dd8902a013b8f58ef0aa1fbb7a0c36dd2'


delete from googleplacestest where name in ('nova terasa 3', 'Espresso MIHY', 'Reštaurácia pod Lipou', 'JALA s.r.o.', 'kosice') 
delete from googleplacestest where name in ('Bear lake', 'CITY BUILDING Ltd.', 'Bývalé kasárne - Malinovského', 'Centrum voľného času Technik','Ravak','POZEMOK', 'Stredisko sociálnej pomoci mesta Košice', 'Torysa PUB', 'Tukigrill.sk donášková služba a rozvoz grilovaných kurčiat', 'Železničky južná trieda', 'Отель Кошице', 'Úrad Vlády SR')

select district_name, count(*)
	from googleplacestest
	group by district_name
	order by count desc
