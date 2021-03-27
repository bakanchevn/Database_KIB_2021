
-- Вывести все альбомы со средней длинной трека, большей 250 секунд.
-- Вывести название альбома и количество треков. (album_name, cnt).

SELECT a.title as album_name,
       COUNT(track_id) as cnt
FROM album a JOIN track t USING (album_id)
GROUP BY a.title
HAVING AVG(t.milliseconds) > 250000;