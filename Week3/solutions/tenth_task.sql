

-- Для каждого альбома тип медиа определяется как наибольшая суммарный размер треков по жанру.
-- Для каждого исполнителя вывести тип медиа, соответствующий наибольшему количеству типо медиа по альбомам,
-- где они участвуют.
-- Вывести имя исполнителя, тип медиа, количество альбомов с данными типом, общее количество альбомов.
-- (artist_name, media_type_name, media_cnt, whole_cnt)

WITH stat AS (
    SELECT album_id,
           media_type_id,
           SUM(bytes) as size
    FROM album al
             JOIN artist a USING (artist_id)
             JOIN track t USING (album_id)
    GROUP BY album_id, media_type_id
), media_stat AS (
    SELECT album_id,
           MAX(size) as sum
    FROM stat
    GROUP BY album_id
), album_type AS (
    SELECT st.album_id as album_id,
           st.media_type_id as mt
    FROM media_stat mst JOIN stat st ON mst.album_id = st.album_id
                                            AND mst.sum = st.size
), artist_stat AS (
    SELECT artist_id,
           mt,
           count(album_id) as count
    FROM album_type
             JOIN album al USING (album_id)
    GROUP BY artist_id, mt
), artist_max AS (
    SELECT artist_id,
       MAX(count) as sum
    FROM artist_stat
    GROUP BY artist_id
)

SELECT art.name as artist_name,
       met.name as media_type_name,
       sum as media_cnt,
       total as whole_cnt
FROM artist_max am JOIN artist_stat ast ON am.artist_id = ast.artist_id
                                               AND am.sum = ast.count
JOIN (SELECT artist_id,
             sum(count) as total
      FROM artist_stat
      GROUP BY artist_id) t ON am.artist_id = t.artist_id
JOIN media_type met ON met.media_type_id = mt
    JOIN artist art ON art.artist_id = am.artist_id;