/* Для всех треков жанра Rock и Metal, для каждого артиста подсчитать количество треков. 
 * Вывести имя артиста, количество треков. (artist_name, qty)  
 */

   select ar."name" as artist_name
   		, count(t.track_id) as qty 
	 from track t
	 join genre g on t.genre_id = g.genre_id 
	 join album a on t.album_id = a.album_id 
	 join artist ar on a.artist_id = ar.artist_id 
    where g."name" in ('Rock', 'Metal')
 group by ar.artist_id 
        , ar."name" 
 order by count(t.track_id)
         
	/*select ar."name" 
	    	 , g."name" 
	    	 , t.track_id 
	    	 , t."name" 
	    	 , a.album_id 
	    	 , a.title 
		 from track t
		 join genre g on t.genre_id = g.genre_id 
		 join album a on t.album_id = a.album_id 
		 join artist ar on a.artist_id = ar.artist_id 
	    where g."name" in ('Rock', 'Metal')
	 order by ar."name", t.track_id   
 */      