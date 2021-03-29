with t1 as (
    select g.name            as g_name,
           c.company         as company_name,
           sum(i_l.quantity) as tracks_per_comp_and_genre,
           t.name            as track_name
    from customer c
             join invoice i
                  on c.customer_id = i.customer_id
             join invoice_line i_l
                  on i.invoice_id = i_l.invoice_id
             join track t
                  on i_l.track_id = t.track_id
             join genre g
                  on t.genre_id = g.genre_id
    where company is not null
    group by g.name, c.company, t.track_id
), t2 as (
    select t1.g_name                         as g_name,
           t1.company_name                   as company_name,
           sum(t1.tracks_per_comp_and_genre) as sum_tracks
    from t1
    group by t1.g_name, t1.company_name
), t3 as (
    select t2.g_name          as g_name,
           max(t2.sum_tracks) as max_per_genre
    from t2
    group by t2.g_name
), t4 as (
    select distinct on (t2.g_name) t2.g_name, t2.company_name
    from t2
    join t3
      on (t2.g_name, t2.sum_tracks) = (t3.g_name, t3.max_per_genre)
   order
      by t2.g_name, t2.company_name
), t5 as (
    select t1.g_name,
           t1.company_name,
           t1.tracks_per_comp_and_genre
     from t4
     join t1
       on (t1.g_name, t1.company_name) = (t4.g_name, t4.company_name)
)
select res.company_name, res.track_name
  from (
           select distinct on (t1.g_name) t1.g_name, t1.company_name, t1.track_name
           from t1
           where (t1.g_name, t1.company_name, t1.tracks_per_comp_and_genre)
                     in (select * from t5)
           order by t1.g_name, t1.track_name
       ) as res;