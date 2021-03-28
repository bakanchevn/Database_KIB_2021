select CASE
           when (length(c.last_name) - length(REPLACE(lower(c.last_name), 'a', '')) = 0) then 'A'
           when (length(c.last_name) - length(REPLACE(lower(c.last_name), 'a', '')) = 1) then 'B'
           when (length(c.last_name) - length(REPLACE(lower(c.last_name), 'a', '')) = 2) then 'C'
           when (length(c.last_name) - length(REPLACE(lower(c.last_name), 'a', '')) >= 3) then 'D'
           end                 as segment_group,
       count(distinct mt.name) as cnt
  from customer c
  join invoice i
    on c.customer_id = i.customer_id
  join invoice_line i_l
    on i.invoice_id = i_l.invoice_id
  join track t
    on i_l.track_id = t.track_id
  join genre g
    on t.genre_id = g.genre_id
  join media_type mt
    on mt.media_type_id = t.media_type_id
 where g.name = 'Metal'
    or g.name = 'Heavy Metal'
 group
    by segment_group;