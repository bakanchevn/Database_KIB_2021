--Задание 6. Выполнить сегментацию клиентов по количеству букв а в его фамилии - Группа 'A' - 0 букв, 'B' - 1 буква,
-- 'C' - 2 буквы, 'D' - 3 и более букв.
-- Для каждой группы вывести количество уникальных типов медиа,
-- купленных клиентами по трекам из различных жанров метала.
-- Вывести имя группы и количество уникальных типов медиа (segment_group, cnt)

select distinct CASE
                    when (SELECT length(customer.last_name) - length(REPLACE(lower(customer.last_name), 'a', '')) = 0)
                        then 'A'
                    when (SELECT length(customer.last_name) - length(REPLACE(lower(customer.last_name), 'a', '')) = 1)
                        then 'B'
                    when (SELECT length(customer.last_name) - length(REPLACE(lower(customer.last_name), 'a', '')) = 2)
                        then 'C'
                    when (SELECT length(customer.last_name) - length(REPLACE(lower(customer.last_name), 'a', '')) >= 3)
                        then 'D'
                    end                 as segment_group,
                count(distinct mt.name) as cnt
from customer
         join invoice i on customer.customer_id = i.customer_id
         join invoice_line il on i.invoice_id = il.invoice_id
         join track t on il.track_id = t.track_id
         join genre g on t.genre_id = g.genre_id
         join media_type mt on mt.media_type_id = t.media_type_id
where g.name like '%Metal'
group by customer.last_name;
