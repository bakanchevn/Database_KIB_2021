--Задание 5. Для каждого сотрудника подсчитать количество клиентов, количестов выполненных заказов,
--           количество уникальных адресов доставки и общее число приобретенных треков и вывести полное имя сотрудника.
-- (employee_full_name, invoices_count, customers_count, addresses_count, tracks_count)

select (employee.first_name || ' ' || employee.last_name) as employee_full_name,
       count(distinct i.invoice_id)                       as invoice_count,
       count(distinct cust.last_name)                     as customers_count,
       count(distinct i.billing_address)                  as addresses_count,
       sum(il.quantity)                                   as tracks_count
from employee
         join customer cust on employee.employee_id = cust.support_rep_id
         join invoice i on cust.customer_id = i.customer_id
         join invoice_line il on i.invoice_id = il.invoice_id
group by employee_full_name;
