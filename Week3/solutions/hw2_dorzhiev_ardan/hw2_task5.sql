/* Для каждого сотрудника 
 * подсчитать количество клиентов, 
 * количество выполненных заказов, 
 * количество уникальных адресов доставки 
 * общее число приобретенных треков
 * вывести полное имя сотрудника. 
 * (employee_full_name, invoices_count, customers_count, addresses_count, tracks_count)
 */

    select concat(e.last_name, ' ', e.first_name) as employee_full_name
       	 , count(distinct c.customer_id) as customers_count
       	 , count(distinct i.invoice_id) as invoices_count
       	 , count(distinct i.billing_address) as addresses_count
       	 , count(iline.track_id) as tracks_count
      from employee e 
 left join customer c on e.employee_id = c.support_rep_id
 left join invoice i on i.customer_id = c.customer_id 
 left join invoice_line iline on i.invoice_id = iline.invoice_id 
  group by e.employee_id
         , concat(e.last_name, ' ', e.first_name) 
    
         /* 
  select *
    from invoice i 
   left join invoice_line iline on i.invoice_id = iline.invoice_id 
   
    select e.employee_id 
    	 , e.title  
   		 , concat(e.last_name, ' ', e.first_name) as employee_full_name
       	 , c.customer_id
       	 , i.invoice_id
       	 , i.billing_address 
       	 , iline.track_id
      from employee e 
 left join customer c on e.employee_id = c.support_rep_id
 left join invoice i on i.customer_id = c.customer_id 
 left join invoice_line iline on i.invoice_id = iline.invoice_id 
  order by e.employee_id */
  
  
 
 