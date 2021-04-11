select a.title  as album_name,
       count(*) as cnt
  from track t
  join album a
    on t.album_id = a.album_id
 group
    by a.album_id
having (avg(t.milliseconds) > 250000);