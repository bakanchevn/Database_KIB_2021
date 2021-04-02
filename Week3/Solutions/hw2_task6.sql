-- select  c.last_name
--    from customer as c
--    order by length(c.last_name)-length(replace(lower(c.last_name),'a', ''));
-- -- select *
-- -- from customer;
--
--
-- select length(c.last_name)-length(replace(lower(c.last_name),'a', '')) as s
--    from customer as c
--    group by s
--    order by s;

select  CASE
   when length(c.last_name)-length(replace(lower(c.last_name),'a', '')) = 0
      then 'A'
   when length(c.last_name)-length(replace(lower(c.last_name),'a', '')) = 1
      then 'B'
   when length(c.last_name)-length(replace(lower(c.last_name),'a', '')) = 2
      then 'C'
   else 'D'
  END segment_group, count(distinct mt)
   from customer as c
   join invoice i on c.customer_id = i.customer_id
   join invoice_line i_C on i.invoice_id = i_c.invoice_id
   join track t on i_C.track_id = t.track_id
   join media_type mt on t.media_type_id = mt.media_type_id
   join genre g on g.genre_id = t.genre_id
   where g.name in ('Metal', 'Heavy Metal')
   group by segment_group
   order by segment_group;