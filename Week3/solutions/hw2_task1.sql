-- Задание 1. Вывести все альбомы со средней длинной трека, большей 250 секунд.
-- Вывести название альбома и количество треков.
-- (album_name, cnt).

select distinct title as album_name, count(t.album_id) as cnt
from album
         join track t on album.album_id = t.album_id
group by title
having AVG(t.milliseconds) > 250000;
