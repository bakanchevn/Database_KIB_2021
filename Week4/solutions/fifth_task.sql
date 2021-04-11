
-- Задание 5
-- Для каждого сотрудника вывести общее количество купленных треков, проведенных им в заказе,
-- самый часто используемый жанр треков, и общее число треков по минимальной стоимости.
-- Если у сотрудника есть подчиненные, то все величины должны быть подсчитаны с учетом подчинения
-- (то есть все заказы, которые обслужил сам сотрудник + заказы его подчиненных).
-- Учесть потенциальную глубину вложенности.
-- (employee_name, tracks_count, most_popular_genre, tracks_minimal_price).
WITH source_date AS (
    SELECT employee_id,
           genre_id,
           t.track_id as track_id,
           t.unit_price
    FROM employee e JOIN customer c
    ON e.employee_id = c.support_rep_id
        JOIN invoice i on c.customer_id = i.customer_id
            JOIN invoice_line il on i.invoice_id = il.invoice_id
                JOIN track t on il.track_id = t.track_id
), price_amnt AS (
    SELECT employee_id,
           unit_price,
           COUNT(track_id) as count
    FROM source_date
    GROUP BY employee_id, unit_price
), rank_price AS (
    SELECT employee_id,
           unit_price,
           count as count_price,
           row_number() over (PARTITION BY employee_id ORDER BY unit_price, count DESC) as rn
    FROM price_amnt
), genre_amnt AS (
    SELECT employee_id,
           genre_id,
           COUNT(track_id) as count_genre
    FROM source_date
    GROUP BY employee_id, genre_id
), rank_genre AS (
    SELECT
           employee_id,
           genre_id,
           count_genre,
           row_number() over (PARTITION BY employee_id ORDER BY count_genre DESC) as rn
    FROM genre_amnt
), worker_stat AS (SELECT DISTINCT ON(1, 2) employee_id as eid,
                                            COUNT(track_id) OVER (PARTITION BY employee_id) as tracks_count,
                                            rg.genre_id as most_popular_genre,
                                            count_price as tracks_minimal_price
                   FROM source_date sd
    JOIN (SELECT * FROM rank_price WHERE rn = 1) rp USING (employee_id)
        JOIN (SELECT * FROM rank_genre WHERE rn = 1) rg USING (employee_id)
), manager_stat AS (
    SELECT reports_to as eid,
           SUM(tracks_count) as tracks_count,
           mode() within group (order by most_popular_genre) most_popular_genre,
           SUM(tracks_minimal_price) as tracks_minimal_price
    FROM worker_stat ws JOIN employee e1 ON ws.eid = e1.employee_id
    GROUP BY reports_to
), directory_stat AS (
    SELECT e.reports_to as eid,
       SUM(tracks_count) as tracks_count,
       mode() within group (order by most_popular_genre) most_popular_genre,
       SUM(tracks_minimal_price) as tracks_minimal_price
    FROM manager_stat ms
        JOIN employee e ON e.employee_id = ms.eid
    GROUP BY employee_id
), general_report AS (
    SELECT *
    FROM manager_stat
    UNION
    SELECT *
    FROM directory_stat
    UNION
    SELECT *
    FROM worker_stat
)

SELECT first_name || ' ' || last_name as employee_name,
       tracks_count,
       g.name as most_popular_genre,
       tracks_minimal_price
FROM general_report gr JOIN employee e
    ON gr.eid = e.employee_id
        JOIN genre g ON gr.most_popular_genre = g.genre_id