select g.name   as g_name,
       mt.name  as mt_name,
       count(*) as cnt
  from track t
  join genre g
    on g.genre_id = t.genre_id
  join media_type mt
    on mt.media_type_id = t.media_type_id
 group
    by (g.genre_id, mt.media_type_id);