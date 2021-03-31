--Задание 7. Вывести компании, которые приобрели больше всех композиций по каждому из жанров.
-- При этом указать самую популярную композицию по жанру у данной компании.
-- (популярность определяется по количеству покупок)
-- (company_name, track_name)


with table_1 as (select distinct on (genre.name) genre.name as name, c.company, sum(il.quantity) as sum
                 from genre
                          join track t on genre.genre_id = t.genre_id
                          join invoice_line il on t.track_id = il.track_id
                          join invoice i on i.invoice_id = il.invoice_id
                          join customer c on c.customer_id = i.customer_id
                 where c.company is not null
                 group by genre.name, c.company
                 order by genre.name, sum desc, c.company),
     table_2 as (
         select c.company, g.name as name, track.name as track, sum(il.quantity) as sum
         from track
                  join genre g on g.genre_id = track.genre_id
                  join invoice_line il on track.track_id = il.track_id
                  join invoice i on i.invoice_id = il.invoice_id
                  join customer c on c.customer_id = i.customer_id
         where c.company is not null
         group by c.company, g.name, track.name
         order by c.company, sum desc, c.company)
select table_3.company, table_3.track from (select distinct on (table_1.name) table_1.company, table_1.name, t_2.track
      from table_1
               join table_2 t_2 on t_2.name = table_1.name
      where table_1.company = t_2.company
        and t_2.name = table_1.name
      order by  table_1.name,table_1.company, t_2.track) as table_3
