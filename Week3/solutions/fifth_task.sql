
-- Для каждого сотрудника подсчитать количество клиентов, количестов выполненных заказов,
-- количество уникальных адресов доставки и общее число приобретенных треков и вывести полное имя сотрудника.
-- (employee_full_name, invoices_count, customers_count, addresses_count, tracks_count)

SELECT e.first_name || ' ' || e.last_name as employee_full_name,
       SUM(cnt_inv) as invoices_count,
       COUNT(c.customer_id) as customers_count,
       SUM(cnt_addr) as addresses_count,
       SUM(cnt_trc) as tracks_count
FROM customer c JOIN (
    SELECT customer_id,
           count(distinct invoice_id) as cnt_inv,
           count(distinct billing_address) as cnt_addr,
           count(track_id) as cnt_trc
    FROM customer c
             JOIN invoice i USING (customer_id)
             JOIN invoice_line il USING (invoice_id)
    GROUP BY customer_id) st USING (customer_id)
        JOIN employee e on c.support_rep_id = e.employee_id
GROUP BY e.first_name || ' ' || e.last_name;