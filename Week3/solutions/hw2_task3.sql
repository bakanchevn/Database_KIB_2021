-- Задание 3. Вывести сотрудников, которые старше своего менеджера, но были наняты позже своего менеджера.
-- Вывести полное имя сотрудника(Фамилия<Пробел>Имя), день рождения, дата найма, полное имя менеджера, день рождения,
-- дата найма.
-- (employee_full_name, employee_birth_date, employee_hire_date, manager_full_name, manager_birth_date, manager_hire_date)

select employee.last_name || ' ' || employee.first_name as employee_full_name,
       employee.birth_date                              as employee_birth_date,
       employee.hire_date                               as employee_hire_date,
       manager.last_name || ' ' || manager.first_name   as manager_full_name,
       manager.birth_date                               as manager_birth_date,
       manager.hire_date                                as manager_hire_date

from employee
         join employee as manager on manager.employee_id = employee.reports_to
where (manager.birth_date < employee.birth_date)
  AND (manager.hire_date < employee.hire_date);
  