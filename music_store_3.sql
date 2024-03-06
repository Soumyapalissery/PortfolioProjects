WITH best_selling_artists as 
(SELECT artist.artist_id as artist_id, artist.name as  artist_name,
SUM(invoice_line.unit_price*invoice_line.quantity) AS Total_sales
FROM invoice_line
join track on  track.track_id=invoice_line.track_id
JOIN album ON album.album_id=track.album_id
JOIN artist ON artist.artist_id=album.artist_id
GROUP BY 1
ORDER BY 3 DESC LIMIT 1)
SELECT c.customer_id,c.first_name,c.last_name, bsa.artist_name,
sum(il.unit_price*il.quantity) as amt_spend
from invoice i
join  customer c on  c.customer_id=i.customer_id
join invoice_line il on il.invoice_id=i.invoice_id
JOIN track t on t.track_id=il.track_id
JOIN album  a on a.album_id=t.album_id
JOIN best_selling_artists as bsa
On bsa.artist_id=a.artist_id
group by 1,2,3,4
order by 5 desc;
--------------------------------
WITH popular_genre as 
(select count(invoice_line.quantity )as purchases,customer.country,genre.name,genre.genre_id,
row_number()over(partition by customer.country order by count(invoice_line.quantity) desc) as
R_NUMBER FROM invoice_line
JOIN invoice on invoice.invoice_id=invoice_line.invoice_id
JOIN customer ON customer.customer_id=invoice.customer_id
JOIN TRACK ON track.track_id=invoice_line.track_id
join  genre on genre.genre_id=track.genre_id
GROUP BY 2,3,4
ORDER BY 2 ASC,1 DESC
)
SELECT * FROM popular_genre where R_NUMBER<=1;
