select art.name as artist_name, count(tr) as qty
from track as tr
join genre g on tr.genre_id = g.genre_id
join album a on tr.album_id = a.album_id
join artist art on a.artist_id = art.artist_id
where g.name in ('Rock', 'Metal')
group by art.artist_id
