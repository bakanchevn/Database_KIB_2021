
-- в выборе убираются песни, которые не были куплены ни разу
--жанры - трек - кол-во покупок
with popular as (
    select  g.name as g_name, t.name as t_name, sum(il.quantity) as quan
    from genre as g
    join track t on g.genre_id = t.genre_id
    join invoice_line il on t.track_id = il.track_id
    group by g.name, il.quantity, t.name
    order by g.name,il.quantity, t.name
),
-- жанр - кол-во песен, которые покупали более одного раза
     q1 as (
         select popular.g_name as name, count(popular.quan) as cnt
         from popular
         group by popular.g_name
-- жанр-трек-процент покупки песни от q1
     ),
     q2 as(
         select popular.g_name, popular.t_name,
                round((popular.quan::numeric/q1.cnt::numeric)*100, 2) as round_q2
         from popular
         join q1 on q1.name=popular.g_name
         order by popular.g_name, round_q2 desc , popular.t_name

     ),
     -- q2 и индексация
     q3 as(
      select *, rank() over(partition by q2.g_name order by q2.round_q2 desc, q2.t_name) as indc
         from q2
         order by q2.g_name, q2.round_q2 desc , q2.t_name
     ),
     -- жанр-трек-процент с учетом предыдущего
     q4 as (
         select q3_s.g_name, q3_s.t_name, sum(q3_f.round_q2) as percent
         from q3 as q3_f
         join q3 as q3_s on q3_f.g_name=q3_s.g_name
         and q3_f.indc <= q3_s.indc
         group by q3_s.g_name, q3_s.t_name, q3_s.indc
         order by q3_s.g_name, q3_s.indc
     ),
     -- q4 только треки, входящие в 25% популярных
     q5 as(
         select q4.g_name,q4.t_name
         from q4
         where q4.percent <= 25
     )
-- конечный вывод
select q5.t_name as track_name, q2.round_q2 as popularity
         from q5
         join q2 on q5.g_name=q2.g_name and q5.t_name=q2.t_name





