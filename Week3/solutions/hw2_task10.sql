--Задание 10. Для каждого альбома тип медиа определяется как наибольшая суммарный размер треков по жанру.
-- Для каждого исполнителя вывести тип медиа, соответствующий наибольшему количеству типов медиа по альбомам,
-- где они участвуют. Вывести имя исполнителя, тип медиа, количество альбомов с данными типом,
-- общее количество альбомов.
-- (artist_name, media_type_name, media_cnt, whole_cnt)

with Media_type_Media_cnt as (select media_type.name as med_type, count(distinct t.album_id) as media_cnt
                              from media_type
                                       join track t on media_type.media_type_id = t.media_type_id
                                       join album a on a.album_id = t.album_id
                              where a.title is not null
                              group by media_type.name)
select Artist_name_Cnt_a_t_Media_type.artist_name as artist_name,
       Artist_name_Cnt_a_t_Media_type.media_type  as media_type,
       m_t_m_c.media_cnt                          as media_cnt,
       (select count(*) from album)               as whole_cnt
from (select distinct on (a2.name) a2.name                             as artist_name,
                                   count(distinct a.title)             as a_t,
                                   Album_name_Sum_bytes_Media_type.m_t as media_type
      from (select distinct on (album.title) album.title as a_t, sum(t.bytes) as sum_b, mt.name as m_t
            from album
                     join track t on album.album_id = t.album_id
                     join media_type mt on t.media_type_id = mt.media_type_id
                     join artist a on a.artist_id = album.artist_id
            group by album.title, mt.name
            order by album.title, sum_b DESC) as Album_name_Sum_bytes_Media_type
               join album a on a.title = a_t
               join track t on a.album_id = t.album_id
               join artist a2 on a2.artist_id = a.artist_id
      group by a2.name, Album_name_Sum_bytes_Media_type.m_t
      order by a2.name, a_t DESC) as Artist_name_Cnt_a_t_Media_type
         join Media_type_Media_cnt m_t_m_c on m_t_m_c.med_type = Artist_name_Cnt_a_t_Media_type.media_type
