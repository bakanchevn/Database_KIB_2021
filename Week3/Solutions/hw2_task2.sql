select g.name as general_name, mt.name as media_type, count(t) as cnt
from track as t
   join genre as g
      on g.genre_id = t.genre_id
   join media_type mt
      on t.media_type_id = mt.media_type_id
   group by g.name, mt.name