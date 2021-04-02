select concat(emp.first_name,' ', emp.last_name) as employee_full_name, emp.birth_date as employee_birth_date,
       emp.hire_date as employee_hire_date, concat(manager.first_name, ' ', manager.last_name) as manager_full_name,
       manager.birth_date as manager_birth_date, manager.hire_date as manager_hire_date
from employee as emp
    left
   join employee as manager
      on emp.reports_to = manager.employee_id
   where emp.birth_date < manager.birth_date
   and emp.hire_date > manager.hire_date;

