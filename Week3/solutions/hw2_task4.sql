--Задание 4. Для всех треков жанра Rock и Metal, для каждого артиста подсчитать количество треков.
-- Вывести имя артиста, количество треков.
-- (artist_name, qty)


select art.name as artist_name, count(track.name) as qty
from track
         join genre g on g.genre_id = track.genre_id
         join album alb on alb.album_id = track.album_id
         join artist art on art.artist_id = alb.artist_id
where (g.name = 'Rock')
   Or (g.name = 'Metal')
group by art.name;
