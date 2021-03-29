
-- Вывести компании, которые приобрели больше всех композиций по каждому из жанров.
-- При этом указать самую популярную композицию по жанру у данной компании.
-- (популярность определяется по количеству покупок) (company_name, track_name)


WITH company_stat AS (
    SELECT *
    FROM invoice i
             JOIN invoice_line il USING (invoice_id)
             JOIN track t USING (track_id)
             JOIN (SELECT customer_id,
                          company
                   FROM customer
                   WHERE company IS NOT NULL) comp USING (customer_id)
),
     top_chart AS(
         SELECT company,
                genre_id,
                SUM(quantity) as count
         FROM company_stat
         GROUP BY company, genre_id
     ),
     count_track AS (
         SELECT company,
                genre_id,
                name,
                SUM(quantity) as pop
         FROM company_stat
         GROUP BY company,genre_id,name
     ),
     top_track AS (
         SELECT company,
               genre_id,
               name,
               MAX(pop)
        FROM count_track
        GROUP BY company,genre_id,name
     )

SELECT DISTINCT ON(2)
       top_chart.company,
       tp.genre_id,
       name
FROM top_chart
JOIN (SELECT genre_id,
             MAX(count) as max
      FROM top_chart
      GROUP BY genre_id ) g_top ON top_chart.genre_id = g_top.genre_id
                                       AND top_chart.count = g_top.max
JOIN top_track tp ON top_chart.company = tp.company
                         AND top_chart.genre_id = tp.genre_id;