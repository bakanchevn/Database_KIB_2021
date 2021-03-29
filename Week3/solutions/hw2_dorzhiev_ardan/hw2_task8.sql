/* Вывести треки по каждому жанру, которые входять в самые популярные 25% с точки зрения количества покупок. 
 * Если у нескольких треков одинаково количество приобретенных композиций, популярность определяется в лексикографическом порядке 
 * (Например, трек, начинающийся с 'A' будет более популярен, чем трек, начинающийся с 'B'). 
 * Для каждого трека указать популярность в процентах от общего количества покупок по жанру. 
 * (track_name, popularity)
 * 
 * В рамках каждого жанра надо выбрать популярные
 */

29.03.2021 - Пока еще разбираюсь


больше ссреднего - 50% записей 
моду исп-ть? 
sorted aggrefatef functions - 
rank не через оконные ф-ции 


select *
from information_schema.tables 
where table_schema = 'public'

-- определить топ 25% с точки зрения кол-ва покупок
with genre_tracks as (
						select t.genre_id 
							 , t.track_id
							 , t."name"  as track_name
							 , count(il.invoice_id) as cnt_sales
						  from track t 
						  join invoice_line il ON il.track_id = t.track_id 
						 group by t.genre_id 
						 		, t.track_id
						 		, t."name" 
						 order by t.genre_id, count(il.invoice_id) desc, t."name" 
						 ) 
 
		 
 select g.genre_id
 	  , g.track_id 
 	  , g.track_name
 	  , g.cnt_sales
 	  , N -- номер в рамках группы
 	  , (select trunc(count (1) * 0.25) from genre_tracks g1 where g1.genre_id = g.genre_id) N -- граница топ 25% в группе
   from genre_tracks g 
   
  
  --- пронумеровать в рамках группы 
  --- 25% считать от максимальго номера в группе
					 
			select trunc()