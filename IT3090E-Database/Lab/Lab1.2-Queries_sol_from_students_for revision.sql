-- 2.	Write SQL statements for the following requirements: (please store all following statement in a SQL files named: studentName_studentID.sql)
-- 1)	Display (first_name, last_name) with alias “First Name”, “Last Name” of employees who have salary > 10000

SELECT first_name, last_name 
FROM employees WHERE salary > 10000;

-- 2)	Which department (department_id) that has at least one employee? Do not display duplicate values.
SELECT department_id 
FROM departments 
WHERE department_id IN (SELECT department_id FROM employees);

Select distinct department_id
from departments
where departments.department_id in (select department_id from employees);

select distinct department_id
from employees
where not employee_id = 0;

SELECT DISTINCT department_id
FROM employees;

select department_id
from employees
group by department_id
having COUNT(employee_id) >= 1;

SELECT DISTINCT department_id 
FROM employees WHERE department_id IS NOT NULL;

select departments.department_id
from departments
where department_id in (
    select department_id from employees
    );
	

-- 3)	Display all information of employees who have salary > 10 000, ranked in descending order of salary.
SELECT * FROM employees WHERE salary > 10000 ORDER BY salary DESC;

-- 4)	Display all countries in the "Asia" regions.
SELECT countries.* FROM countries, regions 
WHERE countries.region_id = regions.region_id 
AND regions.region_name = 'Asia';

SELECT * FROM countries 
WHERE region_id = ( SELECT region_id FROM regions WHERE region_name = 'Asia');

-- 5)	Display all countries that has name starting with "C";
SELECT * FROM countries WHERE country_name LIKE 'C%';
SELECT * FROM countries WHERE UPPER(country_name) LIKE 'C%';

-- 6)	Display jobs whose title contains "scientist".
SELECT * FROM jobs WHERE job_title LIKE '%scientist%';
SELECT * FROM jobs WHERE UPPER(job_title) LIKE '%SCIENTIST%';	
select *
from jobs
where lower(job_title) like '%scientist%';

-- 7)	Employee who worked in both "accounting" department and "human resources" department
SELECT employee_id 
FROM employees, departments
WHERE employees.department_id = departments.department_id
AND department_name = 'accounting'
INTERSECT
SELECT employee_id 
FROM employees, departments
WHERE employees.department_id = departments.department_id
AND department_name = 'human resource';

SELECT EMPLOYEE_ID 
FROM departments d, job_history j
WHERE d.DEPARTMENT_ID = j.DEPARTMENT_ID
AND d.DEPARTMENT_NAME = 'accounting'
INTERSECT
SELECT EMPLOYEE_ID 
FROM departments d, job_history j
WHERE d.DEPARTMENT_ID = j.DEPARTMENT_ID
AND d.DEPARTMENT_NAME = 'human resources';

select e.employee_id, first_name, last_name, J1.start_date, d1.department_name, J2.start_date, d2.department_name
from job_history J1, job_history J2, employees e, departments d1, departments d2
where e.employee_id = J1.employee_id and
      d1.department_id = J1.department_id and
      d2.department_id = J2.department_id and
      J1.employee_id = J2.employee_id and
      lower(d1.department_name) = 'accounting' 
	  and lower(d2.department_name) = 'human resources';

select * 
from employees emp, departments dpm
where emp.department_id = dpm.department_id and 
	department_name in ("accounting","accounting");

select employee_id, first_name, last_name 
from employees ep, departments dp
where ep.department_id = dp.department_id
and dp.department_name = 'accounting' 
and dp.department_name = 'human resources';

SELECT manager_id
FROM departments
WHERE department_name = 'accounting'
INTERSECT
SELECT manager_id
FROM departments
WHERE department_name = 'human resources';

-- 8)	Display the number of employees in "accounting" department?
SELECT count(employee_id) number_of_employees 
FROM employees, departments 
WHERE employees.department_id = departments.department_id 
	AND departments.department_name = 'accounting';

SELECT COUNT(manager_id)
FROM departments
WHERE department_name = 'accounting';

-- 9)	Highest and lowest salary paid to employees?
SELECT MAX(salary) max_salary, MIN(salary) min_salary 
FROM employees;

-- 10)	Display all information of employees who get the highest salary.
SELECT * FROM employees 
WHERE salary >= ALL(SELECT salary FROM employees);

select *
from employees
where salary > all
	(select salary 
	from employees);

-- 11)	Display the number of employees in each department.
SELECT department_name, count(employee_id) number_of_employees 
FROM departments, employees 
WHERE departments.department_id = employees.department_id 
GROUP BY department_name; -- department_id

SELECT department_id, COUNT(employee_id) AS 'Number of employees' 
FROM employees GROUP BY ( department_id);

select department_name, count(e.department_id)
from departments d left outer join employees e on d.department_id = e.department_id
group by e.department_id, department_name;

