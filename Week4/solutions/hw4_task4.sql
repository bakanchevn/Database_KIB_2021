with t1 as (
    select pl.playlist_id as pl_id,
           pl.name        as pl_name,
           t.name         as track_name,
           t.milliseconds as track_duration,
           t.unit_price   as track_price,
           g.name         as genre_name,
           t.bytes        as size
    from playlist pl
             join playlist_track pt
                  on pl.playlist_id = pt.playlist_id
             join track t
                  on pt.track_id = t.track_id
             join genre g
                  on g.genre_id = t.genre_id
), longest_track_table as (
    select distinct on (t1.pl_id) t1.pl_id      as pl_id,
                                  t1.track_name as longest_track_name
   --                               ,max(t1.track_duration) over (partition by t1.pl_id
    --                                  order by t1.track_duration desc, t1.size) as longest_track_name
    from t1
    order by t1.pl_id, t1.track_duration desc, t1.size
), minimal_price_table as (
    select distinct on (t1.pl_id) t1.pl_id      as pl_id,
                                  t1.track_name as track_name
          --                        ,min(t1.track_price) over (partition by t1.pl_id
           --                           order by t1.track_price, t1.size) as minimal_price_track
    from t1
    order by t1.pl_id, t1.track_price, t1.size
), t2 as (
    select t1.pl_id      as pl_id,
           t1.genre_name as genre_name,
           count(*)      as tracks_per_genre
    from t1
    group by t1.pl_id, t1.genre_name
    order by t1.pl_id, t1.genre_name
), genre_table as (
    select distinct on (t2.pl_id) t2.pl_id      as pl_id,
                                  t2.genre_name as genre_name
    from t2
    order by t2.pl_id, t2.tracks_per_genre desc
)
select distinct on (t1.pl_id) t1.pl_name                             as playlist_name,
                              longest_track_table.longest_track_name as longest_track_name,
                              minimal_price_table.track_name         as minimal_price_track,
                              genre_table.genre_name                 as playlist_genre_name
  from t1
  join longest_track_table
    on t1.pl_id = longest_track_table.pl_id
  join minimal_price_table
    on t1.pl_id = minimal_price_table.pl_id
  join genre_table
    on t1.pl_id = genre_table.pl_id
 order
    by t1.pl_id;

with recursive Empl(emp_id, name_path, title_path, lvl) as
(
    select employee_id as emp_id,
           cast(last_name || ' ' || first_name as text) as name_path,
           cast(title as text) as title_path,
           1 as lvl
    from employee
    where reports_to is null

    union all

    select e.employee_id as emp_id,
           e.last_name || ' ' || e.first_name || '->' || prev.name_path as name_path,
           e.title || '->' || prev.title_path,
           prev.lvl + 1 as lvl
      from employee e
      join Empl prev
        on e.reports_to = prev.emp_id
)
select * from Empl;