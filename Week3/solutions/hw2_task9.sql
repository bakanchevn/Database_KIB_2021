--Задание 9. Для каждого альбома жанр определяется как наибольшая суммарная продолжительность треков по жанру.
-- Вывести альбом, жанр, и общее количество купленных песен по нему.
-- (album_name, genre_name, cnt)


with first_table as (select distinct on (album.title) album.title         as a_n,
                                                      sum(t.milliseconds) as s_t,
                                                      g.name              as g_n
                     from album
                              join track t on album.album_id = t.album_id
                              join genre g on t.genre_id = g.genre_id
                     group by album.title, g.name
                     order by album.title, s_t desc),
     second_table as (select album.title, count(il.quantity) as num
                      from album
                               join track t on album.album_id = t.album_id
                               join invoice_line il on t.track_id = il.track_id
                      group by album.title)
select first_table.a_n as album_name, first_table.g_n as genre_name, s_t.num
from first_table
         join second_table s_t on s_t.title = first_table.a_n;
         