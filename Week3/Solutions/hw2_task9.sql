
-- Подсчет суммы миллисекунд одинакого жанра
with sum_track as (
               select album.title as album_name, sum(t.milliseconds) as track_mil,sum(il.quantity) as track_buy, g.name as genre_name
        from album
        join track t on album.album_id = t.album_id
        join genre g on t.genre_id = g.genre_id
        join invoice_line il on t.track_id = il.track_id
        group by album.title, g.name
        order by album.title
    ),
     q1 as (
    select sum_track.album_name, max(sum_track.track_mil) as cnt
    from sum_track
    group by sum_track.album_name
)
select q1.album_name, sum_track.genre_name, q1.cnt
from q1
join sum_track on sum_track.album_name=q1.album_name
where q1.cnt = sum_track.track_mil
group by q1.album_name, sum_track.genre_name, q1.cnt;
