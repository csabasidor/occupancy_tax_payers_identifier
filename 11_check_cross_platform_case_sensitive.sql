with totalita as (
with 
fb as (
	select LOWER(regexp_replace(unaccent(name), '[^a-zA-Z0-9]+|Boutique|Hotel|Penzion|Pension|Kosice' , '','g'))  as name, count(*) nm_fb
		from afbplacetest
		group by name
		order by name
		),
goog as ( 
	select LOWER(regexp_replace(unaccent(name), '[^a-zA-Z0-9]+|Boutique|Hotel|Penzion|Pension|Kosice' , '','g')) as name, count(*) nm_gp
		from googleplacestest
		group by name
	  ),
fq as (
	select LOWER(regexp_replace(unaccent(name), '[^a-zA-Z0-9]+|Boutique|Hotel|Penzion|Pension|Kosice' , '','g')) as name, count(*) nm_fq
		from forsquaretest
		group by name
	  ),
ta as (
	select LOWER(regexp_replace(unaccent(name), '[^a-zA-Z0-9]+|Boutique|Hotel|Penzion|Pension|Kosice' , '','g')) as name, count (*) nm_ta
		from tripadvisortest
		group by name
		),
book as (
	select LOWER(regexp_replace(unaccent(name), '[^a-zA-Z0-9]+|Boutique|Hotel|Penzion|Pension|Kosice' , '','g')) as name, count(*) nm_bk
		from bookingtest
		group by name
		),
abb as (		
 	select LOWER(regexp_replace(unaccent(name), '[^a-zA-Z0-9]+|Boutique|Hotel|Penzion|Pension|Kosice' , '','g')) as name, count(*) nm_abb
		from airbnbtest
		group by name
	)
select *, booking + google + tripadvisor + facebook + foursquare as total
from (select name,
		  SUM(Coalesce(book.nm_bk, 0)) booking,
		  SUM(Coalesce(goog.nm_gp, 0)) google,
		  SUM(Coalesce(ta.nm_ta, 0)) tripadvisor,
	  	  SUM(Coalesce(fb.nm_fb, 0)) facebook,
	  	  SUM(Coalesce(fq.nm_fq, 0)) foursquare,
	  	  SUM(Coalesce(abb.nm_abb, 0)) airbnb
	from book
		  full outer join goog using(name)
		  full outer join ta using(name)
   		  full outer join fb using(name)
	  	  full outer join fq using(name)
	  	  full outer join abb using(name)	
	group by name) t
	order by total desc
		  
		  
	
)select *  from totalita 

--select * from bookingtest where name like '%Maraton%'
