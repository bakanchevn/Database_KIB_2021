/* Вывести все альбомы со средней длинной трека, большей 250 секунд. 
 * Вывести название альбома и количество треков. (album_name, cnt).*/


with album_track_length as (select a.album_id 
								 , a.title as album_name
						         , round(avg(t.milliseconds)/1000,0) avg_track_length_in_seconds
						    from album a 
						    join track t on a.album_id = t.album_id 
						group by a.album_id 
							   , a.title 
						  having avg(t.milliseconds)/1000 > 250
						order by a.album_id )
						
select a.title as album_name
	, count(t.track_id) cnt
  from album a 
  join track t on a.album_id = t.album_id 
 where exists (select 1 from album_track_length atl where atl.album_id = a.album_id)
 group by a.album_id
 		, a.title 
 order by a.title 


