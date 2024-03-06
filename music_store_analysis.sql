--1.senior most employee based on the job title>

Select * from employee
ORDER BY  levels desc limit 1;
-- Select * from employee
-- ORDER BY  birthdate;
--2.Which countries have the most invoices--
select count(*) as count_ , billing_country from invoice
group by billing_country order by count_ desc;
--3. What are the top values of total invoices
SELECT  total from invoice
order by total desc limit 3;
--Which city has the  best customers write a query that returns one city  that has  the highest
-- of invoices .Return the  city name and  sum of all invooce totals
Select * from invoice;
SELECT SUM(Total) as invoice_total,billing_city
from  invoice  group by billing_city order by invoice_total desc limit 1;
--Who is the best customers, the person who spends most has  considered as the best customers
SELECT c.first_name,c.customer_id,c.last_name,sum(i.total)as total_ FROM customer c
join invoice i on c.customer_id=i.customer_id
group by c.customer_id
order by total_ desc
limit 1;






