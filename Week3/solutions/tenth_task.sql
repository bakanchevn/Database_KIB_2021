

-- Для каждого альбома тип медиа определяется как наибольшая суммарный размер треков по жанру.
-- Для каждого исполнителя вывести тип медиа, соответствующий наибольшему количеству типо медиа по альбомам,
-- где они участвуют.
-- Вывести имя исполнителя, тип медиа, количество альбомов с данными типом, общее количество альбомов.
-- (artist_name, media_type_name, media_cnt, whole_cnt)


WITH genre_stat AS (
    SELECT genre_id,
           SUM(bytes) sum
    FROM track t
    GROUP BY genre_id
),
     genre_max AS (
         SELECT genre_id,
                MAX(sum) as media_type
         FROM genre_stat
         GROUP BY genre_id
     ),
     general_stat AS (
         SELECT art.name as name,
                media_type,
                t2.album_id as album_id
         FROM artist art JOIN album a on art.artist_id = a.artist_id
             JOIN track t2 on a.album_id = t2.album_id
                JOIN genre_max USING (genre_id)
     )


SELECT f.name as artist_name,
       f.media_type as media_type_name,
       f.cnt as media_cnt,
       total as whole_cnt
FROM (SELECT name,
       media_type,
       COUNT(album_id) as cnt
FROM general_stat
GROUP BY name, media_type) f JOIN (SELECT name,
       count(album_id) as total
FROM general_stat
GROUP BY name) s on f.name = s.name