--Moderate questions
---Write a quer to return the email first_Name, lasr name Genre of all rock music listerners,return the listt alphabetically 
--ordered by email starting with A
SELECT  DISTINCT email, first_name,last_name from customer 
JOIN invoice on customer.customer_id=invoice.customer_id
JOIN invoice_line on invoice.invoice_id=invoice_line.invoice_id
 WHERE track_id in
 (SELECT track_id from track
 JOIN genre   ON track.genre_id=genre.genre_id
 WHERE genre.name LIKE 'Rock')
 ORDER BY email;
--Write a query that returns the artist name and total track count of top 10 rock bands
select artist.artist_id,artist.name,count(artist.artist_id) as number_of_songs
FROM track
JOIN album ON album.album_id=track.album_id
JOIN artist on artist.artist_id=album.artist_id
JOIN genre ON genre.genre_id=track.genre_id
WHERE genre.Name LIKE 'Rock'
GROUP BY artist.artist_id
ORDER BY number_of_songs DESC
LIMIT 10;

--RETURN ALL THE TRACK NAMES  THAT HAVE SONGLENGTH LARGER THAN  THE AVERAGE SONG LENGTH . RETURN NAME  MILLISECONDS  FOR EACH TRACK ORDER BY 
--SONG LENGTHS  WITH LONGEST  SONGS LISTED FIRST
SELECT name, milliseconds from track
where milliseconds >
(SELECT AVG(milliseconds) as average_son_length
from track)
ORDER BY milliseconds DESC;