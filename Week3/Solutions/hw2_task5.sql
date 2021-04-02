select concat(emp.first_name,' ', emp.last_name) as employee_full_name, count(distinct i) as invoices_count,
       count(distinct c) customers_count, count(distinct i.billing_address) as addresses_count,
       count(i_l.track_id) as tracks_count
from employee as emp
join customer c on emp.employee_id = c.support_rep_id
join invoice as i on c.customer_id = i.customer_id
join invoice_line i_l on i.invoice_id = i_l.invoice_id
group by emp.employee_id;

