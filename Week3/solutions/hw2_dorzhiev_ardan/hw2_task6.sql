/* Выполнить сегментацию клиентов по количеству букв "а" в его фамилии - Группа 'A' - 0 букв, 'B' - 1 буква, 'C' - 2 буквы, 'D' - 3 и более букв.
 * Для каждой группы вывести количество уникальных типов медиа, купленных клиентами по трекам из различных жанров метала. 
 * Вывести имя группы и количество уникальных типов медиа (segment_group, cnt)
 * */

  select case when LENGTH(c.last_name) - LENGTH(REPLACE(lower(c.last_name), 'a', '')) = 0 then 'A' 
              when LENGTH(c.last_name) - LENGTH(REPLACE(lower(c.last_name), 'a', '')) = 1 then 'B' 
              when LENGTH(c.last_name) - LENGTH(REPLACE(lower(c.last_name), 'a', '')) = 2 then 'C' 
              when LENGTH(c.last_name) - LENGTH(REPLACE(lower(c.last_name), 'a', '')) = 3 then 'D' 
           else 'E' end as segment_group 
       , count(distinct t.media_type_id) as cnt
    from customer c
    join invoice i on c.customer_id = i.customer_id 
    join invoice_line il on il.invoice_id = i.invoice_id 
    join track t on il.track_id = t.track_id 
    join genre g on g.genre_id = t.genre_id 
   where lower(g."name") like '%metal%'
group by case when LENGTH(c.last_name) - LENGTH(REPLACE(lower(c.last_name), 'a', '')) = 0 then 'A' 
              when LENGTH(c.last_name) - LENGTH(REPLACE(lower(c.last_name), 'a', '')) = 1 then 'B' 
              when LENGTH(c.last_name) - LENGTH(REPLACE(lower(c.last_name), 'a', '')) = 2 then 'C' 
              when LENGTH(c.last_name) - LENGTH(REPLACE(lower(c.last_name), 'a', '')) = 3 then 'D' 
           else 'E' end

       /*     
  select c.last_name
       , i.invoice_id 
       , il.invoice_line_id 
       , il.track_id 
       , t.media_type_id
       , g.genre_id 
    from customer c
    join invoice i on c.customer_id = i.customer_id 
    join invoice_line il on il.invoice_id = i.invoice_id 
    join track t on il.track_id = t.track_id 
    join genre g on g.genre_id = t.genre_id 
   where lower(g."name") like '%metal%' 
  order by c.last_name
  
    select t.media_type_id
    from customer c
    join invoice i on c.customer_id = i.customer_id 
    join invoice_line il on il.invoice_id = i.invoice_id 
    join track t on il.track_id = t.track_id 
    join genre g on g.genre_id = t.genre_id 
   where lower(g."name") like '%metal%' 
  group by t.media_type_id
  
  
  */

        