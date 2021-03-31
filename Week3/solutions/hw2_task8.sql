--Задание 8. Вывести треки по каждому жанру, которые входять в самые популярные 25% с точки зрения количества покупок.
-- Если у нескольких треков одиннаковоко количество приобретенных композиций,
-- популярность определяется в лексикографическом порядке
-- (Например, трек, начинающийся с 'A' будет более популярен, чем трек, начинающийся с 'B').
-- Для каждого трека указать популярность в процентах от общего количества покупок по жанру.
-- (track_name, popularity)
with table_1 as (select genre.name      as genre_name,
                        sum(i.quantity) as sum_buy_genre
                 from genre
                          join track t on genre.genre_id = t.genre_id
                          join invoice_line i on t.track_id = i.track_id
                 group by genre.name),
     table_2 as (
         select g.name                                                          as genre_name,
                t.name                                                          as track_name,
                sum(il.quantity)                                                as sum_buy,
                100.0 * sum(il.quantity) / table_1.sum_buy_genre                as popularity,
                row_number() over (partition by g.name order by g.name, t.name) as track_pos
         from table_1
                  join genre g on g.name = table_1.genre_name
                  join track t on g.genre_id = t.genre_id
                  join invoice_line il on t.track_id = il.track_id
         group by g.name, t.name, table_1.sum_buy_genre
         order by g.name, t.name),
 table_3 as (select table_2.track_name    as track_name,
       table_2.genre_name as genre_name,
       sum(t_2_2.popularity) as buf
from table_2
         join table_2 t_2_2 on t_2_2.genre_name = table_2.genre_name and table_2.track_pos >= t_2_2.track_pos
group by table_2.track_name, table_2.genre_name)
select table_3.track_name, t_2.popularity from table_3
join table_2 t_2 on t_2.track_name = table_3.track_name
where buf <=25
