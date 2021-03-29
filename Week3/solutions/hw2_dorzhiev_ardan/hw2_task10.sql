/* Для каждого альбома тип медиа определяется как наибольшая суммарный размер треков по жанру. 
 * Для каждого исполнителя вывести тип медиа, соответствующий наибольшему количеству типов медиа по альбомам, где они участвуют.
 * Вывести имя исполнителя, тип медиа, количество альбомов с данными типом, общее количество альбомов. 
 * 
 * (artist_name, media_type_name, media_cnt, whole_cnt)
 * 
 * */


with album_agg as (select a.album_id 
					 , t.media_type_id 
					 , sum(t.bytes) size_tracks
				  from album a 
				  join track t on t.album_id = a.album_id 
				  group by a.album_id 
					 	 , t.media_type_id
				  order by a.album_id 
		        ) ,
	album_media as (select a1.album_id
						 , a1.media_type_id
					  from album_agg a1
					  join album a on a1.album_id = a.album_id 
					  where (a1.album_id, a1.media_type_id) in (select a2.album_id, a2.media_type_id
					  										      from album_agg a2 
					  						   					 where a1.album_id = a2.album_id
					  						   					   and a1.media_type_id = a2.media_type_id 
					  						   				  order by a2.size_tracks desc 
					  						   					 limit 1 
					  										     )			      
					  					      
					  					      
				   ) , 
				   
	artist_albums_media as (	select a.artist_id
								 , am.media_type_id
								 , count(distinct al.album_id) cnt_albums 
						      from artist a 
							  join album al on al.album_id = a.artist_id 
							  join album_media am on al.album_id = am.album_id 
							  group by a.artist_id
								 	 , am.media_type_id
						) ,
						
	artist_cnt_media as (select ar.artist_id
							  , m.media_type_id
							  , count(distinct a.album_id) cnt_media_albums
	   					   from album a
	   					   join album_media m on a.album_id = m.album_id
	   					   join artist ar on a.artist_id = ar.artist_id 
	   				   group by ar.artist_id
							  , m.media_type_id
						) ,
						
	artist_cnt_albums as (select ar.artist_id
							  , count(distinct a.album_id) cnt_albums 
	   					   from album a
	   					   join artist ar on a.artist_id = ar.artist_id 
	   				   group by ar.artist_id
						) 						
						
						
 select a."name" as artist_name
 	  , mt."name" as media_type_name
 	  , acm.cnt_media_albums as media_cnt
 	  , aca.cnt_albums as whole_cnt
   from artist_albums_media am 
   join artist_cnt_media acm on am.artist_id = acm.artist_id
   join artist_cnt_albums aca on am.artist_id = aca.artist_id
   join artist a on am.artist_id = a.artist_id 
   join media_type mt on am.media_type_id = mt.media_type_id 
  where am.cnt_albums in (select max(am1.cnt_albums) c 
                            from artist_albums_media am1
                           where am1.artist_id = am.artist_id) 
                           
  
	