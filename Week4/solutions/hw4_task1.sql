select distinct on (art.artist_id, g.name) art.name       as artist_name,
                                           g.name         as genre_name,
                                           t.name         as track_name,
                                           t.milliseconds as track_length
  from artist art
  join album a
    on art.artist_id = a.artist_id
  join track t
    on a.album_id = t.album_id
  join genre g
    on t.genre_id = g.genre_id
 order
    by art.artist_id, g.name, t.milliseconds desc;