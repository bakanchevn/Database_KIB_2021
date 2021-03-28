with t1 as (
    select a.album_id   as album_id,
           a.title      as album_name,
           mt.name      as mt_name,
           sum(t.bytes) as size_per_mt,
           a.artist_id  as artist_id
    from album a
             join track t
                  on a.album_id = t.album_id
             join media_type mt
                  on t.media_type_id = mt.media_type_id
    group by a.album_id, a.title, mt.name
),
     t2 as (
         select t1.album_id         as album_id,
                t1.artist_id        as artist_id,
                max(t1.size_per_mt) as max_size
         from t1
         group by t1.album_id, t1.artist_id
     ),
     t3 as (
         select t1.album_id   as album_id,
                t1.album_name as album_name,
                t1.mt_name    as mt_name,
                t1.artist_id  as artist_id
         from t2
                  join t1
                       on (t2.album_id, t2.max_size) = (t1.album_id, t1.size_per_mt)
     ),
     t4 as (
         select ar.artist_id as artist_id,
                ar.name      as artist_name,
                t3.mt_name   as mt_name
         from artist ar
                  left join t3
                            on ar.artist_id = t3.artist_id
     ),
     t5 as (
         select t4.artist_id   as artist_id,
                t4.artist_name as artist_name,
                count(*)       as whole_cnt
         from t4
         group by t4.artist_id, t4.artist_name
     ),
     t6 as (
         select t4.artist_id   as artist_id,
                t4.artist_name as artist_name,
                t4.mt_name     as mt_name,
                count(*)       as media_cnt
         from t4
         group by t4.artist_id, t4.artist_name, t4.mt_name
     ),
     t7 as (
         select t6.artist_id      as artist_id,
                t6.artist_name    as artist_name,
                max(t6.media_cnt) as media_cnt
         from t6
         group by t6.artist_id, t6.artist_name
     ),
     t8 as (
         select distinct on (t6.mt_name, t6.artist_id) t6.mt_name     as mt_name,
                                                       t6.artist_id   as artist_id,
                                                       t6.artist_name as artist_name
         from t6
                  join t7
                       on (t7.artist_id, t7.media_cnt) = (t6.artist_id, t6.media_cnt)
         order by t6.mt_name, t6.artist_id
     )
select t8.artist_name as artist_name,
       t8.mt_name     as media_type_name,
       CASE
           when (t8.mt_name is null) then 0
           else t7.media_cnt
           end        as media_cnt,
       CASE
           when (t8.mt_name is null) then 0
           else t5.whole_cnt
           end        as whole_cnt
from t8
         join t7
              on t7.artist_id = t8.artist_id
         join t5
              on t5.artist_id = t8.artist_id;
