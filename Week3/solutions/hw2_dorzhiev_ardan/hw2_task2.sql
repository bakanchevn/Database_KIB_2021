/* Для каждого набора жанр, тип медиа вывести количество треков.
 * Если для набора жанр, тип медиа треков нет, то такой набор выводить не требуется. 
 * (genre_name, media_type_name, cnt) 
 */

  select g."name" as genre_name
       , mt."name" as media_type_name
       , count(t.track_id) as cnt_tracks
    from track t
    join media_type mt on t.media_type_id = mt.media_type_id 
    join genre g on t.genre_id = g.genre_id 
group by g.genre_id
       , g."name" 
       , mt.media_type_id 
       , mt."name" 
  having count(t.track_id) > 0 
order by g."name"  