

-- Вывести все интервалы, в которые не было нанято ни одного сотрудника.
-- Минимальная дата - 1999-01-01, Максимальная - 2020-01-01.
-- Например, если первый сотрудник был нанят 2010-01-02, то первая строка в ответе
-- будет (1999-01-01, 2010-01-01).
-- Интервалы должны быть непересекающимися и закрытыми.
-- Строки должны быть выведене в результирующей выборке в порядке возрастания
-- (date_start, date_end)

INSERT INTO employee(employee_id, first_name, last_name, hire_date)
    VALUES (0, 'blank', 'blank', to_timestamp('1999-01-01', 'YYYY-MM-DD')),
           ((SELECT COUNT(*) + 1 FROM employee), 'blank', 'blank', to_timestamp('2020-01-02', 'YYYY-MM-DD'));

WITH tmp as (
    SELECT DATE(first_value(hire_date) OVER (ORDER BY hire_date
               ROWS BETWEEN current row and 1 following)) as first,
           DATE(last_value(hire_date) OVER (ORDER BY hire_date
               ROWS BETWEEN current row and 1 following)) as second
    FROM employee
)

SELECT (first, second)
FROM tmp
WHERE first != second;