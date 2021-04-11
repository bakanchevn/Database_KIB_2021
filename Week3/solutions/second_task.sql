
-- Для каждого набора жанр, тип медиа вывести количество треков.
-- Если для набора жанр, тип медиа треков нет, то такой набор выводить не требуется.
-- (genre_name, media_type_name, cnt)

SELECT genre.name as genre_name,
       media_type.name as media_type_name,
       COUNT(track_id) as cnt
FROM track JOIN media_type USING (media_type_id)
    JOIN genre USING (genre_id)
GROUP BY genre.name, media_type.name;