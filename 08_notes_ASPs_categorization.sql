----FACEBOOK--------FACEBOOK--------FACEBOOK--------FACEBOOK--------FACEBOOK----
----HOTELS FACEBOOK----
create table fb_base_acc_categories as 
WITH fb_hotels AS (
with fb_hotels as 
(
select cast('Hotel' as text) as cat_acc, cast(null as text) as sub_cat_acc, 
	regexp_replace(unaccent(name), '[^a-zA-Z0-9]+|HOTEL|Hotel|hotel|official|website|Kosice|Slovakia' , ' ','g') sub_name,
	name, id, district_id, geom
from afbplacetest where name like '%Hotel%' and district_id in ('802', '803', '804', '805')
	or name like '%hotel%' and district_id in ('802', '803', '804', '805')
	or name like '%HOTEL%' and district_id in ('802', '803', '804', '805')
	or name like '%Hilton%' and district_id in ('802', '803', '804', '805')
order by sub_name
)
select id, name, 
	CASE 
		WHEN sub_name like '%Boutique%' and sub_cat_acc is null then regexp_replace(sub_name, 'Boutique', ' ', 'g')
		WHEN sub_name like '%Garni%' and sub_cat_acc is null then regexp_replace(sub_name, 'Garni', ' ', 'g') 
		WHEN sub_name like '%Congress%' and sub_cat_acc is null then regexp_replace(sub_name, 'Congress', ' ', 'g') 
	ELSE
		sub_name
	END,
	cat_acc, 
	CASE
		when sub_cat_acc is null and name like '%Boutique%' then 'Boutique' 
		when sub_cat_acc is null and name like '%Garni%' then 'Garni' 
		when sub_cat_acc is null and name like '%Congress%' then 'Congress' 
	ELSE
		sub_cat_acc
	END,
	district_id, geom
from fb_hotels
order by sub_name),

fb_pension AS (
----GUESTHOUSES PENSION FACEBOOK----
with fb_pensions as 
(
select cast('Pension' as text) as cat_acc, cast(null as text) as sub_cat_acc, 
	regexp_replace(unaccent(name), '[^a-zA-Z0-9]+|Pension|Penzion|Penzión|pension|Kosice' , ' ','g') sub_name, 
	name, id, district_id, geom
	from afbplacetest where 
	name like '%Pension%' and district_id in ('802', '803', '804', '805')
	or name like '%Penzion%' and district_id in ('802', '803', '804', '805')
	or name like '%Penzión%' and district_id in ('802', '803', '804', '805')
	or name like '%pension%' and district_id in ('802', '803', '804', '805')
	or name like '%regia%' and district_id in ('802', '803', '804', '805')
	or name like '%Thehan%' and district_id in ('802', '803', '804', '805')
order by sub_name
)
select id, name, sub_name, cat_acc, sub_cat_acc, district_id, geom
from fb_pensions),

fb_hostels AS (
----HOSTELS FACEBOOK----
with fb_hostels as 
(
select cast('Hostel' as text) as cat_acc, cast(null as text) as sub_cat_acc, 
	regexp_replace(unaccent(name), '[^a-zA-Z0-9]+|Hostel|hostel|Ubytovna|ubytovna|Turisticka|Vodna 1 Kosice' , ' ','g') sub_name, 
	name, id, district_id, geom
from afbplacetest where 
	name like '%Hostel%' and district_id in ('802', '803', '804', '805')
	or name like '%hostel%' and district_id in ('802', '803', '804', '805')
	or name like '%Ubytovňa%' and district_id in ('802', '803', '804', '805')
	or name like '%ubytovňa%' and district_id in ('802', '803', '804', '805')
	or name like '%Ubytovna%' and district_id in ('802', '803', '804', '805')
	or name like '%ubytovna%' and district_id in ('802', '803', '804', '805')
	or name like '%Inštitút vzdelávania veterinárnych lekárov%' and district_id in ('802', '803', '804', '805')
	or website = 'http://www.k2kosice.sk/' and district_id in ('802', '803', '804', '805')

order by sub_name
)
select id, name, sub_name, cat_acc, sub_cat_acc, district_id, geom
from fb_hostels),

fb_private AS (
----PRIVATE FACEBOOK----
WITH fb_private as (
select cast('Private' as text) as cat_acc, cast(null as text) as sub_cat_acc, 
	regexp_replace(unaccent(name), '[^a-zA-Z0-9]+' , ' ','g') sub_name, 
	name, id, district_id, geom
from afbplacetest where
	name like '%Apartman%' and district_id in ('802', '803', '804', '805')
	or name like '%Apartmany%' and district_id in ('802', '803', '804', '805')
	or name like '%Apartmány%' and district_id in ('802', '803', '804', '805')
	or name like '%Apartmán%' and district_id in ('802', '803', '804', '805')
	or name like '%apartmány%' and district_id in ('802', '803', '804', '805')
	or name like '%apartmán%' and district_id in ('802', '803', '804', '805')
	or name like '%Apartment%' and name not like '%Hotel%' and district_id in ('802', '803', '804', '805')
	or name like '%Apartments%' and district_id in ('802', '803', '804', '805')
	or name like '%apartment%' and district_id in ('802', '803', '804', '805')
	or name like '%apartments%' and district_id in ('802', '803', '804', '805')
	or name like '%Studio%' and district_id in ('802', '803', '804', '805')
order by sub_name
)
select id, name, 
	CASE 
		WHEN sub_name like '%Apartmany%' and sub_cat_acc is null then regexp_replace(sub_name, 'Apartmany', ' ', 'g')
		WHEN sub_name like '%Apartmány%' and sub_cat_acc is null then regexp_replace(sub_name, 'Apartmány', ' ', 'g') 
		WHEN sub_name like '%Apartmán%' and sub_cat_acc is null then regexp_replace(sub_name, 'Apartmán', ' ', 'g')
		WHEN sub_name like '%Apartman%' and sub_cat_acc is null then regexp_replace(sub_name, 'Apartman', ' ', 'g')
		WHEN sub_name like '%Apartments%' and sub_cat_acc is null then regexp_replace(sub_name, 'Apartments', ' ', 'g')
		WHEN sub_name like '%apartments%' and sub_cat_acc is null then regexp_replace(sub_name, 'apartments', ' ', 'g')
		WHEN sub_name like '%Apartment%' and sub_cat_acc is null then regexp_replace(sub_name, 'Apartment', ' ', 'g') 
		WHEN sub_name like '%Studio%' and sub_cat_acc is null then regexp_replace(sub_name, 'Studio', ' ', 'g') 

	ELSE
		sub_name
	END,
	cat_acc, 
	CASE
		when sub_cat_acc is null and name like '%Apartmány%' then 'Apartment House' 
		when sub_cat_acc is null and name like '%Apartmany%' then 'Apartment House' 
		when sub_cat_acc is null and name like '%Apartmán%' then 'Apartment'
		when sub_cat_acc is null and name like '%Apartman%' then 'Apartment'
		when sub_cat_acc is null and name like '%Apartments%' then 'Apartment House'
		when sub_cat_acc is null and name like '%apartments%' then 'Apartment House'
		when sub_cat_acc is null and name like '%Apartment%' then 'Apartment'
		when sub_cat_acc is null and name like '%Studio%' then 'Studio'
	ELSE
		sub_cat_acc
	END, 
	district_id, geom
from fb_private
order by sub_name
)
select * from fb_hotels
union all
select * from fb_pension
union all
select * from fb_hostels
union all
select * from fb_private


select * from afbplacetest where  
district_id in ('802', '803', '804', '805') and
name not like '%Penzión%' and 
name not like '%Penzion%' and 
name not like '%Pension%' and
name not like '%pension%' and
name not like '%Hotel%' and 
name not like '%hotel%' and
name not like '%Hostel%' and
name not like '%hostel%' and
name not like '%ubytovňa%' and
name not like '%Ubytovňa%' and
name not like '%Ubytovna%' and
name not like '%ubytovna%' and
name not like '%HOTEL%' and
name not like '%Hilton%' and
name not like '%Villa regia%' and
name not like '%Apartment%' and 
name not like '%Apartments%' and
name not like '%apartment%' and
name not like '%apartments%' and
name not like '%Apartman%' and 
name not like '%Apartmany%' and
name not like '%Apartmány%' and
name not like '%Apartmán%' and
name not like '%apartmány%' and
name not like '%apartmán%' and
name not like '%Studio%' and
name not like '%Thehan%' and
name not like '%Inštitút vzdelávania veterinárnych lekárov%' and
name not like '%Lacné ubytovanie v centre Košíc%' 


-----BOOKING---------BOOKING---------BOOKING---------BOOKING---------BOOKING---------BOOKING---------BOOKING----
-----HOTELS BOOKING
create table bk_base_acc_categories as
with bk_hotels AS (
with bk_hotels as 
(
select cast('Hotel' as text) as cat_acc, cast(null as text) as sub_cat_acc, 
	regexp_replace(unaccent(name), '[^a-zA-Z0-9]+|HOTEL|Hotel|hotel|official|website|Kosice|Slovakia' , ' ','g') sub_name, 
	name, level_0, district_id, geom
from bookingtest where name like '%Hotel%' and district_id in ('802', '803', '804', '805')
	or name like '%hotel%' and district_id in ('802', '803', '804', '805')
	or name like '%HOTEL%' and district_id in ('802', '803', '804', '805')
	or name like '%Hilton%' and district_id in ('802', '803', '804', '805')
	or name like '%Dália Dependance***%' and district_id in ('802', '803', '804', '805')
	
order by sub_name
)
select level_0, name, 
	CASE 
		WHEN sub_name like '%Boutique%' and sub_cat_acc is null then regexp_replace(sub_name, 'Boutique', ' ', 'g')
		WHEN sub_name like '%Garni%' and sub_cat_acc is null then regexp_replace(sub_name, 'Garni', ' ', 'g') 
		WHEN sub_name like '%Congress%' and sub_cat_acc is null then regexp_replace(sub_name, 'Congress', ' ', 'g')
		WHEN sub_name like '%Kongres%' and sub_cat_acc is null then regexp_replace(sub_name, 'Congress', ' ', 'g') 
	ELSE
		sub_name
	END,
	cat_acc, 
	CASE
		when sub_cat_acc is null and name like '%Boutique%' then 'Boutique' 
		when sub_cat_acc is null and name like '%Garni%' then 'Garni' 
		when sub_cat_acc is null and name like '%Congress%' then 'Congress'
		when sub_cat_acc is null and name like '%Kongres%' then 'Congress' 
		when sub_cat_acc is null and name like '%Dependance%' then 'Dependance' 
	ELSE
		sub_cat_acc
	END,
	district_id, geom
from bk_hotels
order by sub_name
),
bk_pension as (
-----GUESTHOUSES PENSIONS BOOKING-----

with bk_pensions as 
(
select cast('Pension' as text) as cat_acc, cast(null as text) as sub_cat_acc, 
	regexp_replace(unaccent(name), '[^a-zA-Z0-9]+|Pension|Penzion|Penzión|pension|Kosice|GUESTHOUSE|guesthouse|Slovakia' , ' ','g') sub_name,
	name, level_0, district_id, geom
	from bookingtest where 
	name like '%Pension%' and district_id in ('802', '803', '804', '805')
	or name like '%Penzion%' and district_id in ('802', '803', '804', '805')
	or name like '%Penzión%' and district_id in ('802', '803', '804', '805')
	or name like '%pension%' and district_id in ('802', '803', '804', '805')
	or name like '%regia%' and district_id in ('802', '803', '804', '805')
	or name like '%Thehan%' and district_id in ('802', '803', '804', '805')
	or name like '%penzion%' and district_id in ('802', '803', '804', '805')
	or name like '%GUESTHOUSE%' and district_id in ('802', '803', '804', '805')
	or name like '%guesthouse%' and district_id in ('802', '803', '804', '805')
order by sub_name
)
select level_0, name, sub_name, cat_acc, sub_cat_acc, district_id, geom
from bk_pensions
),

bk_camps AS (
-----CAMPS BOOKING-----

with bk_camps as 
(
select cast('Camp' as text) as cat_acc, cast(null as text) as sub_cat_acc, 
	regexp_replace(unaccent(name), '[^a-zA-Z0-9]+|camp|camping|kemp|kemping|Camp|Camping|Kemp|Kemping|Kosice|Slovakia' , ' ','g') sub_name,
	name, level_0, district_id, geom
	from bookingtest where 
	name like '%camp%' and district_id in ('802', '803', '804', '805')
	or name like '%camping%' and district_id in ('802', '803', '804', '805')
	or name like '%kemp%' and district_id in ('802', '803', '804', '805')
	or name like '%kemp%' and district_id in ('802', '803', '804', '805')
	or name like '%kemping%' and district_id in ('802', '803', '804', '805')
	or name like '%Camp%' and district_id in ('802', '803', '804', '805')
	or name like '%Camping%' and district_id in ('802', '803', '804', '805')
	or name like '%Kemping%' and district_id in ('802', '803', '804', '805')
order by sub_name
)
select level_0, name, sub_name, cat_acc, sub_cat_acc, district_id, geom
from bk_camps
),
-----HOSTELS BOOKING-----
bk_hostels as (
with bk_hostels as 
(
select cast('Hostel' as text) as cat_acc, cast(null as text) as sub_cat_acc, 
	regexp_replace(unaccent(name), '[^a-zA-Z0-9]+|Hostel|hostel|Ubytovna|ubytovna|Turisticka|Vodna 1 Kosice' , ' ','g') sub_name, 
	name, level_0, district_id, geom
from bookingtest where 
	name like '%Hostel%' and district_id in ('802', '803', '804', '805')
	or name like '%hostel%' and district_id in ('802', '803', '804', '805')
	or name like '%Ubytovňa%' and district_id in ('802', '803', '804', '805')
	or name like '%ubytovňa%' and district_id in ('802', '803', '804', '805')
	or name like '%Ubytovna%' and district_id in ('802', '803', '804', '805')
	or name like '%ubytovna%' and district_id in ('802', '803', '804', '805')
	or name like '%ŠD%' and district_id in ('802', '803', '804', '805')
	or name like '%WHITE CORAL CLUB%' and district_id in ('802', '803', '804', '805')


order by sub_name
)
select level_0, name, sub_name, cat_acc, 
	CASE
		when sub_cat_acc is null and name like '%ŠD%' then 'student home' 
	ELSE
		sub_cat_acc
	END, district_id, geom
from bk_hostels
order by sub_name
),
bk_private as (
-----PRIVATE MAIN BOOKING-----
WITH bk_private as (
select cast('Private' as text) as cat_acc, cast(null as text) as sub_cat_acc, 
	regexp_replace(unaccent(name), '[^a-zA-Z0-9]+' , ' ','g') sub_name, 
	name, level_0, district_id, geom
from bookingtest where
	name like '%Apartman%' and district_id in ('802', '803', '804', '805')
	or name like '%Apartmany%' and district_id in ('802', '803', '804', '805')
	or name like '%Apartmány%' and district_id in ('802', '803', '804', '805')
	or name like '%Apartmán%' and district_id in ('802', '803', '804', '805')
	or name like '%apartmány%' and district_id in ('802', '803', '804', '805')
	or name like '%apartmán%' and district_id in ('802', '803', '804', '805')
	or name like '%apartman%' and district_id in ('802', '803', '804', '805')
	or name like '%Apartment%' and name not like '%Hotel%' and district_id in ('802', '803', '804', '805')
	or name like '%Apartments%' and district_id in ('802', '803', '804', '805')
	or name like '%apartment%' and name not like '%Hotel%' and district_id in ('802', '803', '804', '805')
	or name like '%aparment%' and name not like '%Hotel%' and district_id in ('802', '803', '804', '805')
	or name like '%apartments%' and district_id in ('802', '803', '804', '805')
	or name like '%Appartment%' and district_id in ('802', '803', '804', '805')
	or name like '%APARTMENT%' and district_id in ('802', '803', '804', '805')
	or name like '%Apartmen%' and name not like '%Hotel%' and district_id in ('802', '803', '804', '805')
	or name like '%Villa Park Komenského%' and district_id in ('802', '803', '804', '805')
	or name like '%Villa%' and district_id in ('802', '803', '804', '805') and name not like ('Villa Park Komenského') and name not like ('%Penzion Villa%')
	or name like '%Vila%' and district_id in ('802', '803', '804', '805') and name not like ('Villa Park Komenského') and name not like ('%Penzion Villa%')
	or name like '%Studio%' and district_id in ('802', '803', '804', '805')
	or name like '%studio%' and district_id in ('802', '803', '804', '805')
	or name like '%Štúdio%' and district_id in ('802', '803', '804', '805')
	or name like '%štúdio%' and district_id in ('802', '803', '804', '805')
	or name like '%študio%' and district_id in ('802', '803', '804', '805')
	or name like '%Študio%' and district_id in ('802', '803', '804', '805')
	or name like 'House%' and district_id in ('802', '803', '804', '805')
	or name like '% dom%' and district_id in ('802', '803', '804', '805')
	or name like '%Apt%' and district_id in ('802', '803', '804', '805')
	or name like '%cottage%' and district_id in ('802', '803', '804', '805')
	or name like '%Cottage%' and district_id in ('802', '803', '804', '805')

order by name
)
select level_0, name, 
	CASE 
		WHEN sub_name like '%Apartmany%' and sub_cat_acc is null then regexp_replace(sub_name, 'Apartmany', ' ', 'g')
		WHEN sub_name like '%Apartmány%' and sub_cat_acc is null then regexp_replace(sub_name, 'Apartmány', ' ', 'g') 
		WHEN sub_name like '%Apartmán%' and sub_cat_acc is null then regexp_replace(sub_name, 'Apartmán', ' ', 'g')
		WHEN sub_name like '%Apartman%' and sub_cat_acc is null then regexp_replace(sub_name, 'Apartman', ' ', 'g')
		WHEN sub_name like '%Apartments%' and sub_cat_acc is null then regexp_replace(sub_name, 'Apartments', ' ', 'g')
		WHEN sub_name like '%apartments%' and sub_cat_acc is null then regexp_replace(sub_name, 'apartments', ' ', 'g')
		WHEN sub_name like '%Apartment%' and sub_cat_acc is null then regexp_replace(sub_name, 'Apartment', ' ', 'g') 
		WHEN sub_name like '%apartment%' and sub_cat_acc is null then regexp_replace(sub_name, 'apartment', ' ', 'g') 
		WHEN sub_name like '%apartman%' and sub_cat_acc is null then regexp_replace(sub_name, 'apartman', ' ', 'g') 
		WHEN sub_name like '%APARTMENT%' and sub_cat_acc is null then regexp_replace(sub_name, 'APARTMENT', ' ', 'g') 
		WHEN sub_name like '%Appartment%' and sub_cat_acc is null then regexp_replace(sub_name, 'Appartment', ' ', 'g') 
		WHEN sub_name like '%Apartmen%' and sub_cat_acc is null then regexp_replace(sub_name, 'Apartmen', ' ', 'g') 
		WHEN sub_name like '%Studio%' and sub_cat_acc is null then regexp_replace(sub_name, 'Studio', ' ', 'g') 
		WHEN sub_name like '%studio%' and sub_cat_acc is null then regexp_replace(sub_name, 'studio', ' ', 'g') 
		WHEN sub_name like '%Štúdio%' and sub_cat_acc is null then regexp_replace(sub_name, 'Štúdio', ' ', 'g') 
		WHEN sub_name like '%štúdio%' and sub_cat_acc is null then regexp_replace(sub_name, 'štúdio', ' ', 'g') 
		WHEN sub_name like '%študio%' and sub_cat_acc is null then regexp_replace(sub_name, 'študio', ' ', 'g') 
		WHEN sub_name like '%Študio%' and sub_cat_acc is null then regexp_replace(sub_name, 'Študio', ' ', 'g') 
		WHEN sub_name like '%Apt%' and sub_cat_acc is null then regexp_replace(sub_name, 'Apt', ' ', 'g') 
		


	ELSE
		sub_name
	END,
	cat_acc, 
	CASE
		when sub_cat_acc is null and name like '%Apartmány%' then 'Apartment House' 
		when sub_cat_acc is null and name like '%Apartmany%' then 'Apartment House' 
		when sub_cat_acc is null and name like '%Apartmán%' then 'Apartment'
		when sub_cat_acc is null and name like '%Apartman%' then 'Apartment'
		when sub_cat_acc is null and name like '%Apartments%' then 'Apartment House'
		when sub_cat_acc is null and name like '%apartments%' then 'Apartment House'
		when sub_cat_acc is null and name like '%apartment%' then 'Apartment'
		when sub_cat_acc is null and name like '%Apartmen%' then 'Apartment'
		when sub_cat_acc is null and name like '%apartman%' then 'Apartment'
		when sub_cat_acc is null and name like '%Apartment%' then 'Apartment'
		when sub_cat_acc is null and name like '%APARTMENT%' then 'Apartment'
		when sub_cat_acc is null and name like '%Appartment%' then 'Apartment'
		when sub_cat_acc is null and name like '%Studio%' then 'Studio'
		when sub_cat_acc is null and name like '%studio%' then 'Studio'
		when sub_cat_acc is null and name like '%Štúdio%' then 'Studio'
		when sub_cat_acc is null and name like '%štúdio%' then 'Studio'
		when sub_cat_acc is null and name like '%Študio%' then 'Studio'
		when sub_cat_acc is null and name like '%študio%' then 'Studio'
		when sub_cat_acc is null and name like '%Vila%' then 'Villa'
		when sub_cat_acc is null and name like '%Villa%' and name not like '%Park Komenského%' then 'Villa'
		when sub_cat_acc is null and name like 'House%' then 'House'
		when sub_cat_acc is null and name like '% dom%' then 'House'
		when sub_cat_acc is null and name like '% Apt%' then 'Apartment'
		when sub_cat_acc is null and name like '%cottage%' then 'Cottage'
		when sub_cat_acc is null and name like '%Cottage%' then 'Cottage'

		when sub_cat_acc is null and name like '%Villa Park Komenského%' then 'Apartment House'
	ELSE
		sub_cat_acc
	END, district_id, geom
from bk_private
order by name
),
bk_private_rest as (
-----PRIVATE REST BOOKING--
select level_0, name, name as subname, cast('Private' as text) as cat_acc, cast('Apartment' as text) as sub_cat_acc, district_id, geom from bookingtest where  
district_id in ('802', '803', '804', '805') and
name not like '%Hotel%' and 
name not like '%hotel%' and
name not like '%HOTEL%' and
name not like '%Hilton%' and
name not like '%Dependance%'
and
name not like '%Penzión%' and 
name not like '%Penzion%' and 
name not like '%Pension%' and
name not like '%pension%' and
name not like '%GUESTHOUSE%' and
name not like '%guesthouse%' and
name not like '%Villa regia%'
and
name not like '%Hostel%' and
name not like '%hostel%' and
name not like '%ubytovňa%' and
name not like '%Ubytovňa%' and
name not like '%Ubytovna%' and
name not like '%ubytovna%' and
name not like '%ŠD%' and
name not like '%WHITE CORAL CLUB%' 
and
name not like '%Camp%' and
name not like '%Camping%' and
name not like '%camping%' and
name not like '%camp%' and
name not like '%kemping%' and
name not like '%Kemping%' and
name not like '%Kemp%' and
name not like '%kemp%'
and
name not like '%Apartment%' and 
name not like '%Apartments%' and
name not like '%apartment%' and
name not like '%apartments%' and
name not like '%Apartman%' and 
name not like '%Apartmany%' and
name not like '%Apartmány%' and
name not like '%Apartmán%' and
name not like '%apartmány%' and
name not like '%apartmán%' and
name not like '%apartman%' and
name not like '%Studio%' and
name not like '%studio%' and
name not like '%Štúdio%' and
name not like '%štúdio%' and
name not like '%Študio%' and
name not like '%študio%' and
name not like '%Thehan%' and
name not like '%Apartmen%'  and
name not like '%aparment%'  and
name not like '%APARTMENT%' and
name not like '%Appartment%' and
name not like '%Apt%' and
name not like '%Villa Park Komenského%' and
name not like '%Villa%' and
name not like '%Vila%' and
name not like 'House%' and
name not like '%Villa%' 
and
name not like '%Cottage%' and
name not like '%cottage%' and
name <> 'Pekný dom' and
name <> 'City Residence Apartment Hotel'
order by name
)
select * from bk_hotels 
union all
select * from bk_pension
union all
select * from bk_camps
union all
select * from bk_hostels
union all
select * from bk_private
union all
select * from bk_private_rest
order by cat_acc, name
--------GOOGLE PLACES ---------------GOOGLE PLACES ---------------GOOGLE PLACES ---------------GOOGLE PLACES -------

--select * from googleplacestest where district_id in ('802', '803', '804', '805')
-----HOTELS GOOGLE PLACES-----
create table gg_base_acc_categories as
with gg_hotels as (
with gg_hotels as 
(
select cast('Hotel' as text) as cat_acc, cast(null as text) as sub_cat_acc, 
	regexp_replace(unaccent(name), '[^a-zA-Z0-9]+|HOTEL|Hotel|hotel|official|website|Kosice|Slovakia' , ' ','g') sub_name, 
	name, level_0, district_id, geom
from googleplacestest where name like '%Hotel%' and district_id in ('802', '803', '804', '805')
	or name like '%hotel%' and district_id in ('802', '803', '804', '805')
	or name like '%HOTEL%' and district_id in ('802', '803', '804', '805')
	or name like '%Hilton%' and district_id in ('802', '803', '804', '805')
	or name like '%Dália Dependance***%' and district_id in ('802', '803', '804', '805')
	or name in ('Zlaty Dukat', 'Gloria palace', 'Boutique Chrysso') and district_id in ('802', '803', '804', '805')

order by sub_name
)
select level_0, name, 
	CASE 
		WHEN sub_name like '%Boutique%' and sub_cat_acc is null then regexp_replace(sub_name, 'Boutique', ' ', 'g')
		WHEN sub_name like '%Garni%' and sub_cat_acc is null then regexp_replace(sub_name, 'Garni', ' ', 'g') 
		WHEN sub_name like '%Congress%' and sub_cat_acc is null then regexp_replace(sub_name, 'Congress', ' ', 'g')
		WHEN sub_name like '%Kongres%' and sub_cat_acc is null then regexp_replace(sub_name, 'Congress', ' ', 'g') 
	ELSE
		sub_name
	END,
	cat_acc, 
	CASE
		when sub_cat_acc is null and name like '%Boutique%' then 'Boutique' 
		when sub_cat_acc is null and name like '%Garni%' then 'Garni' 
		when sub_cat_acc is null and name like '%Congress%' then 'Congress'
		when sub_cat_acc is null and name like '%Kongres%' then 'Congress' 
		when sub_cat_acc is null and name like '%Dependance%' then 'Dependance' 
	ELSE
		sub_cat_acc
	END, district_id, geom
from gg_hotels
order by sub_name
),
gg_pension as (
-----GUESTHOUSE PENSIONS GOOGLE PLACES-----
with gg_pensions as 
(
select cast('Pension' as text) as cat_acc, cast(null as text) as sub_cat_acc, 
	regexp_replace(unaccent(name), '[^a-zA-Z0-9]+|Pension|Penzion|Penzión|pension|Kosice|GUESTHOUSE|guesthouse|Slovakia' , ' ','g') sub_name,
	name, level_0, district_id, geom
	from googleplacestest where 
	name like '%Pension%' and district_id in ('802', '803', '804', '805')
	or name like '%Penzion%' and district_id in ('802', '803', '804', '805')
	or name like '%Penzión%' and district_id in ('802', '803', '804', '805')
	or name like '%pension%' and district_id in ('802', '803', '804', '805')
	or name like '%regia%' and district_id in ('802', '803', '804', '805')
	or name like '%Thehan%' and district_id in ('802', '803', '804', '805')
	or name like '%penzion%' and district_id in ('802', '803', '804', '805')
	or name like '%GUESTHOUSE%' and district_id in ('802', '803', '804', '805')
	or name like '%guesthouse%' and district_id in ('802', '803', '804', '805')
	or name in ('Hradbová', 'Zlatý Jeleň', 'Horse Inn') and district_id in ('802', '803', '804', '805')
	

order by sub_name
)
select level_0, name, sub_name, cat_acc, sub_cat_acc, district_id, geom
from gg_pensions
),
gg_camps as (
-----CAMPS Google PLaces-----
with gg_camps as 
(
select cast('Camp' as text) as cat_acc, cast(null as text) as sub_cat_acc, 
	regexp_replace(unaccent(name), '[^a-zA-Z0-9]+|camp|camping|kemp|kemping|Camp|Camping|Kemp|Kemping|Kosice|Slovakia' , ' ','g') sub_name,
	name, level_0, district_id, geom
	from googleplacestest where 
	name like '%camp%' and district_id in ('802', '803', '804', '805')
	or name like '%camping%' and district_id in ('802', '803', '804', '805')
	or name like '%kemp%' and district_id in ('802', '803', '804', '805')
	or name like '%kemp%' and district_id in ('802', '803', '804', '805')
	or name like '%kemping%' and district_id in ('802', '803', '804', '805')
	or name like '%Camp%' and district_id in ('802', '803', '804', '805')
	or name like '%Camping%' and district_id in ('802', '803', '804', '805')
	or name like '%Kemping%' and district_id in ('802', '803', '804', '805')
order by sub_name
)
select level_0, name, sub_name, cat_acc, sub_cat_acc, district_id, geom
from gg_camps
),
gg_hostels as (
-----HOSTELS GOOGLE PLACES-----
with gg_hostels as 
(
select cast('Hostel' as text) as cat_acc, cast(null as text) as sub_cat_acc, 
	regexp_replace(unaccent(name), '[^a-zA-Z0-9]+|Hostel|hostel|Ubytovna|ubytovna|Turisticka|Vodna 1 Kosice' , ' ','g') sub_name, 
	name, level_0, district_id, geom
from googleplacestest where 
	name like '%Hostel%' and district_id in ('802', '803', '804', '805')
	or name like '%HOSTEL%' and district_id in ('802', '803', '804', '805')
	or name like '%hostel%' and district_id in ('802', '803', '804', '805')
	or name like '%Ubytovňa%' and district_id in ('802', '803', '804', '805')
	or name like '%ubytovňa%' and district_id in ('802', '803', '804', '805')
	or name like '%Ubytovna%' and district_id in ('802', '803', '804', '805')
	or name like '%ubytovna%' and district_id in ('802', '803', '804', '805')
	or name like '%ŠD%' and district_id in ('802', '803', '804', '805')
	or name like '%WHITE CORAL CLUB%' and district_id in ('802', '803', '804', '805')
	or name like '%Dormitory%' and district_id in ('802', '803', '804', '805')
	or name like '%Internat%' and district_id in ('802', '803', '804', '805')
	or name like '%Internáty%' and district_id in ('802', '803', '804', '805')
	or name like '%Internát%' and district_id in ('802', '803', '804', '805')
	or name like '%Institute%' and district_id in ('802', '803', '804', '805')
	or name like '%Internaty%' and district_id in ('802', '803', '804', '805')
	or name like '%internát%' and district_id in ('802', '803', '804', '805')
	or name like '%internat%' and district_id in ('802', '803', '804', '805')
	or name like '%Jedlíkova 13%' and district_id in ('802', '803', '804', '805')
	or name = 'Budget & Students' and district_id in ('802', '803', '804', '805')
	or name in ('Ubytovanie Jánošík Pub', 'City Building Ltd.') and district_id in ('802', '803', '804', '805')
order by sub_name
)
select level_0, name, sub_name, cat_acc, 
	CASE
		when sub_cat_acc is null and name like '%ŠD%' then 'student home' 
		when sub_cat_acc is null and name like '%Dormitory%' then 'student home' 
		when sub_cat_acc is null and name like '%Internat%' then 'student home' 
		when sub_cat_acc is null and name like '%Internáty%' then 'student home' 
		when sub_cat_acc is null and name like '%Institute%' then 'student home' 
		when sub_cat_acc is null and name like '%Internaty%' then 'student home' 
		when sub_cat_acc is null and name like '%Internát%' then 'student home' 
		when sub_cat_acc is null and name like '%internát%' then 'student home' 
		when sub_cat_acc is null and name like '%internat%' then 'student home' 
		when sub_cat_acc is null and name like '%Jedlíkova 13%' then 'student home' 

	ELSE
		sub_cat_acc
	END, district_id, geom
from gg_hostels
order by sub_cat_acc
),
gg_private as(
-----PRIVATE MAIN GOOGLE PLACES-----
WITH gg_private as (
select cast('Private' as text) as cat_acc, cast(null as text) as sub_cat_acc, 
	regexp_replace(unaccent(name), '[^a-zA-Z0-9]+' , ' ','g') sub_name, 
	name, level_0, district_id, geom
from googleplacestest where
	name like '%Apartman%' and district_id in ('802', '803', '804', '805')
	or name like '%Apartmany%' and district_id in ('802', '803', '804', '805')
	or name like '%Apartmány%' and district_id in ('802', '803', '804', '805')
	or name like '%Apartmán%' and district_id in ('802', '803', '804', '805')
	or name like '%apartmány%' and district_id in ('802', '803', '804', '805')
	or name like '%apartmán%' and district_id in ('802', '803', '804', '805')
	or name like '%apartman%' and district_id in ('802', '803', '804', '805')
	or name like '%Apartment%' and name not like '%Hotel%' and district_id in ('802', '803', '804', '805') 
	or name like '%Apartments%' and district_id in ('802', '803', '804', '805')
	or name like '%apartments%' and district_id in ('802', '803', '804', '805')
	or name like '%apartment%' and name not like '%Hotel%' and district_id in ('802', '803', '804', '805')
	or name like '%Appartment%' and district_id in ('802', '803', '804', '805')
	or name like '%APARTMENT%' and name not like '%Hotel%' and district_id in ('802', '803', '804', '805')
	or name like '%Apartmen%' and name not like '%Hotel%' and district_id in ('802', '803', '804', '805')
	or name like '%Villa Park Komenského%' and district_id in ('802', '803', '804', '805')
	or name like '%Villa%' and district_id in ('802', '803', '804', '805') and name not like ('Villa Park Komenského') and name not like ('%Penzion Villa%')
	or name like '%Vila%' and district_id in ('802', '803', '804', '805') and name not like ('Villa Park Komenského') and name not like ('%Penzion Villa%')
	or name like '%Studio%' and district_id in ('802', '803', '804', '805')
	or name like '%studio%' and district_id in ('802', '803', '804', '805')
	or name like '%Štúdio%' and district_id in ('802', '803', '804', '805')
	or name like '%štúdio%' and district_id in ('802', '803', '804', '805')
	or name like '%študio%' and district_id in ('802', '803', '804', '805')
	or name like '%Študio%' and district_id in ('802', '803', '804', '805')
	or name like 'House%' and district_id in ('802', '803', '804', '805')
	or name like '% dom%' and district_id in ('802', '803', '804', '805')
	or name like '%Apt%' and district_id in ('802', '803', '804', '805')
	or name like '%cottage%' and district_id in ('802', '803', '804', '805')
	or name like '%Cottage%' and district_id in ('802', '803', '804', '805')
	or name like '%Chata%' and district_id in ('802', '803', '804', '805')
	or name = 'Záhrada Zverina' and district_id in ('802', '803', '804', '805')
	
order by sub_name
)
select level_0, name, 
	CASE 
		WHEN sub_name like '%Apartmany%' and sub_cat_acc is null then regexp_replace(sub_name, 'Apartmany', ' ', 'g')
		WHEN sub_name like '%Apartmány%' and sub_cat_acc is null then regexp_replace(sub_name, 'Apartmány', ' ', 'g') 
		WHEN sub_name like '%Apartmán%' and sub_cat_acc is null then regexp_replace(sub_name, 'Apartmán', ' ', 'g')
		WHEN sub_name like '%Apartman%' and sub_cat_acc is null then regexp_replace(sub_name, 'Apartman', ' ', 'g')
		WHEN sub_name like '%Apartments%' and sub_cat_acc is null then regexp_replace(sub_name, 'Apartments', ' ', 'g')
		WHEN sub_name like '%apartments%' and sub_cat_acc is null then regexp_replace(sub_name, 'apartments', ' ', 'g')
		WHEN sub_name like '%Apartment%' and sub_cat_acc is null then regexp_replace(sub_name, 'Apartment', ' ', 'g') 
		WHEN sub_name like '%apartment%' and sub_cat_acc is null then regexp_replace(sub_name, 'apartment', ' ', 'g') 
		WHEN sub_name like '%apartman%' and sub_cat_acc is null then regexp_replace(sub_name, 'apartman', ' ', 'g') 
		WHEN sub_name like '%APARTMENT%' and sub_cat_acc is null then regexp_replace(sub_name, 'APARTMENT', ' ', 'g') 
		WHEN sub_name like '%Appartment%' and sub_cat_acc is null then regexp_replace(sub_name, 'Appartment', ' ', 'g') 
		WHEN sub_name like '%Apartmen%' and sub_cat_acc is null then regexp_replace(sub_name, 'Apartmen', ' ', 'g') 
		WHEN sub_name like '%Studio%' and sub_cat_acc is null then regexp_replace(sub_name, 'Studio', ' ', 'g') 
		WHEN sub_name like '%studio%' and sub_cat_acc is null then regexp_replace(sub_name, 'studio', ' ', 'g') 
		WHEN sub_name like '%Štúdio%' and sub_cat_acc is null then regexp_replace(sub_name, 'Štúdio', ' ', 'g') 
		WHEN sub_name like '%štúdio%' and sub_cat_acc is null then regexp_replace(sub_name, 'štúdio', ' ', 'g') 
		WHEN sub_name like '%študio%' and sub_cat_acc is null then regexp_replace(sub_name, 'študio', ' ', 'g') 
		WHEN sub_name like '%Študio%' and sub_cat_acc is null then regexp_replace(sub_name, 'Študio', ' ', 'g') 
		WHEN sub_name like '%Apt%' and sub_cat_acc is null then regexp_replace(sub_name, 'Apt', ' ', 'g') 
		
		
	ELSE
		sub_name
	END,
	cat_acc, 
	CASE
		when sub_cat_acc is null and name like '%Apartmány%' then 'Apartment House' 
		when sub_cat_acc is null and name like '%Apartmany%' then 'Apartment House' 
		when sub_cat_acc is null and name like '%Apartmán%' then 'Apartment'
		when sub_cat_acc is null and name like '%Apartman%' then 'Apartment'
		when sub_cat_acc is null and name like '%Apartments%' then 'Apartment House'
		when sub_cat_acc is null and name like '%apartments%' then 'Apartment House'
		when sub_cat_acc is null and name like '%apartment%' then 'Apartment'
		when sub_cat_acc is null and name like '%Apartmen%' then 'Apartment'
		when sub_cat_acc is null and name like '%apartman%' then 'Apartment'
		when sub_cat_acc is null and name like '%Apartment%' then 'Apartment'
		when sub_cat_acc is null and name like '%APARTMENT%' then 'Apartment'
		when sub_cat_acc is null and name like '%Appartment%' then 'Apartment'
		when sub_cat_acc is null and name like '%Studio%' then 'Studio'
		when sub_cat_acc is null and name like '%studio%' then 'Studio'
		when sub_cat_acc is null and name like '%Štúdio%' then 'Studio'
		when sub_cat_acc is null and name like '%štúdio%' then 'Studio'
		when sub_cat_acc is null and name like '%Študio%' then 'Studio'
		when sub_cat_acc is null and name like '%študio%' then 'Studio'
		when sub_cat_acc is null and name like '%Vila%' then 'Villa'
		when sub_cat_acc is null and name like '%Villa%' and name not like '%Park Komenského%' then 'Villa'
		when sub_cat_acc is null and name like 'House%' then 'House'
		when sub_cat_acc is null and name like '% dom%' then 'House'
		when sub_cat_acc is null and name like '% Apt%' then 'Apartment'
		when sub_cat_acc is null and name like '%cottage%' then 'Cottage'
		when sub_cat_acc is null and name like '%Cottage%' then 'Cottage'
		when sub_cat_acc is null and name like '%Chata%' then 'Cottage'
		when sub_cat_acc is null and name like '%chata%' then 'Cottage'
		when sub_cat_acc is null and name = 'Záhrada Zverina' then 'Cottage'

		when sub_cat_acc is null and name like '%Villa Park Komenského%' then 'Apartment House'
	ELSE
		sub_cat_acc
	END, district_id, geom
from gg_private
order by sub_cat_acc
), 
gg_private_rest as (
select level_0, name, name as subname, cast('Private' as text) as cat_acc, cast('Apartment' as text) as sub_cat_acc, district_id, geom 
from googleplacestest where  
district_id in ('802', '803', '804', '805') and
name not like '%Hotel%' and 
name not like '%hotel%' and
name not like '%HOTEL%' and
name not like '%Hilton%' and
name not like '%Dependance%' and
name not in ('Zlaty Dukat', 'Gloria palace', 'Boutique Chrysso')
and
name not like '%Penzión%' and 
name not like '%Penzion%' and 
name not like '%Pension%' and
name not like '%pension%' and
name not like '%GUESTHOUSE%' and
name not like '%guesthouse%' and
name not like '%Villa regia%' and
name not like '%Zlatý Jeleň%' and
name not like '%Horse Inn%' and
name <> 'Hradbová'
and
name not like '%Hostel%' and
name not like '%hostel%' and
name not like '%ubytovňa%' and
name not like '%Ubytovňa%' and
name not like '%Ubytovna%' and
name not like '%ubytovna%' and
name not like '%HOSTEL%' and
name not like '%ŠD%' and
name not like '%WHITE CORAL CLUB%' and
name not like '%Internaty%' and
name not like '%Dormitory%' and
name not like '%Internat%' and
name not like '%Internát%' and
name not like '%Internáty%' and
name not like '%internát%' and
name not like '%internat%' and
name not like '%Institute%' and
name not like 'Jedlíkova 13' and
name <> 'Budget & Students' and
name <> 'City Building Ltd.' and
name <> 'Ubytovanie Jánošík Pub'
and
name not like '%Camp%' and
name not like '%Camping%' and
name not like '%camping%' and
name not like '%camp%' and
name not like '%kemping%' and
name not like '%Kemping%' and
name not like '%Kemp%' and
name not like '%kemp%'
and
name not like '%Apartment%' and 
name not like '%Apartments%' and
name not like '%apartment%' and
name not like '%apartments%' and
name not like '%Apartman%' and 
name not like '%Apartmany%' and
name not like '%Apartmány%' and
name not like '%Apartmán%' and
name not like '%apartmány%' and
name not like '%apartmán%' and
name not like '%apartman%' and
name not like '%Studio%' and
name not like '%studio%' and
name not like '%Štúdio%' and
name not like '%štúdio%' and
name not like '%Študio%' and
name not like '%študio%' and
name not like '%Thehan%' and
name not like '%Apartmen%'  and
name not like '%aparment%'  and
name not like '%APARTMENT%' and
name not like '%Appartment%' and
name not like '%Apt%' and
name not like '%Villa Park Komenského%' and
name not like '%Villa%' and
name not like '%Vila%' and
name not like 'House%' and
name not like '%Villa%' 
and
name not like '%Cottage%' and
name not like '%cottage%' and
name not like '%Chata%' and
name not like '%chata%' and
name <> 'Záhrada Zverina'
order by name
)
select * from gg_hotels 
union all
select * from gg_pension
union all
select * from gg_camps
union all
select * from gg_hostels
union all
select * from gg_private
union all
select * from gg_private_rest
------FOURSQUARE------FOURSQUARE------FOURSQUARE------FOURSQUARE------FOURSQUARE------FOURSQUARE
---HOTELS FOURSQUARE
--set work_mem = '512MB'
--select * from forsquaretest where district_id in ('802', '803', '804', '805')

create table fq_base_acc_categories as
with fq_hotels as (
with fq_hotels as 
(
select cast('Hotel' as text) as cat_acc, cast(null as text) as sub_cat_acc, 
	regexp_replace(unaccent(name), '[^a-zA-Z0-9]+|HOTEL|Hotel|hotel|official|website|Kosice|Slovakia' , ' ','g') sub_name, 
	name, level_0, district_id, geom 
from forsquaretest where name like '%Hotel%' and district_id in ('802', '803', '804', '805')
	or name like '%hotel%' and district_id in ('802', '803', '804', '805')
	or name like '%HOTEL%' and district_id in ('802', '803', '804', '805')
	or name like '%Hilton%' and district_id in ('802', '803', '804', '805')
	or name like '%Dália Dependance***%' and district_id in ('802', '803', '804', '805')
	or name in ('Zlaty Dukat', 'Gloria palace', 'Boutique Chrysso') and district_id in ('802', '803', '804', '805')

order by sub_name
)
select level_0, name, 
	CASE 
		WHEN sub_name like '%Boutique%' and sub_cat_acc is null then regexp_replace(sub_name, 'Boutique', ' ', 'g')
		WHEN sub_name like '%Garni%' and sub_cat_acc is null then regexp_replace(sub_name, 'Garni', ' ', 'g') 
		WHEN sub_name like '%Congress%' and sub_cat_acc is null then regexp_replace(sub_name, 'Congress', ' ', 'g')
		WHEN sub_name like '%Kongres%' and sub_cat_acc is null then regexp_replace(sub_name, 'Congress', ' ', 'g') 
	ELSE
		sub_name
	END,
	cat_acc, 
	CASE
		when sub_cat_acc is null and name like '%Boutique%' then 'Boutique' 
		when sub_cat_acc is null and name like '%Garni%' then 'Garni' 
		when sub_cat_acc is null and name like '%Congress%' then 'Congress'
		when sub_cat_acc is null and name like '%Kongres%' then 'Congress' 
		when sub_cat_acc is null and name like '%Dependance%' then 'Dependance' 
	ELSE
		sub_cat_acc
	END, district_id, geom
from fq_hotels
order by sub_name
),
fq_pension as (
---FORSQUARE PENSIONS
with fq_pensions as 
(
select cast('Pension' as text) as cat_acc, cast(null as text) as sub_cat_acc, 
	regexp_replace(unaccent(name), '[^a-zA-Z0-9]+|Pension|Penzion|Penzión|pension|Kosice|GUESTHOUSE|guesthouse|Slovakia' , ' ','g') sub_name,
	name, level_0, district_id, geom
	from forsquaretest where 
	name like '%Pension%' and district_id in ('802', '803', '804', '805')
	or name like '%Penzion%' and district_id in ('802', '803', '804', '805')
	or name like '%Penzión%' and district_id in ('802', '803', '804', '805')
	or name like '%pension%' and district_id in ('802', '803', '804', '805')
	or name like '%regia%' and district_id in ('802', '803', '804', '805')
	or name like '%Thehan%' and district_id in ('802', '803', '804', '805')
	or name like '%penzion%' and district_id in ('802', '803', '804', '805')
	or name like '%penzión%' and district_id in ('802', '803', '804', '805')
	or name like '%GUESTHOUSE%' and district_id in ('802', '803', '804', '805')
	or name like '%guesthouse%' and district_id in ('802', '803', '804', '805')
	or name in ('Hradbová', 'Zlatý Jeleň', 'Horse Inn') and district_id in ('802', '803', '804', '805')
order by sub_name
)
select level_0, name, sub_name, cat_acc, sub_cat_acc, district_id, geom
from fq_pensions
),
fq_hostels as (
---FORSQUARE HOSTELS
with fq_hostels as 
(
select cast('Hostel' as text) as cat_acc, cast(null as text) as sub_cat_acc, 
	regexp_replace(unaccent(name), '[^a-zA-Z0-9]+|Hostel|hostel|Ubytovna|ubytovna|Turisticka|Vodna 1 Kosice' , ' ','g') sub_name, 
	name, level_0, district_id, geom
from forsquaretest where 
	name like '%Hostel%' and district_id in ('802', '803', '804', '805')
	or name like '%HOSTEL%' and district_id in ('802', '803', '804', '805')
	or name like '%hostel%' and district_id in ('802', '803', '804', '805')
	or name like '%Ubytovňa%' and district_id in ('802', '803', '804', '805')
	or name like '%ubytovňa%' and district_id in ('802', '803', '804', '805')
	or name like '%Ubytovna%' and district_id in ('802', '803', '804', '805')
	or name like '%ubytovna%' and district_id in ('802', '803', '804', '805')
	or name like '%ŠD%' and district_id in ('802', '803', '804', '805')
	or name like '%WHITE CORAL CLUB%' and district_id in ('802', '803', '804', '805')
	or name like '%Dormitory%' and district_id in ('802', '803', '804', '805')
	or name like '%Internat%' and district_id in ('802', '803', '804', '805')
	or name like '%Internáty%' and district_id in ('802', '803', '804', '805')
	or name like '%Internát%' and district_id in ('802', '803', '804', '805')
	or name like '%Institute%' and district_id in ('802', '803', '804', '805')
	or name like '%Internaty%' and district_id in ('802', '803', '804', '805')
	or name like '%internát%' and district_id in ('802', '803', '804', '805')
	or name like '%internat%' and district_id in ('802', '803', '804', '805')
	or name like '%Jedlíkova 13%' and district_id in ('802', '803', '804', '805')
	or name = 'Budget & Students' and district_id in ('802', '803', '804', '805')
	or name in ('Ubytovanie Jánošík Pub', 'City Building Ltd.') and district_id in ('802', '803', '804', '805')
order by sub_name
)
select level_0, name, sub_name, cat_acc,  
	CASE
		when sub_cat_acc is null and name like '%ŠD%' then 'student home' 
		when sub_cat_acc is null and name like '%Dormitory%' then 'student home' 
		when sub_cat_acc is null and name like '%Internat%' then 'student home' 
		when sub_cat_acc is null and name like '%Internáty%' then 'student home' 
		when sub_cat_acc is null and name like '%Institute%' then 'student home' 
		when sub_cat_acc is null and name like '%Internaty%' then 'student home' 
		when sub_cat_acc is null and name like '%Internát%' then 'student home' 
		when sub_cat_acc is null and name like '%internát%' then 'student home' 
		when sub_cat_acc is null and name like '%internat%' then 'student home' 
		when sub_cat_acc is null and name like '%Jedlíkova 13%' then 'student home' 

	ELSE
		sub_cat_acc
	END, district_id, geom
from fq_hostels
order by sub_cat_acc
),
fq_private as (
--FORSQUARE PRIVATE
WITH fq_private as (
select cast('Private' as text) as cat_acc, cast(null as text) as sub_cat_acc, 
	regexp_replace(unaccent(name), '[^a-zA-Z0-9]+' , ' ','g') sub_name, 
	name, level_0, district_id, geom 
from forsquaretest where
	name like '%Apartman%' and district_id in ('802', '803', '804', '805')
	or name like '%Apartmany%' and district_id in ('802', '803', '804', '805')
	or name like '%Apartmány%' and district_id in ('802', '803', '804', '805')
	or name like '%Apartmán%' and district_id in ('802', '803', '804', '805')
	or name like '%apartmány%' and district_id in ('802', '803', '804', '805')
	or name like '%apartmán%' and district_id in ('802', '803', '804', '805')
	or name like '%apartman%' and district_id in ('802', '803', '804', '805')
	or name like '%Apartment%' and name not like '%Hotel%' and district_id in ('802', '803', '804', '805') 
	or name like '%Apartments%' and district_id in ('802', '803', '804', '805')
	or name like '%apartments%' and district_id in ('802', '803', '804', '805')
	or name like '%apartment%' and name not like '%Hotel%' and district_id in ('802', '803', '804', '805')
	or name like '%Appartment%' and district_id in ('802', '803', '804', '805')
	or name like '%APARTMENT%' and name not like '%Hotel%' and district_id in ('802', '803', '804', '805')
	or name like '%Apartmen%' and name not like '%Hotel%' and district_id in ('802', '803', '804', '805')
	or name like '%Villa Park Komenského%' and district_id in ('802', '803', '804', '805')
	or name like '%Villa%' and district_id in ('802', '803', '804', '805') and name not like ('Villa Park Komenského') and name not like ('%Penzion Villa%')
	or name like '%Vila%' and district_id in ('802', '803', '804', '805') and name not like ('Villa Park Komenského') and name not like ('%Penzion Villa%')
	or name like '%Studio%' and district_id in ('802', '803', '804', '805')
	or name like '%studio%' and district_id in ('802', '803', '804', '805')
	or name like '%Štúdio%' and district_id in ('802', '803', '804', '805')
	or name like '%štúdio%' and district_id in ('802', '803', '804', '805')
	or name like '%študio%' and district_id in ('802', '803', '804', '805')
	or name like '%Študio%' and district_id in ('802', '803', '804', '805')
	or name like 'House%' and district_id in ('802', '803', '804', '805')
	or name like '% dom%' and district_id in ('802', '803', '804', '805')
	or name like '%Apt%' and district_id in ('802', '803', '804', '805')
	or name like '%cottage%' and district_id in ('802', '803', '804', '805')
	or name like '%Cottage%' and district_id in ('802', '803', '804', '805')
	or name like '%Chata%' and district_id in ('802', '803', '804', '805')
	or name = 'Záhrada Zverina' and district_id in ('802', '803', '804', '805')
	
order by sub_name
)
select level_0, name, 
	CASE 
		WHEN sub_name like '%Apartmany%' and sub_cat_acc is null then regexp_replace(sub_name, 'Apartmany', ' ', 'g')
		WHEN sub_name like '%Apartmány%' and sub_cat_acc is null then regexp_replace(sub_name, 'Apartmány', ' ', 'g') 
		WHEN sub_name like '%Apartmán%' and sub_cat_acc is null then regexp_replace(sub_name, 'Apartmán', ' ', 'g')
		WHEN sub_name like '%Apartman%' and sub_cat_acc is null then regexp_replace(sub_name, 'Apartman', ' ', 'g')
		WHEN sub_name like '%Apartments%' and sub_cat_acc is null then regexp_replace(sub_name, 'Apartments', ' ', 'g')
		WHEN sub_name like '%apartments%' and sub_cat_acc is null then regexp_replace(sub_name, 'apartments', ' ', 'g')
		WHEN sub_name like '%Apartment%' and sub_cat_acc is null then regexp_replace(sub_name, 'Apartment', ' ', 'g') 
		WHEN sub_name like '%apartment%' and sub_cat_acc is null then regexp_replace(sub_name, 'apartment', ' ', 'g') 
		WHEN sub_name like '%apartman%' and sub_cat_acc is null then regexp_replace(sub_name, 'apartman', ' ', 'g') 
		WHEN sub_name like '%APARTMENT%' and sub_cat_acc is null then regexp_replace(sub_name, 'APARTMENT', ' ', 'g') 
		WHEN sub_name like '%Appartment%' and sub_cat_acc is null then regexp_replace(sub_name, 'Appartment', ' ', 'g') 
		WHEN sub_name like '%Apartmen%' and sub_cat_acc is null then regexp_replace(sub_name, 'Apartmen', ' ', 'g') 
		WHEN sub_name like '%Studio%' and sub_cat_acc is null then regexp_replace(sub_name, 'Studio', ' ', 'g') 
		WHEN sub_name like '%studio%' and sub_cat_acc is null then regexp_replace(sub_name, 'studio', ' ', 'g') 
		WHEN sub_name like '%Štúdio%' and sub_cat_acc is null then regexp_replace(sub_name, 'Štúdio', ' ', 'g') 
		WHEN sub_name like '%štúdio%' and sub_cat_acc is null then regexp_replace(sub_name, 'štúdio', ' ', 'g') 
		WHEN sub_name like '%študio%' and sub_cat_acc is null then regexp_replace(sub_name, 'študio', ' ', 'g') 
		WHEN sub_name like '%Študio%' and sub_cat_acc is null then regexp_replace(sub_name, 'Študio', ' ', 'g') 
		WHEN sub_name like '%Apt%' and sub_cat_acc is null then regexp_replace(sub_name, 'Apt', ' ', 'g') 
		
		
	ELSE
		sub_name
	END,
	cat_acc, 
	CASE
		when sub_cat_acc is null and name like '%Apartmány%' then 'Apartment House' 
		when sub_cat_acc is null and name like '%Apartmany%' then 'Apartment House' 
		when sub_cat_acc is null and name like '%Apartmán%' then 'Apartment'
		when sub_cat_acc is null and name like '%Apartman%' then 'Apartment'
		when sub_cat_acc is null and name like '%Apartments%' then 'Apartment House'
		when sub_cat_acc is null and name like '%apartments%' then 'Apartment House'
		when sub_cat_acc is null and name like '%apartment%' then 'Apartment'
		when sub_cat_acc is null and name like '%Apartmen%' then 'Apartment'
		when sub_cat_acc is null and name like '%apartman%' then 'Apartment'
		when sub_cat_acc is null and name like '%Apartment%' then 'Apartment'
		when sub_cat_acc is null and name like '%APARTMENT%' then 'Apartment'
		when sub_cat_acc is null and name like '%Appartment%' then 'Apartment'
		when sub_cat_acc is null and name like '%Studio%' then 'Studio'
		when sub_cat_acc is null and name like '%studio%' then 'Studio'
		when sub_cat_acc is null and name like '%Štúdio%' then 'Studio'
		when sub_cat_acc is null and name like '%štúdio%' then 'Studio'
		when sub_cat_acc is null and name like '%Študio%' then 'Studio'
		when sub_cat_acc is null and name like '%študio%' then 'Studio'
		when sub_cat_acc is null and name like '%Vila%' then 'Villa'
		when sub_cat_acc is null and name like '%Villa%' and name not like '%Park Komenského%' then 'Villa'
		when sub_cat_acc is null and name like 'House%' then 'House'
		when sub_cat_acc is null and name like '% dom%' then 'House'
		when sub_cat_acc is null and name like '% Apt%' then 'Apartment'
		when sub_cat_acc is null and name like '%cottage%' then 'Cottage'
		when sub_cat_acc is null and name like '%Cottage%' then 'Cottage'
		when sub_cat_acc is null and name like '%Chata%' then 'Cottage'
		when sub_cat_acc is null and name like '%chata%' then 'Cottage'
		when sub_cat_acc is null and name = 'Záhrada Zverina' then 'Cottage'

		when sub_cat_acc is null and name like '%Villa Park Komenského%' then 'Apartment House'
	ELSE
		sub_cat_acc
	END, district_id, geom
from fq_private
order by sub_cat_acc
),
fq_private_rest as (
----FORSQUARE PRIVATE REST
select level_0, name, name as subname, cast('Private' as text) as cat_acc, cast('Apartment' as text) as sub_cat_acc, district_id, geom from forsquaretest  where  
district_id in ('802', '803', '804', '805') and
name not like '%Hotel%' and 
name not like '%hotel%' and
name not like '%HOTEL%' and
name not like '%Hilton%' and
name not like '%Dependance%' and
name not in ('Zlaty Dukat', 'Gloria palace', 'Boutique Chrysso') 
and
name not like '%Penzión%' and 
name not like '%Penzion%' and
name not like '%penzión%' and
name not like '%Pension%' and
name not like '%pension%' and
name not like '%GUESTHOUSE%' and
name not like '%guesthouse%' and
name not like '%Villa regia%' and 
name not like '%Zlatý Jeleň%' and
name not like '%Horse Inn%' and
name <> 'Hradbová'
and
name not like '%Hostel%' and
name not like '%hostel%' and
name not like '%ubytovňa%' and
name not like '%Ubytovňa%' and
name not like '%Ubytovna%' and
name not like '%ubytovna%' and
name not like '%HOSTEL%' and
name not like '%ŠD%' and
name not like '%WHITE CORAL CLUB%' and
name not like '%Internaty%' and
name not like '%Dormitory%' and
name not like '%Internat%' and
name not like '%Internát%' and
name not like '%Internáty%' and
name not like '%internát%' and
name not like '%internat%' and
name not like '%Institute%' and
name not like 'Jedlíkova 13' and
name <> 'Budget & Students' and
name <> 'City Building Ltd.' and
name <> 'Ubytovanie Jánošík Pub'
and
name not like '%Vila Terasse%' and 
name not like '%Topoľová%'
	)
select * from fq_hotels 
union all
select * from fq_pension
union all
select * from fq_hostels
union all
select * from fq_private
union all
select * from fq_private_rest

-----TRIPADVISOR-----TRIPADVISOR-----TRIPADVISOR-----TRIPADVISOR
---HOTELS TRIPADVISOR

create table ta_base_acc_categories as 
with ta_hotels as (
with ta_hotels as 
(
select cast('Hotel' as text) as cat_acc, cast(null as text) as sub_cat_acc, 
	regexp_replace(unaccent(name), '[^a-zA-Z0-9]+|HOTEL|Hotel|hotel|official|website|Kosice|Slovakia' , ' ','g') sub_name, 
	name, level_0, district_id, geom
from tripadvisortest where name like '%Hotel%' and district_id in ('802', '803', '804', '805')
	or name like '%hotel%' and district_id in ('802', '803', '804', '805')
	or name like '%HOTEL%' and district_id in ('802', '803', '804', '805')
	or name like '%Hilton%' and district_id in ('802', '803', '804', '805')
	or name like '%Dália Dependance***%' and district_id in ('802', '803', '804', '805')
	or name in ('Zlaty Dukat', 'Gloria palace', 'Boutique Chrysso') and district_id in ('802', '803', '804', '805')

order by sub_name
)
select level_0, name, 
	CASE 
		WHEN sub_name like '%Boutique%' and sub_cat_acc is null then regexp_replace(sub_name, 'Boutique', ' ', 'g')
		WHEN sub_name like '%Garni%' and sub_cat_acc is null then regexp_replace(sub_name, 'Garni', ' ', 'g') 
		WHEN sub_name like '%Congress%' and sub_cat_acc is null then regexp_replace(sub_name, 'Congress', ' ', 'g')
		WHEN sub_name like '%Kongres%' and sub_cat_acc is null then regexp_replace(sub_name, 'Congress', ' ', 'g') 
	ELSE
		sub_name
	END,
	cat_acc, 
	CASE
		when sub_cat_acc is null and name like '%Boutique%' then 'Boutique' 
		when sub_cat_acc is null and name like '%Garni%' then 'Garni' 
		when sub_cat_acc is null and name like '%Congress%' then 'Congress'
		when sub_cat_acc is null and name like '%Kongres%' then 'Congress' 
		when sub_cat_acc is null and name like '%Dependance%' then 'Dependance' 
	ELSE
		sub_cat_acc
	END, district_id, geom
from ta_hotels
order by sub_name
),
ta_pension as (
----PENSION GUESTHOUSES TRIPADVISOR
with ta_pensions as 
(
select cast('Pension' as text) as cat_acc, cast(null as text) as sub_cat_acc, 
	regexp_replace(unaccent(name), '[^a-zA-Z0-9]+|Pezion|Pension|Penzion|Penzión|pension|Kosice|GUESTHOUSE|guesthouse|Slovakia' , ' ','g') sub_name,
	name, level_0, district_id, geom
	from tripadvisortest where 
	name like '%Pension%' and district_id in ('802', '803', '804', '805')
	or name like '%Penzion%' and district_id in ('802', '803', '804', '805')
	or name like '%Pezion%' and district_id in ('802', '803', '804', '805')
	or name like '%Penzión%' and district_id in ('802', '803', '804', '805')
	or name like '%pension%' and district_id in ('802', '803', '804', '805')
	or name like '%regia%' and district_id in ('802', '803', '804', '805')
	or name like '%Thehan%' and district_id in ('802', '803', '804', '805')
	or name like '%penzion%' and district_id in ('802', '803', '804', '805')
	or name like '%penzión%' and district_id in ('802', '803', '804', '805')
	or name like '%GUESTHOUSE%' and district_id in ('802', '803', '804', '805')
	or name like '%guesthouse%' and district_id in ('802', '803', '804', '805')
	or name like '%Guesthouse%' and district_id in ('802', '803', '804', '805')
	or name in('Koliba Zlata Podkova', 'Jahodna Sport & Recreation Centre') and district_id in ('802', '803', '804', '805')
	or name in ('Hradbová', 'Zlatý Jeleň', 'Horse Inn') and district_id in ('802', '803', '804', '805')
order by sub_name
)
select level_0, name, sub_name, cat_acc, sub_cat_acc, district_id, geom
from ta_pensions
),
ta_camps as (
-----CAMPS TRIPADVISOR
with ta_camps as 
(
select cast('Camp' as text) as cat_acc, cast(null as text) as sub_cat_acc, 
	regexp_replace(unaccent(name), '[^a-zA-Z0-9]+|camp|camping|kemp|kemping|Camp|Camping|Kemp|Kemping|Kosice|Slovakia' , ' ','g') sub_name,
	name, level_0, district_id, geom
	from tripadvisortest where 
	name like '%camp%' and district_id in ('802', '803', '804', '805')
	or name like '%camping%' and district_id in ('802', '803', '804', '805')
	or name like '%kemp%' and district_id in ('802', '803', '804', '805')
	or name like '%kemp%' and district_id in ('802', '803', '804', '805')
	or name like '%kemping%' and district_id in ('802', '803', '804', '805')
	or name like '%Camp%' and district_id in ('802', '803', '804', '805')
	or name like '%Camping%' and district_id in ('802', '803', '804', '805')
	or name like '%Kemping%' and district_id in ('802', '803', '804', '805')
order by sub_name
)
select level_0, name, sub_name, cat_acc, sub_cat_acc, district_id, geom
from ta_camps
),
ta_hostels as (
---HOSTELS DORIMTORIES TRIPADVISOR
with ta_hostels as 
(
select cast('Hostel' as text) as cat_acc, cast(null as text) as sub_cat_acc, 
	regexp_replace(unaccent(name), '[^a-zA-Z0-9]+|Hostel|hostel|Ubytovna|ubytovna|Turisticka|Vodna 1 Kosice' , ' ','g') sub_name, 
	name, level_0, district_id, geom
from tripadvisortest where 
	name like '%Hostel%' and district_id in ('802', '803', '804', '805')
	or name like '%HOSTEL%' and district_id in ('802', '803', '804', '805')
	or name like '%hostel%' and district_id in ('802', '803', '804', '805')
	or name like '%Ubytovňa%' and district_id in ('802', '803', '804', '805')
	or name like '%ubytovňa%' and district_id in ('802', '803', '804', '805')
	or name like '%Ubytovna%' and district_id in ('802', '803', '804', '805')
	or name like '%ubytovna%' and district_id in ('802', '803', '804', '805')
	or name like '%SD%' and district_id in ('802', '803', '804', '805')
	or name like '%ŠD%' and district_id in ('802', '803', '804', '805')
	or name like '%WHITE CORAL CLUB%' and district_id in ('802', '803', '804', '805')
	or name like '%White Coral Club%' and district_id in ('802', '803', '804', '805')
	or name like '%Dormitory%' and district_id in ('802', '803', '804', '805')
	or name like '%Internat%' and district_id in ('802', '803', '804', '805')
	or name like '%Internáty%' and district_id in ('802', '803', '804', '805')
	or name like '%Internát%' and district_id in ('802', '803', '804', '805')
	or name like '%Institute%' and district_id in ('802', '803', '804', '805')
	or name like '%Internaty%' and district_id in ('802', '803', '804', '805')
	or name like '%internát%' and district_id in ('802', '803', '804', '805')
	or name like '%internat%' and district_id in ('802', '803', '804', '805')
	or name like '%Jedlíkova 13%' and district_id in ('802', '803', '804', '805')
	or name = 'Budget & Students' and district_id in ('802', '803', '804', '805')
	or name in ('IVVL Tourist', 'Ubytovanie Janosik Pub','Ubytovanie Jánošík Pub', 'City Building Ltd.') and district_id in ('802', '803', '804', '805')
order by sub_name
)
select level_0, name, sub_name, cat_acc, 
	CASE
		when sub_cat_acc is null and name like '%SD%' then 'student home' 
		when sub_cat_acc is null and name like '%ŠD%' then 'student home' 
		when sub_cat_acc is null and name like '%Dormitory%' then 'student home' 
		when sub_cat_acc is null and name like '%Internat%' then 'student home' 
		when sub_cat_acc is null and name like '%Internáty%' then 'student home' 
		when sub_cat_acc is null and name like '%Institute%' then 'student home' 
		when sub_cat_acc is null and name like '%Internaty%' then 'student home' 
		when sub_cat_acc is null and name like '%Internát%' then 'student home' 
		when sub_cat_acc is null and name like '%internát%' then 'student home' 
		when sub_cat_acc is null and name like '%internat%' then 'student home' 
		when sub_cat_acc is null and name like '%Jedlíkova 13%' then 'student home' 
		when sub_cat_acc is null and name like '%IVVL Tourist%' then 'student home' 

	ELSE
		sub_cat_acc
	END, district_id, geom
from ta_hostels
order by sub_cat_acc
),
ta_private as (
------TRIPADVISOR PRIVATE
WITH ta_private as (
select cast('Private' as text) as cat_acc, cast(null as text) as sub_cat_acc, 
	regexp_replace(unaccent(name), '[^a-zA-Z0-9]+' , ' ','g') sub_name, 
	name, level_0, district_id, geom
from tripadvisortest where
	name like '%Apartman%' and district_id in ('802', '803', '804', '805')
	or name like '%Apartmany%' and district_id in ('802', '803', '804', '805')
	or name like '%Apartmány%' and district_id in ('802', '803', '804', '805')
	or name like '%Apartmán%' and district_id in ('802', '803', '804', '805')
	or name like '%apartmány%' and district_id in ('802', '803', '804', '805')
	or name like '%apartmán%' and district_id in ('802', '803', '804', '805')
	or name like '%apartman%' and district_id in ('802', '803', '804', '805')
	or name like '%Apartment%' and name not like '%Hotel%' and district_id in ('802', '803', '804', '805') 
	or name like '%Apartments%' and district_id in ('802', '803', '804', '805')
	or name like '%apartments%' and district_id in ('802', '803', '804', '805')
	or name like '%apartment%' and name not like '%Hotel%' and district_id in ('802', '803', '804', '805')
	or name like '%Appartment%' and district_id in ('802', '803', '804', '805')
	or name like '%APARTMENT%' and name not like '%Hotel%' and district_id in ('802', '803', '804', '805')
	or name like '%Apartmen%' and name not like '%Hotel%' and district_id in ('802', '803', '804', '805')
	or name like '%Villa Park Komenského%' and district_id in ('802', '803', '804', '805')
	or name like '%Villa%' and district_id in ('802', '803', '804', '805') and name not like ('Villa Park Komenského') and name not like ('%Penzion Villa%')
	or name like '%Vila%' and district_id in ('802', '803', '804', '805') and name not like ('Villa Park Komenského') and name not like ('%Penzion Villa%')
	or name like '%Studio%' and district_id in ('802', '803', '804', '805')
	or name like '%studio%' and district_id in ('802', '803', '804', '805')
	or name like '%Štúdio%' and district_id in ('802', '803', '804', '805')
	or name like '%štúdio%' and district_id in ('802', '803', '804', '805')
	or name like '%študio%' and district_id in ('802', '803', '804', '805')
	or name like '%Študio%' and district_id in ('802', '803', '804', '805')
	or name like 'House%' and district_id in ('802', '803', '804', '805')
	or name like '% dom%' and district_id in ('802', '803', '804', '805')
	or name like '%Apt%' and district_id in ('802', '803', '804', '805')
	or name like '%cottage%' and district_id in ('802', '803', '804', '805')
	or name like '%Cottage%' and district_id in ('802', '803', '804', '805')
	or name like '%Chata%' and district_id in ('802', '803', '804', '805')
	or name = 'Záhrada Zverina' and district_id in ('802', '803', '804', '805')
	
order by sub_name
)
select level_0, name, 
	CASE 
		WHEN sub_name like '%Apartmany%' and sub_cat_acc is null then regexp_replace(sub_name, 'Apartmany', ' ', 'g')
		WHEN sub_name like '%Apartmány%' and sub_cat_acc is null then regexp_replace(sub_name, 'Apartmány', ' ', 'g') 
		WHEN sub_name like '%Apartmán%' and sub_cat_acc is null then regexp_replace(sub_name, 'Apartmán', ' ', 'g')
		WHEN sub_name like '%Apartman%' and sub_cat_acc is null then regexp_replace(sub_name, 'Apartman', ' ', 'g')
		WHEN sub_name like '%Apartments%' and sub_cat_acc is null then regexp_replace(sub_name, 'Apartments', ' ', 'g')
		WHEN sub_name like '%apartments%' and sub_cat_acc is null then regexp_replace(sub_name, 'apartments', ' ', 'g')
		WHEN sub_name like '%Apartment%' and sub_cat_acc is null then regexp_replace(sub_name, 'Apartment', ' ', 'g') 
		WHEN sub_name like '%apartment%' and sub_cat_acc is null then regexp_replace(sub_name, 'apartment', ' ', 'g') 
		WHEN sub_name like '%apartman%' and sub_cat_acc is null then regexp_replace(sub_name, 'apartman', ' ', 'g') 
		WHEN sub_name like '%APARTMENT%' and sub_cat_acc is null then regexp_replace(sub_name, 'APARTMENT', ' ', 'g') 
		WHEN sub_name like '%Appartment%' and sub_cat_acc is null then regexp_replace(sub_name, 'Appartment', ' ', 'g') 
		WHEN sub_name like '%Apartmen%' and sub_cat_acc is null then regexp_replace(sub_name, 'Apartmen', ' ', 'g') 
		WHEN sub_name like '%Studio%' and sub_cat_acc is null then regexp_replace(sub_name, 'Studio', ' ', 'g') 
		WHEN sub_name like '%studio%' and sub_cat_acc is null then regexp_replace(sub_name, 'studio', ' ', 'g') 
		WHEN sub_name like '%Štúdio%' and sub_cat_acc is null then regexp_replace(sub_name, 'Štúdio', ' ', 'g') 
		WHEN sub_name like '%štúdio%' and sub_cat_acc is null then regexp_replace(sub_name, 'štúdio', ' ', 'g') 
		WHEN sub_name like '%študio%' and sub_cat_acc is null then regexp_replace(sub_name, 'študio', ' ', 'g') 
		WHEN sub_name like '%Študio%' and sub_cat_acc is null then regexp_replace(sub_name, 'Študio', ' ', 'g') 
		WHEN sub_name like '%Apt%' and sub_cat_acc is null then regexp_replace(sub_name, 'Apt', ' ', 'g') 
		
		
	ELSE
		sub_name
	END,
	cat_acc, 
	CASE
		when sub_cat_acc is null and name like '%Apartmány%' then 'Apartment House' 
		when sub_cat_acc is null and name like '%Apartmany%' then 'Apartment House' 
		when sub_cat_acc is null and name like '%Apartmán%' then 'Apartment'
		when sub_cat_acc is null and name like '%Apartman%' then 'Apartment'
		when sub_cat_acc is null and name like '%Apartments%' then 'Apartment House'
		when sub_cat_acc is null and name like '%apartments%' then 'Apartment House'
		when sub_cat_acc is null and name like '%apartment%' then 'Apartment'
		when sub_cat_acc is null and name like '%Apartmen%' then 'Apartment'
		when sub_cat_acc is null and name like '%apartman%' then 'Apartment'
		when sub_cat_acc is null and name like '%Apartment%' then 'Apartment'
		when sub_cat_acc is null and name like '%APARTMENT%' then 'Apartment'
		when sub_cat_acc is null and name like '%Appartment%' then 'Apartment'
		when sub_cat_acc is null and name like '%Studio%' then 'Studio'
		when sub_cat_acc is null and name like '%studio%' then 'Studio'
		when sub_cat_acc is null and name like '%Štúdio%' then 'Studio'
		when sub_cat_acc is null and name like '%štúdio%' then 'Studio'
		when sub_cat_acc is null and name like '%Študio%' then 'Studio'
		when sub_cat_acc is null and name like '%študio%' then 'Studio'
		when sub_cat_acc is null and name like '%Vila%' then 'Villa'
		when sub_cat_acc is null and name like '%Villa%' and name not like '%Park Komenského%' then 'Villa'
		when sub_cat_acc is null and name like 'House%' then 'House'
		when sub_cat_acc is null and name like '% dom%' then 'House'
		when sub_cat_acc is null and name like '% Apt%' then 'Apartment'
		when sub_cat_acc is null and name like '%cottage%' then 'Cottage'
		when sub_cat_acc is null and name like '%Cottage%' then 'Cottage'
		when sub_cat_acc is null and name like '%Chata%' then 'Cottage'
		when sub_cat_acc is null and name like '%chata%' then 'Cottage'
		when sub_cat_acc is null and name = 'Záhrada Zverina' then 'Cottage'

		when sub_cat_acc is null and name like '%Villa Park Komenského%' then 'Apartment House'
	ELSE
		sub_cat_acc
	END, district_id, geom
from ta_private
order by sub_cat_acc
),
ta_private_rest as (
----REST PRIVATE TRIPADVISOR
select level_0, name, name as subname, cast('Private' as text) as cat_acc, cast('Apartment' as text) as sub_cat_acc, district_id, geom from tripadvisortest  where  
district_id in ('802', '803', '804', '805') and
name not like '%Hotel%' and 
name not like '%hotel%' and
name not like '%HOTEL%' and
name not like '%Hilton%' and
name not like '%Dependance%' and
name not in ('Zlaty Dukat', 'Gloria palace', 'Boutique Chrysso') 
and
name not like '%Penzión%' and 
name not like '%Penzion%' and
name not like '%penzión%' and
name not like '%Pension%' and
name not like '%pension%' and
name not like '%GUESTHOUSE%' and
name not like '%guesthouse%' and
name not like '%Villa regia%' and 
name not like '%Zlatý Jeleň%' and
name not like '%Horse Inn%' and
name not like '%Pezion%' and
name not like '%Guesthouse%' and
name <> 'Hradbová' and
name <> 'Jahodna Sport & Recreation Centre' and
name <> 'Koliba Zlata Podkova'
and
name not like '%Camp%' and
name not like '%Camping%' and
name not like '%camping%' and
name not like '%camp%' and
name not like '%kemping%' and
name not like '%Kemping%' and
name not like '%Kemp%' and
name not like '%kemp%'
and
name not like '%Hostel%' and
name not like '%hostel%' and
name not like '%ubytovňa%' and
name not like '%Ubytovňa%' and
name not like '%Ubytovna%' and
name not like '%ubytovna%' and
name not like '%HOSTEL%' and
name not like '%ŠD%' and
name not like '%SD%' and
name not like '%White Coral Club%' and
name not like '%WHITE CORAL CLUB%' and
name not like '%Internaty%' and
name not like '%Dormitory%' and
name not like '%Internat%' and
name not like '%Internát%' and
name not like '%Internáty%' and
name not like '%internát%' and
name not like '%internat%' and
name not like '%Institute%' and
name not like 'Jedlíkova 13' and
name <> 'Budget & Students' and
name <> 'City Building Ltd.' and
name <> 'Ubytovanie Jánošík Pub' and
name <> 'Ubytovanie Janosik Pub' and
name <> 'IVVL Tourist'
and
name not like '%Apartment%' and 
name not like '%Apartments%' and
name not like '%apartment%' and
name not like '%apartments%' and
name not like '%Apartman%' and 
name not like '%Apartmany%' and
name not like '%Apartmány%' and
name not like '%Apartmán%' and
name not like '%apartmány%' and
name not like '%apartmán%' and
name not like '%apartman%' and
name not like '%Studio%' and
name not like '%studio%' and
name not like '%Štúdio%' and
name not like '%štúdio%' and
name not like '%Študio%' and
name not like '%študio%' and
name not like '%Thehan%' and
name not like '%Apartmen%'  and
name not like '%aparment%'  and
name not like '%APARTMENT%' and
name not like '%Appartment%' and
name not like '%Apt%' and
name not like '%Villa Park Komenského%' and
name not like '%Villa%' and
name not like '%Vila%' and
name not like 'House%' and
name not like '%Villa%' 
and
name not like '%Cottage%' and
name not like '%cottage%' and
name not like '%Chata%' and
name not like '%chata%' and
name <> 'Záhrada Zverina'
order by name
)
select * from ta_hotels 
union all
select * from ta_pension
union all
select * from ta_camps
union all
select * from ta_hostels
union all
select * from ta_private
union all
select * from ta_private_rest



----AIRBNB ----AIRBNB----AIRBNB----AIRBNB----AIRBNB----AIRBNB----AIRBNB
create table abb_district_aggregates as

with abbb as (
with abb_base_ke as (
with base_ke_ke as (
with base_ke as (
select * from airbnbtest where newcity in ('Barca', 'Dargovských hrdinov', 'Juh', 'Kosice', 'Košice', 'Nad jazerom', 'Pereš', 'Sever', 'Sídlisko KVP', 'Staré Mesto',
'Vyšné Opátske', 'Západ') and geom is not null
)
select cast('Private' as text) as cat_acc, cast(null as text) as sub_cat_acc, 
	regexp_replace(unaccent(name), '[^a-zA-Z0-9]+' , ' ','g') sub_name, 
	name, level_0, district_id, geom, municipality_name
	from base_ke
	)
select level_0, name, 
	CASE 
		WHEN sub_name like '%Apartmany%' and sub_cat_acc is null then regexp_replace(sub_name, 'Apartmany', ' ', 'g')
		WHEN sub_name like '%Apartmány%' and sub_cat_acc is null then regexp_replace(sub_name, 'Apartmány', ' ', 'g') 
		WHEN sub_name like '%Apartmán%' and sub_cat_acc is null then regexp_replace(sub_name, 'Apartmán', ' ', 'g')
		WHEN sub_name like '%Apartman%' and sub_cat_acc is null then regexp_replace(sub_name, 'Apartman', ' ', 'g')
		WHEN sub_name like '%Apartments%' and sub_cat_acc is null then regexp_replace(sub_name, 'Apartments', ' ', 'g')
		WHEN sub_name like '%apartments%' and sub_cat_acc is null then regexp_replace(sub_name, 'apartments', ' ', 'g')
		WHEN sub_name like '%Apartment%' and sub_cat_acc is null then regexp_replace(sub_name, 'Apartment', ' ', 'g') 
		WHEN sub_name like '%apartment%' and sub_cat_acc is null then regexp_replace(sub_name, 'apartment', ' ', 'g') 
		WHEN sub_name like '%apartman%' and sub_cat_acc is null then regexp_replace(sub_name, 'apartman', ' ', 'g') 
		WHEN sub_name like '%APARTMENT%' and sub_cat_acc is null then regexp_replace(sub_name, 'APARTMENT', ' ', 'g') 
		WHEN sub_name like '%Appartment%' and sub_cat_acc is null then regexp_replace(sub_name, 'Appartment', ' ', 'g') 
		WHEN sub_name like '%Apartmen%' and sub_cat_acc is null then regexp_replace(sub_name, 'Apartmen', ' ', 'g') 
		WHEN sub_name like '%Studio%' and sub_cat_acc is null then regexp_replace(sub_name, 'Studio', ' ', 'g') 
		WHEN sub_name like '%studio%' and sub_cat_acc is null then regexp_replace(sub_name, 'studio', ' ', 'g') 
		WHEN sub_name like '%Štúdio%' and sub_cat_acc is null then regexp_replace(sub_name, 'Štúdio', ' ', 'g') 
		WHEN sub_name like '%štúdio%' and sub_cat_acc is null then regexp_replace(sub_name, 'štúdio', ' ', 'g') 
		WHEN sub_name like '%študio%' and sub_cat_acc is null then regexp_replace(sub_name, 'študio', ' ', 'g') 
		WHEN sub_name like '%Študio%' and sub_cat_acc is null then regexp_replace(sub_name, 'Študio', ' ', 'g') 
		WHEN sub_name like '%Apt%' and sub_cat_acc is null then regexp_replace(sub_name, 'Apt', ' ', 'g') 
		
		
	ELSE
		sub_name
	END,
	cat_acc, 
	CASE
		when sub_cat_acc is null and name like '%Apartmány%' then 'Apartment House' 
		when sub_cat_acc is null and name like '%Apartmany%' then 'Apartment House' 
		when sub_cat_acc is null and name like '%Apartmán%' then 'Apartment'
		when sub_cat_acc is null and name like '%Apartman%' then 'Apartment'
		when sub_cat_acc is null and name like '%Apartments%' then 'Apartment House'
		when sub_cat_acc is null and name like '%apartments%' then 'Apartment House'
		when sub_cat_acc is null and name like '%apartment%' then 'Apartment'
		when sub_cat_acc is null and name like '%Apartmen%' then 'Apartment'
		when sub_cat_acc is null and name like '%apartman%' then 'Apartment'
		when sub_cat_acc is null and name like '%Apartment%' then 'Apartment'
		when sub_cat_acc is null and name like '%APARTMENT%' then 'Apartment'
		when sub_cat_acc is null and name like '%Appartment%' then 'Apartment'
		when sub_cat_acc is null and name like '%Studio%' then 'Studio'
		when sub_cat_acc is null and name like '%studio%' then 'Studio'
		when sub_cat_acc is null and name like '%Štúdio%' then 'Studio'
		when sub_cat_acc is null and name like '%štúdio%' then 'Studio'
		when sub_cat_acc is null and name like '%Študio%' then 'Studio'
		when sub_cat_acc is null and name like '%študio%' then 'Studio'
		when sub_cat_acc is null and name like '%Vila%' then 'Villa'
		when sub_cat_acc is null and name like '%Villa%' and name not like '%Park Komenského%' then 'Villa'
		when sub_cat_acc is null and name like 'House%' then 'House'
		when sub_cat_acc is null and name like '% dom%' then 'House'
		when sub_cat_acc is null and name like '% Apt%' then 'Apartment'
		when sub_cat_acc is null and name like '%cottage%' then 'Cottage'
		when sub_cat_acc is null and name like '%Cottage%' then 'Cottage'
		when sub_cat_acc is null and name like '%Chata%' then 'Cottage'
		when sub_cat_acc is null and name like '%chata%' then 'Cottage'
		when sub_cat_acc is null and name = 'Záhrada Zverina' then 'Cottage'

		when sub_cat_acc is null and name like '%Villa Park Komenského%' then 'Apartment House'
	ELSE
		sub_cat_acc
	END, district_id, geom, municipality_name
from base_ke_ke
order by sub_cat_acc
)	
select district_id, count(*)
from abb_base_ke
group by district_id
order by count desc
),

districts as (
	select idn3, nm3, geom from okres_0 where idn3 in ('802', '803', '804', '805')
	)
select * from abbb join districts on districts.idn3 = abbb.district_id
	
select * from abb_mun_aggregates
