
-- Вывести сотрудников, которые старше своего менеджера, но были наняты позже своего менеджера.
-- Вывести полное имя сотрудника(Фамилия<Пробел>Имя), день рождения, дата найма,
-- полное имя менеджера, день рождения, дата найма.
-- (employee_full_name, employee_birth_date, employee_hire_date,
-- manager_full_name, manager_birth_date, manager_hire_date)

SELECT e.first_name || ' ' || e.last_name as employee_full_name,
       e.birth_date as employee_birth_date,
       e.hire_date as employee_hire_date,
       m.first_name || ' ' || m.last_name as manager_full_name,
       m.birth_date as manager_birth_date,
       m.hire_date as manager_hire_date
FROM employee e JOIN employee m ON m.employee_id = e.reports_to
WHERE e.birth_date < m.birth_date AND e.hire_date > m.hire_date;