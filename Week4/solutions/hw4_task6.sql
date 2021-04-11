with t1 as (
    select g.genre_id                  as g_id,
           g.name                      as g_name,
           t.track_id                  as track_id,
           t.name                      as track_name,
           i.invoice_id                as i_id,
           il.quantity * il.unit_price as spent_for_track,
           il.quantity                 as quantity,
           c.company                   as company_name
    from genre g
             join track t
                  on g.genre_id = t.genre_id
             join invoice_line il
                  on t.track_id = il.track_id
             join invoice i
                  on il.invoice_id = i.invoice_id
             join customer c
                  on i.customer_id = c.customer_id
), t2 as (
    select t1.g_name   as g_name,
           t1.track_id as track_id,
           t1.track_name as track_name,
           count(distinct t1.i_id) as invoices_per_track
    from t1
    group by t1.g_name, t1.track_id, t1.track_name
), most_popular_tracks as (
    select t2.g_name   as g_name,
           t2.track_id as track_id,
           t2.track_name as track_name
    from t2
    where (t2.g_name, t2.invoices_per_track) in (
        select t2.g_name, max(t2.invoices_per_track)
        from t2
        group by t2.g_name
    )
), overall_pay_table as (
    select t1.track_id             as track_id,
           t1.track_name           as track_name,
           t1.g_name               as g_name,
           sum(t1.spent_for_track) as overall_pay
    from most_popular_tracks
             join t1
                  on (t1.track_id, t1.g_name) = (most_popular_tracks.track_id, most_popular_tracks.g_name)
    group by t1.track_id, t1.track_name, t1.g_name
), track_count_table as (
    select t1.g_name        as g_name,
           sum(t1.quantity) as track_count
    from t1
    group by t1.g_name
), t3 as (
    select t1.track_id      as track_id,
           t1.company_name  as company_name,
           sum(t1.quantity) as tracks_per_company
    from t1
             join overall_pay_table
                  on t1.track_id = overall_pay_table.track_id
    where t1.company_name is not null
    group by t1.company_name, t1.track_id
), company_name_table as (
    select distinct on (t3.track_id) t3.track_id     as track_id,
                                     t3.company_name as company_name
    from t3
    where (t3.track_id, t3.tracks_per_company) in (
        select t3.track_id, max(t3.tracks_per_company)
        from t3
        group by t3.track_id
    )
    order by t3.track_id, t3.company_name
)
select opt.track_name as track_name,
       opt.g_name as genre_name,
       opt.overall_pay as overall_pay,
       tct.track_count as track_count,
       cnt.company_name as company_name
  from overall_pay_table opt
  join track_count_table tct
    on opt.g_name = tct.g_name
  left
  join company_name_table cnt
    on cnt.track_id = opt.track_id

