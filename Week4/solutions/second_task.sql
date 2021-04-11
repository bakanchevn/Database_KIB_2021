

-- Для каждой компании вывести трек, за который компания заплатила наибольшую сумму,
-- вывести жанр данного трека и его альбом. (company_name, genre_name, track_name)

WITH stat AS (
    SELECT company as company_name,
           g.name as genre_name,
           t.name as track_name,
           a.title as album_name,
           row_number() OVER (PARTITION BY company ORDER BY quantity * t.unit_price DESC) as rn
    FROM invoice inv
             JOIN (SELECT company,
                          customer_id
                   FROM customer
                   WHERE company IS NOT NULL) c USING (customer_id)
                JOIN invoice_line il USING (invoice_id)
                    JOIN track t USING (track_id)
                        JOIN genre g USING (genre_id)
                            JOIN album a USING (album_id)
)

SELECT company_name,
       genre_name,
       track_name
FROM stat
WHERE rn = 1;