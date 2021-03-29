
-- Выполнить сегментацию клиентов по количеству букв а в его фамилии - Группа 'A' - 0 букв, 'B' - 1 буква,
-- 'C' - 2 буквы, 'D' - 3 и более букв. Для каждой группы вывести количество уникальных типов медиа,
-- купленных клиентами по трекам из различных жанров метала.
-- Вывести имя группы и количество уникальных типов медиа
-- (segment_group, cnt)

select segment_group,
       COUNT(distinct media_type_id)
FROM invoice i JOIN invoice_line il on i.invoice_id = il.invoice_id
    JOIN track ON il.track_id = track.track_id
        JOIN genre g on track.genre_id = g.genre_id
            JOIN (SELECT customer_id,
                         last_name,
                         CASE
                            WHEN CHAR_LENGTH(last_name) - CHAR_LENGTH(REPLACE(last_name, 'a', '')) = 0 THEN 'A'
                            WHEN CHAR_LENGTH(last_name) - CHAR_LENGTH(REPLACE(last_name, 'a', '')) = 1 THEN 'B'
                            WHEN CHAR_LENGTH(last_name) - CHAR_LENGTH(REPLACE(last_name, 'a', '')) = 2 THEN 'C'
                            WHEN CHAR_LENGTH(last_name) - CHAR_LENGTH(REPLACE(last_name, 'a', '')) > 2 THEN 'D'
                        END as segment_group
                 FROM customer) seg ON i.customer_id = seg.customer_id
WHERE g.name LIKE '%Metal'
GROUP BY segment_group;