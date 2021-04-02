select a.title as album_name
from album as a
   join track as t
      on a.album_id=t.album_id
   where t.milliseconds > 250000
   group by a.title;


select a.title as album_name, count(t) as cnt
from album as a
   join track as t
      on a.album_id = t.album_id
   group by a.title;
