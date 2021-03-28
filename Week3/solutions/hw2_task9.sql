with t1 as (
    select a.album_id     as album_id,
           a.title        as album_title,
           t.milliseconds as track_duration,
           g.name         as genre_name
    from album a
             join track t
                  on a.album_id = t.album_id
             join genre g
                  on t.genre_id = g.genre_id
), t2 as (
    select t1.album_id            as album_id,
           t1.album_title         as album_title,
           t1.genre_name          as genre_name,
           sum(t1.track_duration) as duration_per_genre
    from t1
    group by t1.album_id, t1.album_title, t1.genre_name
), t3 as (
    select t2.album_id                as album_id,
           t2.album_title             as album_title,
           max(t2.duration_per_genre) as max_duration
    from t2
    group by t2.album_id, t2.album_title
), t4 as (
    select t3.album_id    as album_id,
           t3.album_title as album_title,
           t2.genre_name  as genre_name
    from t3
             join t2
                  on (t3.album_id, t3.max_duration) =
                     (t2.album_id, t2.duration_per_genre)
), t5 as (
    select a.album_id       as album_id,
           a.title          as album_title,
           sum(il.quantity) as cnt
    from album a
             join track t
                  on a.album_id = t.album_id
             join invoice_line il
                  on t.track_id = il.track_id
    group by a.album_id, a.title
)
select t4.album_title      as album_name,
       t4.genre_name       as genre_name,
       coalesce(t5.cnt, 0) as cnt
  from t4
  left
  join t5
    on t5.album_id = t4.album_id;
