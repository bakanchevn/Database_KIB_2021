with recursive Empl(emp_id, id_path, emp_name, lvl) as
(
    select employee_id as emp_id,
           cast(employee_id as text) as id_path,
           cast(last_name || ' ' || first_name as text) as emp_name,
           1 as lvl
    from employee
    where reports_to is null

    union all

    select e.employee_id as emp_id,
           e.employee_id || '->' || prev.id_path as id_path,
           cast(last_name || ' ' || first_name as text) as emp_name,
           prev.lvl + 1 as lvl
      from employee e
      join Empl prev
        on e.reports_to = prev.emp_id
), t1 as (
    select e1.emp_id   as master_id,
           e2.emp_id   as slave_id,
           e1.emp_name as master_name,
           e2.emp_name as slave_name
    from Empl e1
             join Empl e2
                  on e1.lvl <= e2.lvl
    where strpos(e2.id_path, e1.id_path) != 0
), t2 as (
    select t1.master_id   as employee_id,
           t1.master_name as employee_name,
           il.quantity    as amount_of_singletrack,
           g.name         as genre_name,
           t.unit_price   as price_per_track
    from t1
             join customer c
                  on t1.slave_id = c.support_rep_id
             join invoice i
                  on c.customer_id = i.customer_id
             join invoice_line il
                  on i.invoice_id = il.invoice_id
             join track t
                  on t.track_id = il.track_id
             join genre g
                  on t.genre_id = g.genre_id
), count_tracks_table as (
    select t2.employee_id                as employee_id,
           sum(t2.amount_of_singletrack) as tracks_count
    from t2
    group by t2.employee_id
), t3 as (
    select t2.employee_id                as employee_id,
           t2.genre_name                 as genre_name,
           sum(t2.amount_of_singletrack) as tracks_per_genre
    from t2
    group by t2.employee_id, t2.genre_name
), most_popular_genre_table as (
    select distinct on (t3.employee_id) t3.employee_id as employee_id,
                                        t3.genre_name  as genre_name
    from t3
    order by t3.employee_id, t3.tracks_per_genre desc
), t4 as (
    select t2.employee_id as employee_id,
           min(t2.price_per_track) as min_price
    from t2
    group by t2.employee_id
), tracks_minimal_price_table as (
    select t2.employee_id                as employee_id,
           sum(t2.amount_of_singletrack) as tracks_minimal_price
    from t2
             join t4
                  on (t2.employee_id, t2.price_per_track) = (t4.employee_id, t4.min_price)
    group by t2.employee_id
)
select distinct on (t1.master_id) t1.master_name                       as employee_name,
                                  coalesce(r1.tracks_count, 0)         as tracks_count,
                                  r2.genre_name                        as most_popular_genre,
                                  coalesce(r3.tracks_minimal_price, 0) as tracks_minimal_price
  from t1
  left
  join count_tracks_table r1
    on r1.employee_id = t1.master_id
  left
  join most_popular_genre_table r2
    on r2.employee_id = t1.master_id
  left
  join tracks_minimal_price_table r3
    on r3.employee_id = t1.master_id
 order
    by t1.master_id

