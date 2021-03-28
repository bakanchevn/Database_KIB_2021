select e1.last_name || ' ' || e1.first_name as emp_full_name,
       e1.birth_date                        as emp_birth_date,
       e1.hire_date                         as epm_hire_date,
       e2.last_name || ' ' || e2.first_name as manager_full_name,
       e2.birth_date                        as manager_birth_date,
       e2.hire_date                         as manager_hire_date
  from employee e1
 inner
  join employee e2
    on e1.reports_to = e2.employee_id
 where (e1.birth_date < e2.birth_date)
   and (e1.hire_date > e2.hire_date);