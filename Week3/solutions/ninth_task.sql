

-- Для каждого альбома жанр определяется как наибольшая суммарная продолжительность треков по жанру.
-- Вывести альбом, жанр, и общее количество купленных песен по нему. (album_name, genre_name, cnt)

WITH genre_stat AS (
    SELECT genre_id,
           SUM(milliseconds) sum
    FROM track t
    GROUP BY genre_id
),
     genre_max AS (
         SELECT genre_id,
                MAX(sum) as genre_name
         FROM genre_stat
         GROUP BY genre_id
     )

SELECT DISTINCT title,
       genre_name,
       cnt
FROM album a JOIN track t on a.album_id = t.album_id
    JOIN genre_max USING (genre_id)
        JOIN (SELECT title,
                     sum(quantity) as cnt
              FROM album a JOIN track t on a.album_id = t.album_id
                  JOIN invoice_line il on t.track_id = il.track_id
              GROUP BY title) res USING (title);