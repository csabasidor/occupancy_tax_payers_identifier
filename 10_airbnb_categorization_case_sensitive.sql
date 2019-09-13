with abb_base_ke_ke as (
with abb_base_ke as (
with base_ke_ke as (
with base_ke as (
select * from airbnbtest where newcity in ('Barca', 'Dargovských hrdinov', 'Juh', 'Kosice', 'Košice', 'Nad jazerom', 'Pereš', 'Sever', 'Sídlisko KVP', 'Staré Mesto',
'Vyšné Opátske', 'Západ') 
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
		when sub_cat_acc is null and name like '%House%' then 'House'
		when sub_cat_acc is null and name like '%HOUSE%' then 'House'
		when sub_cat_acc is null and name like '% house %' then 'House'

		when sub_cat_acc is null and name like '% dom%' then 'House'
		when sub_cat_acc is null and name like '% Apt%' then 'Apartment'
		when sub_cat_acc is null and name like '%cottage%' then 'Cottage'
		when sub_cat_acc is null and name like '%Cottage%' then 'Cottage'
		when sub_cat_acc is null and name like '%Chata%' then 'Cottage'
		when sub_cat_acc is null and name like '%chata%' then 'Cottage'
		when sub_cat_acc is null and name = 'Záhrada Zverina' then 'Cottage'
		when sub_cat_acc is null and name like '%apt.%' then 'Apartment'
		when sub_cat_acc is null and name like '%Apt.%' then 'Apartment'
		when sub_cat_acc is null and name like '%apt%' then 'Apartment'
		when sub_cat_acc is null and name like '% room %' then 'Room'
		when sub_cat_acc is null and name like '% bedroom %' then 'Room'

		when sub_cat_acc is null and name like '% appartment %' then 'Apartment'
		when sub_cat_acc is null and name like '% appartmant %' then 'Apartment'

		when sub_cat_acc is null and name like '% apartament %' then 'Apartment'
		when sub_cat_acc is null and name like '% aparment %' then 'Apartment'

		when sub_cat_acc is null and name like '% apartmán %' then 'Apartment'

		
		when sub_cat_acc is null and name like '%2BR%' then 'Apartment'
		when sub_cat_acc is null and name like '%byt%' then 'Apartment'
		when sub_cat_acc is null and name like '%Byt%' then 'Apartment'
		when sub_cat_acc is null and name like '% flat %' then 'Apartment'
		when sub_cat_acc is null and name like '%Flat %' then 'Apartment'
		when sub_cat_acc is null and name like '%Loft%' then 'Apartment'
		when sub_cat_acc is null and name like '% LOFT%' then 'Apartment'
		when sub_cat_acc is null and name like '%Penthouse%' then 'Apartment'
		when sub_cat_acc is null and name like '%Residenc%' then 'Apartment'
		when sub_cat_acc is null and name like '%Rezidencia%' then 'Apartment'
		when sub_cat_acc is null and name like '%Bed&Breakfast%' then 'Bed&Breakfast'



		when sub_cat_acc is null and name like '%Junior Suite%' then 'Room'
		when sub_cat_acc is null and name like '%izba%' then 'Room'
		when sub_cat_acc is null and name like '%Izba%' then 'Room'
		when sub_cat_acc is null and name like '%Room %' then 'Room'

	
		when sub_cat_acc is null and name like '%flat%' then 'Apartment'
		when sub_cat_acc is null and name like '%FLAT%' then 'Apartment'
		when sub_cat_acc is null and name like '%Villa Park Komenského%' then 'Apartment House'
	ELSE
		sub_cat_acc
	END, district_id, geom, municipality_name
from base_ke_ke
order by sub_cat_acc
)	
select 
level_0, name, sub_name,
	CASE 
	when sub_cat_acc is null then 'Other'
	ELSE sub_cat_acc
	END,
	CASE 
	when district_id is null then '999'
	ELSE district_id
	END
from abb_base_ke)

/*select district_id, count (*)
from abb_base_ke_ke
group by district_id
order by district_id
*/
select district_id, sub_cat_acc, count (*)
from abb_base_ke_ke where district_id = '999'
group by district_id, sub_cat_acc
order by district_id, sub_cat_acc

