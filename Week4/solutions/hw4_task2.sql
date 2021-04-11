with t1 as (select c.company                   as company_name,
                   t.name                      as track_name,
                   g.name                      as genre_name,
                   a.title                     as album_name,
                   il.quantity * il.unit_price as price
            from customer c
                     join invoice i
                          on c.customer_id = i.customer_id
                     join invoice_line il
                          on i.invoice_id = il.invoice_id
                     join track t
                          on il.track_id = t.track_id
                     join genre g
                          on t.genre_id = g.genre_id
                     join album a
                          on t.album_id = a.album_id
            where c.company is not null
)
select distinct on (t1.company_name) t1.company_name as company_name,
                                     t1.track_name   as track_name,
                                     t1.genre_name   as genre_name,
                                     t1.album_name   as album_name
from t1
order by t1.company_name, t1.price desc, t1.track_name;
