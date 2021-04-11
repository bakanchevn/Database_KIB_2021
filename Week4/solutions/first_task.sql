-- Для каждого артиста вывести все жанры, которые есть в его песнях, и для каждого жанра вывести
-- наиболее продолжительную песню. (artist_name, genre_name, track_name, track_length)

WITH stat AS (
    SELECT art.name as artist_name,
           g.name as genre_name,
           t.name as track_name,
           milliseconds as track_length,
           row_number() over (partition by art.artist_id, genre_id order by milliseconds DESC) as rn
    FROM artist art JOIN album a USING (artist_id)
        JOIN track t USING (album_id)
            JOIN genre g USING (genre_id)
)

SELECT artist_name,
       genre_name,
       track_name,
       track_length
FROM stat
WHERE rn = 1