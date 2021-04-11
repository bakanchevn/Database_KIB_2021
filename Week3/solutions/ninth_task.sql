

-- Для каждого альбома жанр определяется как наибольшая суммарная продолжительность треков по жанру.
-- Вывести альбом, жанр, и общее количество купленных песен по нему. (album_name, genre_name, cnt)
WITH stat AS (
    SELECT title,
           album_id,
           genre_id,
           SUM(milliseconds) as duration
    FROM album al
             JOIN artist a USING (artist_id)
             JOIN track t USING (album_id)
    GROUP BY album_id, genre_id
), genre_stat AS (
    SELECT album_id,
           MAX(duration) as sum
    FROM stat
    GROUP BY album_id
)

SELECT title as album_name,
       g.name as genre_name,
       cnt
FROM genre_stat gst JOIN stat st ON gst.album_id = st.album_id
                                        AND gst.sum = st.duration
JOIN (SELECT title,
             SUM(quantity) as cnt
      FROM album a JOIN track t on a.album_id = t.album_id
          JOIN invoice_line il on t.track_id = il.track_id
      GROUP BY title) res USING (title)
JOIN genre g USING (genre_id);