     --Жанр - компания - песня - кол-во покупок
   with  gen_comp_track as(
     select g.name, c.company, t.name as t_name, il.quantity
    from genre as g
    join track t on g.genre_id = t.genre_id
    join invoice_line il on t.track_id = il.track_id
    join invoice i on i.invoice_id = il.invoice_id
    join customer c on c.customer_id = i.customer_id
    where c.company is not null
    group by g.name, c.company, t.name, il.quantity
    order by g.name, c.company, il.quantity
    )
     --Жанр и количество покупок одной компанией
     ,
     q2 as(
         select gen_comp_track.name, gen_comp_track.company, count(company) as count
         from gen_comp_track
         group by gen_comp_track.name, gen_comp_track.company
         order by gen_comp_track.name

     )
     -- жанр - максмальная покупка
     ,
     q3 as(
            select q2.name, max(count) as max_count
            from q2
            group by q2.name
            order by q2.name

     )
     -- жанр - компания, которая больше купила этот жанр(соеденияем q2 и q3)
,
     q4 as(
            select distinct on(q3.name) q3.name, q2.company, gen_comp_track.t_name,q3.max_count
            from q2
            join gen_comp_track on q2.name=gen_comp_track.name
            join q3 on q3.name = q2.name
            where q2.count = q3.max_count

          )

select q4.company as company_name, q4.t_name as track_name
from q4;

