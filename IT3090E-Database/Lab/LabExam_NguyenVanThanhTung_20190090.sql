--1.List of people who worked both in London and Toronto
--(1 Point)
select e1.employee_id, e1.first_name, e1.last_name, l1.city from employees e1, departments d1, locations l1
where e1.department_id = d1.department_id and d1.location_id = l1.location_id and lower(l1.city) = 'london'
UNION
select e1.employee_id, e1.first_name, e1.last_name, l1.city from employees e1, departments d1, locations l1
where e1.department_id = d1.department_id and d1.location_id = l1.location_id and lower(l1.city) = 'toronto'
--2.Write a query to display the total number of days in each department that each employee worked in. Sort the ouput according to employee lastname  in alphabetcial order, and then by number of days in decreasing order
--(1 Point)
select (e.first_name + e.last_name) as employee_name, datediff(day, start_date, end_date) as working_days, d.department_name as department_name
from job_history jb, employees e, departments d
where jb.employee_id = e.employee_id
and d.department_id = jb.department_id
order by e.last_name asc, working_days desc
--3.In which countries, the employees working as "Finance manager" obtain the highest average salary?
--(1 Point)
select c1.country_name, avg(e1.salary) from employees e1, jobs j1, departments d1, locations l1, countries c1
where lower(j1.job_title) = 'finance manager' and j1.job_id = e1.job_id 
and e1.department_id = d1.department_id and d1.location_id = l1.location_id and l1.country_id = c1.country_id
group by c1.country_name
--4.Display the employee name who own the phone number as "515.123.4567" and the number of different jobs that he/she worked as.
--(1 Point)
select (e1.first_name + e1.last_name) as employees_name, count (DISTINCT j1.job_id) as number_jobs from employees e1, job_history j1
where e1.phone_number = '515.123.4567' and e1.employee_id = j1.employee_id 
group by (e1.first_name + e1.last_name)
--5.List of employees whose salary is not lower than 90% salary maximum corresponding to their job.
--(1 Point)
select * from employees e1
where e1.salary >= 0.9* (select j1.max_salary from jobs j1 where e1.job_id = j1.job_id)
--6.Display list of employees who has been recruited in the current month. The list must have fullname, hire_date, and direct manager name (if available)
--(1 Point)
select (e1.first_name + ' ' + e1.last_name) as full_name, e1.hire_date, (e2.first_name + ' ' + e2.last_name) as manager_name 
from employees e1 left join employees e2 on e1.manager_id = e2.employee_id
where month(e1.hire_date) = month(getdate())
and year(e1.hire_date) = year(getdate());
--7.Display the employees who have never worked in Japan.
--(1 Point)
select j1.employee_id, c1.country_name from job_history j1, departments d1, locations l1, countries c1
where j1.department_id = d1.department_id and d1.location_id = l1.location_id and l1.country_id = c1.country_id 
and lower(c1.country_name) <> 'japan'
union 
select e1.employee_id, c1.country_name from employees e1, departments d1, locations l1, countries c1
where e1.department_id = d1.department_id and d1.location_id = l1.location_id and l1.country_id = c1.country_id 
and lower(c1.country_name) <> 'japan'
--8.Display jobs whose minimum salary is supperior than 8000
--(1 Point)
select * from jobs 
where min_salary > 8000
--9.Display fullname,salary, hire_date and job name of all employees in "Finance" department.
--(1 Point)
select (e1.first_name + ' ' +e1.last_name) fullname, e1.salary, e1.hire_date, d1.department_name from employees e1, departments d1
where e1.department_id = d1.department_id and lower(d1.department_name) = 'Finance'
--10.Display employees who have no direct managers
--(1 Point)
select * from employees e1 where e1.manager_id is null
--11.Write a query to display employee name and their job history for all employees whose experience is more than 15 years
--(1 Point)
select (e1.first_name + ' ' + e1.last_name) fullname, j1.employee_id, j1.start_date, j1.end_date, j1.job_id, j1.department_id from employees e1, job_history j1
where datediff(year,e1.hire_date, getdate()) > 15 and e1.employee_id = j1.employee_id
--12.Add a new column (column name: as you want) in department table to store the number of employees in each department
--(1 Point)
alter table department add column num_employee int
--13.Write a query to update correct value for this new column for all departments.Immersive Reader
