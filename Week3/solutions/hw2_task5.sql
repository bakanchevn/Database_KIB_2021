select e.last_name || ' ' || e.first_name as empl_full_name,
       count(distinct c.customer_id)      as customer_cnt,
       count(distinct i.invoice_id)       as invoice_cnt,
       count(distinct i.billing_address)  as addresses_cnt,
       sum(i_l.quantity)                  as tracks_cnt
  from customer c
  join employee e
    on c.support_rep_id = e.employee_id
  join invoice i
    on c.customer_id = i.customer_id
  join invoice_line i_l
    on i.invoice_id = i_l.invoice_id
 group
    by e.employee_id;