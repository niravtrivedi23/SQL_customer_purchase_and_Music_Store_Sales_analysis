--Music Store Sales & Customer Analysis Using SQL Server


-- Section 1: SALES & REVENUE INSIGHT

-- Q 1 Which Country Genereted the highest total revenue
SELECT TOP 1 billing_country, SUM(CAST(total as FLOAT)) AS revenue
FROM music_database.dbo.invoice
GROUP BY billing_country
ORDER BY revenue DESC;

-- Retrive are the top 5 Customer by Revenue 
SELECT TOP 5 
    c.first_name,
    c.last_name,
    SUM(CAST(i.total AS FLOAT)) AS total_spent
FROM music_database.dbo.customer c
JOIN music_database.dbo.invoice i ON c.customer_id = i.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC;

-- Retrive the Monthy revenue trend
SELECT FORMAT(CAST(invoice_date as datetime),'yyyy-MM') as Month ,SUM(CAST(total AS FLOAT)) AS monthly_revenue
from music_database.dbo.invoice
group by FORMAT(CAST(invoice_date as datetime),'yyyy-MM')
Order by Month;

-- Average Invoice Amount per Customer 
select c.first_name,c.last_name,AVG(CAST(i.total as float)) as AVG_Invoice
from music_database.dbo.customer c
join music_database.dbo.invoice i on c.customer_id=i.customer_id
group by c.first_name,c.last_name,c.customer_id
order by AVG_Invoice DESC;

--Total Revenue By Belling City
select billing_city,SUM(CAST(total as float)) as total_revenue
from music_database.dbo.invoice
group by billing_city
order by total_revenue;

-- SECTION 2: MUSIC & TRACK ANALYSIS
-- Top 1 Highest track purchased                                     
select top 1 t.name as track_name,SUM(CAST(li.quantity as INT)) as total_qty
from music_database.dbo.invoice_line li
join music_database.dbo.track t on t.track_id=li.track_id	
group by t.name
order by total_qty DESC;

-- Most Popular music Genere by sales                                   
select g.name as genere , SUM(CAST(li.quantity as INT)) as total_sold
from music_database.dbo.invoice_line li
join music_database.dbo.track t on t.track_id=li.track_id
join music_database.dbo.genre g on t.genre_id=g.genre_id
group by g.name
order by total_sold;

-- Revenue By Media Type                                                
select m.name, SUM(CAST(li.unit_price  as float)* CAST(li.quantity as INT)) as revenue 
from music_database.dbo.media_type m
join music_database.dbo.track t on m.media_type_id=t.media_type_id
join music_database.dbo.invoice_line li on t.track_id=li.track_id
group by m.name
order by revenue desc;

--Top 3 artists with the most tracks in the store
select top 3 ar.name,COUNT(t.track_id) as total_id
from music_database.dbo.artist ar
join music_database.dbo.album as a on ar.artist_id=a.artist_id
join music_database.dbo.track t on a.album_id=t.album_id
group by ar.name
order by total_id desc;


--SECTION 3: CUSTOMER & EMPLOYEE INSIGHT 

--Count Customer supported by each employee 
select e.first_name+''+e.last_name as Employee_name, COUNT(c.customer_id) as total_customer 
from music_database.dbo.employee e
left join music_database.dbo.customer c on e.employee_id=c.support_rep_id
group by e.first_name,e.last_name;

-- A Customer Name who never made a Purchase
select c.first_name,c.last_name
from music_database.dbo.customer c
left Join music_database.dbo.invoice i on c.customer_id=i.customer_id
where i.invoice_id IS NULL;

-- Higher Customer Revenue 
select top 1 e.first_name+' '+e.last_name,SUM(CAST(i.total as float)) as total_sales
from music_database.dbo.employee e 
join music_database.dbo.customer c on e.employee_id=c.support_rep_id
join music_database.dbo.invoice i on c.customer_id=i.customer_id
group by e.first_name,e.last_name
order by total_sales DESC;


-- Creat a Reusable View
CREATE VIEW customer_spending
SELECT 
	c.customer_id,
	c.first_name,
	c.last_name,
	SUM(CAST(i.total as float)) as total_spent
from music_database.dbo.customer c
join music_database.dbo.invoice i on c.customer_id=i.customer_id
group by c.customer_id,c.first_name,c.last_name;

select * from customer_spending;