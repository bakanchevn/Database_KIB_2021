

-- Для каждого плейлиста вывести трек с наибольшей продолжительностью,
-- трек с наименьшей стоимостью (если у треков одинаковая стоимость, то вывести тот, который весит меньше всех),
-- и жанр данного плейлиста (жанром плейлиста называется тот жанр, треков которого больше всех в плейлисте)
-- (playlist_name, longest_track_name, minimal_price_track, playlist_genre_name).
WITH source_data AS (
    SELECT pl.playlist_id as playlist_id,
           pl.name as playlist_name,
           t.name as track_name,
           milliseconds,
           unit_price,
           bytes,
           track_id,
           genre_id
    FROM playlist pl JOIN playlist_track pt USING (playlist_id)
        JOIN track t USING (track_id)
),
     pl_long AS (
    SELECT playlist_id,
           playlist_name,
           track_name as longest_track_name,
           row_number() over (partition by playlist_id order by milliseconds DESC ) as rn
    FROM source_data
),
     pl_min AS (
    SELECT playlist_id,
           track_name as minimal_price,
           row_number() over (partition by playlist_id order by unit_price DESC, bytes) as rn
    FROM source_data
),
     pl_genre_cnt AS (
    SELECT DISTINCT ON (1, 2) playlist_id,
                              g.name,
                              count(track_id) over (partition by playlist_id, g.genre_id) as cnt
    FROM source_data sd
             JOIN genre g on sd.genre_id = g.genre_id
),
     pl_genre AS (
         SELECT playlist_id,
                name,
                row_number() over (partition by playlist_id order by cnt DESC ) as rn
         FROM pl_genre_cnt
     )

SELECT playlist_id,
       playlist_name,
       longest_track_name,
       minimal_price,
       name
FROM (SELECT *
      FROM pl_min
      WHERE rn = 1
    ) f
    JOIN (SELECT *
          FROM pl_long
          WHERE rn = 1) s USING (playlist_id)
JOIN (SELECT *
      FROM pl_genre
      WHERE rn = 1) pl USING (playlist_id);