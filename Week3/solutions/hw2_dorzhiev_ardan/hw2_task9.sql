/* Для каждого альбома жанр определяется как наибольшая суммарная продолжительность треков по жанру. 
 * 
 * Вывести альбом, жанр, и общее количество купленных песен по нему. (album_name, genre_name, cnt)
 * 
 * */

with album_agg as (select a.album_id 
					 , g.genre_id
					 , sum(t.milliseconds) ms_tracks
				  from album a 
				  join track t on t.album_id = a.album_id 
				  join genre g on t.genre_id = g.genre_id 
				  -- where a.album_id in (73, 109) -- FOR TEST 
				  group by a.album_id 
					 	 , g.genre_id
				  order by a.album_id 
		        ) ,
	album_genre as (select a1.album_id
						 , a1.genre_id
					  from album_agg a1
					  where (a1.album_id, a1.genre_id) = (SELECT a2.album_id, a2.genre_id
					  		   								FROM album_agg a2
					  		   							   where a1.album_id = a2.album_id
					  		   							     and a1.genre_id = a2.genre_id
					  		   							    order by a2.ms_tracks desc 
					  		   							    limit 1
					  		   								)			   
					  					   
					  					   
					  					   
				   )

 select a2.title as album_name
 	  , g."name" as genre_name
 	  , count(il.track_id) as cnt
   from album_genre a  
   join album a2 on a.album_id = a2.album_id 
   join genre g on a.genre_id = g.genre_id 
   join track t on a.album_id = t.album_id 
   join invoice_line il on t.track_id = il.track_id 
  group by a2.title 
  		 , g."name" 
