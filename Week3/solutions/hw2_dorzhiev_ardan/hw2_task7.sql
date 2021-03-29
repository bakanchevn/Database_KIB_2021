/* Вывести компании, которые приобрели больше всех композиций по каждому из жанров.
 * При этом указать самую популярную композицию по жанру у данной компании. 
 * (популярность определяется по количеству покупок) (company_name, track_name)
 */ 


with genre_company_cnt_tracks as (--  выведем все заказы с треками, которые купили компании + жанр трека
								select t.genre_id  
									   , c.company 
									   , count(il.track_id) cnt_tracks
								  from customer c 
								  join invoice i on i.customer_id = c.customer_id 
								  join invoice_line il on il.invoice_id = i.invoice_id 
								  join track t on t.track_id = il.track_id 
								 where c.company is not null 
							  group by c.company, t.genre_id
							  order by t.genre_id, c.company
				                 ) , 
  genre_company as (select a.genre_id, a.company
					   from genre_company_cnt_tracks a
					  where (a.genre_id, a.company) in (select a1.genre_id,	a1.company
					    								  from genre_company_cnt_tracks a1
					    								 where a1.genre_id = a.genre_id
					    							  order by a1.cnt_tracks desc, a1.company asc
					    								 limit 1
					    								  )
					),
	company_track_popularity as ( -- треки компании в рамках жанра
							    select t.genre_id
								      , c.company
								      , t.track_id
								      , t."name" as track_name
									  , count(il.invoice_line_id) track_popularity
								  from customer c 
							 	  join invoice i on i.customer_id = c.customer_id 
							      join invoice_line il on il.invoice_id = i.invoice_id 
							      join track t on t.track_id = il.track_id 
							      join genre_company gc on t.genre_id = gc.genre_id and c.company = gc.company
							  group by t.genre_id
								     , c.company
								     , t.track_id
								     , t."name")
								     
	 select -- ctp.genre_id,  -- для проверки 
	 		ctp.company, ctp.track_name as top_track_name
	   from company_track_popularity ctp
	  where (ctp.genre_id, ctp.company, ctp.track_name) in (select ctp1.genre_id, ctp1.company, ctp1.track_name
						    								  from company_track_popularity ctp1
						    								 where ctp1.genre_id = ctp.genre_id
						    								   and ctp1.company = ctp.company
						    							  order by ctp1.track_popularity desc, ctp1.track_name asc
						    								 limit 1
						    								  )
	 order by -- ctp.genre_id, -- для проверки 
	          ctp.company, ctp.track_name
	
        
	 
	   	          
	  




 