
-- Для всех треков жанра Rock и Metal, для каждого артиста подсчитать количество треков.
-- Вывести имя артиста, количество треков. (artist_name, qty)

SELECT art.name as artist_name,
       COUNT(track_id) as qty
FROM artist art JOIN album a USING (artist_id)
    JOIN track t USING (album_id)
        JOIN (SELECT *
              FROM genre
              WHERE name IN ('Rock', 'Metal')) g USING (genre_id)
GROUP BY art.name;