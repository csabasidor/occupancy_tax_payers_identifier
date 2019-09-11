alter table afbplacetest add column geom geometry;
UPDATE afbplacetest;
SET geom = subquery.geoma  
FROM (SELECT *, ST_SetSRID(ST_MakePoint(longitude, latitude),4326) as geoma
	  from afbplacetest) AS subquery
WHERE afbplacetest.level_0=subquery.level_0;



alter table afbplacetest add column district_id integer;
alter table afbplacetest add column region_id integer;
alter table afbplacetest add column municipality_id integer;

alter table afbplacetest add column district_name text;
alter table afbplacetest add column region_name text;
alter table afbplacetest add column municipality_name text;

select array_agg('''' || level_0 || '''') from afbplacetest

--OPEN update update_admin.py
UPDATE afbplacetest
SET district_id = subquery.idn3,
district_name = subquery.nm3,
region_id = subquery.idn2,
region_name = subquery.nm2,
municipality_id = subquery.idn4,
municipality_name = subquery.nm4
FROM (SELECT *
FROM  afbplacetest a 

JOIN obec_0 b ON 
             ST_Within(ST_Transform(a.geom, 4326), ST_Transform(b.geom, 4326))
where a.level_0 = '0'
) AS subquery
WHERE afbplacetest.level_0=subquery.level_0;

select district_name, count(*) from afbplacetest
group by district_name
order by district_name

select name, count(*) from afbplacetest 
	group by name
	order by name asc

--DROP duplicate nonsense, old and duplicate places

with words as (
SELECT s.token, name, id
FROM   afbplacetest t, unnest(string_to_array(t.name, ' ')) s(token))
select token, count(*)
	from words
	group by token
	order by count desc;

delete from afbplacetest where level_0 in ('67', '82') --Centrum duplicates;
delete from afbplacetest where level_0 in ('116', '148') -- Yasmin duplicates;
delete from afbplacetest where level_0 in ('73') -- Hilton duplicate;
delete from afbplacetest where level_0 in ('66', '72')  --zlaty dukaty duplicates;
delete from afbplacetest where level_0 in ('107') -- Maraton duplicate;
delete from afbplacetest where name in ('Career International') -- work agency;
delete from afbplacetest where level_0 in ('87') -- M10 duplicate;
delete from afbplacetest where level_0 in ('147') -- chorvatsko;
delete from afbplacetest where level_0 in ('97') -- Beryl duplicate;
delete from afbplacetest where level_0 in ('84') -- Chrysso duplicate;
delete from afbplacetest where level_0 in ('96') -- Hradbova duplicate;
delete from afbplacetest where level_0 in ('69') -- Teledom duplicate;
delete from afbplacetest where level_0 in ('8') -- Vila Terrasse duplicate;
delete from afbplacetest where name in ('Ubytovanie v Tokaji - Gazdovská pivnica') -- ;
delete from afbplacetest where name in ('Ubytovanie v Tokaji - Gazdovská pivnica') -- ;
delete from afbplacetest where name in ('Turistická ubytovňa K2 Metropol', 'Ludovy Hostinec', 'Maxiss Tahanovce', 'Bellys cottage');

select * from afbplacetest where name like '%Vila%';

select name, split_part(name, 'Hotel', 2) from afbplacetest;

with words as (
SELECT s.token, name, id
FROM   afbplacetest t, unnest(string_to_array(t.name, ' ')) s(token))
select token, count(*)
	from words
	group by token
	order by token desc;

select * from afbplacetest where name like '%Tokaji%';
