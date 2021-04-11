with t1 as (select distinct on (hire_date)
                   hire_date                    as hire_date,
                   coalesce(
                             lag(hire_date) over (order by hire_date),
                             to_timestamp('1998-12-31', 'YYYY-MM-DD')
                           )                    as previous_date
            from employee
            order by hire_date
), t2 as (
    select t1.hire_date     as hire_date,
           t1.previous_date as previous_date
    from t1
    where t1.hire_date - t1.previous_date > '1 day'
), t3 as (
    select t2.hire_date     as hire_date,
           t2.previous_date as previous_date,
           coalesce(
                      lead(t2.hire_date) over (order by t2.hire_date),
                      to_timestamp('2020-01-02', 'YYYY-MM-DD')
                   )        as next_date
    from t2
)
select coalesce(t_1.previous_date, t_2.hire_date) + interval '1 day' as date_start,
       coalesce(t_1.hire_date, t_2.next_date) - interval '1 day'     as date_end
  from t3 t_1
  full
  join t3 t_2
    on t_1.hire_date = t_2.next_date;
