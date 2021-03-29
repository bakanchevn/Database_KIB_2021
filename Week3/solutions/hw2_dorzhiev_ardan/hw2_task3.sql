/* Вывести сотрудников, которые старше своего менеджера, но были наняты позже своего менеджера. 
 * Вывести полное имя сотрудника(Фамилия<Пробел>Имя), день рождения, дата найма, полное имя менеджера, день рождения, дата найма.
 * (employee_full_name, employee_birth_date, employee_hire_date, manager_full_name, manager_birth_date, manager_hire_date)   
 */

 select concat(e.last_name, ' ', e.first_name) as employee_full_name
      , e.birth_date as employee_birth_date
      , e.hire_date  as employee_hire_date
      , concat(m.last_name, ' ', m.first_name) as manager_full_name
      , m.birth_date as manager_birth_date
      , m.hire_date  as manager_hire_date
   from employee e 
   join employee m on e.reports_to = m.employee_id 
  where e.birth_date < m.birth_date -- работник старше своего менеджера 
    and e.hire_date > m.hire_date  -- работник нанят позже менеджера
  