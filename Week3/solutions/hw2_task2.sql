-- Задание 2. Для каждого набора жанр, тип медиа вывести количество треков.
-- Если для набора жанр, тип медиа треков нет, то такой набор выводить не требуется.
-- (genre_name, media_type_name, cnt)

select genre.name as genre_name, mt.name as media_type_name, count(t.name) as cnt
from genre
         join track t on genre.genre_id = t.genre_id
         join media_type mt on t.media_type_id = mt.media_type_id
group by genre.name, mt.name;
