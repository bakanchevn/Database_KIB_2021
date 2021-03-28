with t1 as (
    select t.track_id as track_id,
           t.name as track_name,
           g.name as genre_name,
           sum(il.quantity) as purchases_of_track
    from track t
             join genre g
                  on t.genre_id = g.genre_id
             join invoice_line il
                  on t.track_id = il.track_id
    group by t.track_id, t.name, g.name
), t2 as (
    select t1.genre_name as genre_name,
           sum(t1.purchases_of_track) as sum_per_genre
      from t1
     group
        by t1.genre_name
), t3 as (
    select t1.genre_name                                             as genre_name,
           t1.track_id                                               as track_id,
           t1.track_name                                             as track_name,
           t1.purchases_of_track / t2.sum_per_genre * 100            as popularity,
           row_number() over (order by t1.genre_name, t1.track_name) as num
    from t1
             join t2
                  on t1.genre_name = t2.genre_name
    order by t1.genre_name, t1.track_name
), t4 as (
    select cp1.genre_name,
           cp1.track_id        as track_id,
           cp1.track_name      as track_name,
           sum(cp2.popularity) as gap
    from t3 cp1
             join t3 cp2
                  on cp1.genre_name = cp2.genre_name and cp1.num >= cp2.num
    group by cp1.track_id, cp1.track_name, cp1.genre_name
)
select t4.track_name as track_name,
       t3.popularity as popularity
  from t4
  join t3
    on t3.track_id = t4.track_id
 where t4.gap <= 25
