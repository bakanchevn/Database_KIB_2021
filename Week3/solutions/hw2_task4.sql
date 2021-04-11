with artists_id_and_count as
(
           select a.artist_id as ar_id,
                  count(*)    as cnt
             from track t
             join album a
               on a.album_id = t.album_id
            where t.genre_id in (
               select genre_id
               from genre
               where name in ('Rock', 'Metal')
           )
           group by a.artist_id
)
select art.name as artist_name,
       c.cnt    as qty
  from artist art
  join artists_id_and_count c
    on c.ar_id = art.artist_id;