with sum_track as (
               select album.title as album_name,album.artist_id, count(t.track_id) as count_t, m_t.name
        from album
        join track t on album.album_id = t.album_id
        join media_type as m_t on t.media_type_id = m_t.media_type_id
        --join invoice_line il on t.track_id = il.track_id
        group by album.title, album.artist_id, m_t.name
        order by album.title
    ),
     q1 as (
    select sum_track.album_name, max(sum_track.count_t) as cnt
    from sum_track
    group by sum_track.album_name
),
     q2 as(
         select sum_track.artist_id,sum_track.name, count(sum_track.album_name) as c_1
         from sum_track
         join q1 on sum_track.album_name=q1.album_name
         where sum_track.count_t=q1.cnt
         group by sum_track.artist_id, sum_track.name
         order by  sum_track.artist_id,  sum_track.name     ),
     q3 as(
         select q2.artist_id, max(q2.c_1) as m_c
         from q2
         group by q2.artist_id
     ),
    q4 as(
        select q2.artist_id, count(q2.name) as all_album
        from q2
        group by q2.artist_id
        order by q2.artist_id
      )
     ,
     q5 as (
         select a.name as artist_name, q2.name as media_type_name, q3.m_c as media_cnt, q4.all_album aswhole_cnt
         from artist as a
         join q4 on a.artist_id=q4.artist_id
         join q3 on a.artist_id=q3.artist_id
         join q2 on q3.artist_id=q2.artist_id
         where q2.c_1=q3.m_c
         )
select *
from q5;