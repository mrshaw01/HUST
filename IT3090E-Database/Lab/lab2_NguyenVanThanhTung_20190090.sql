create table regions(
  region_id int identity(1,1),
  region_name varchar(25),
  constraint pk_regions primary key (region_id),
)

create table countries(
  country_id varchar(2),
  country_name varchar(40),
  region_id int,
  constraint pk_countries primary key (country_id),
  constraint fk_countries_2regions foreign key (region_id) references regions (region_id),
)

create table locations(
  location_id int,
  street_address varchar(25),
  postal_code varchar(12),
  city varchar(30),
  state_province varchar(12),
  country_id varchar(2),
  constraint pk_locations PRIMARY KEY (location_id),
  constraint fk_locations_2countries FOREIGN key (country_id) references countries (country_id),
)

create table jobs(
  job_id varchar(10),
  job_title varchar(35) default '',
  min_salary int default 8000,
  max_salary int default null,
  constraint pk_jobs primary key (job_id),
  constraint ck_jobs_max_salary check (max_salary <= 25000)
)

create table departments(
  department_id int,
  department_name varchar(30),
  manager_id int,
  location_id int,
  constraint pk_departments primary key (department_id),
  constraint fk_departments_2locations foreign key (location_id) references locations (location_id),
)
create table employees(
  employee_id int,
  first_name varchar(20),
  last_name varchar(25),
  email varchar(25),
  phone_number varchar(20),
  hire_data date,
  job_id varchar(10),
  salary int,
  commission_pct int,
  manager_id int,
  department_id int,
  constraint pk_employees primary key (employee_id),
  constraint fk_employees_2departments foreign key (department_id) references departments(department_id),
  constraint fk_employees_2jobs foreign key (job_id) references jobs(job_id)
)

alter table departments add constraint fk_departments_2employees foreign key (manager_id) references employees(employee_id)

create table job_history(
  employee_id int,
  start_date date,
  end_date date,
  job_id varchar(10),
  department_id int,
  constraint pk_job_history primary key (employee_id, start_date),
  CONSTRAINT fk_job_history_2departments FOREIGN KEY (department_id) REFERENCES departments(department_id),
  CONSTRAINT fk_job_history_2jobs FOREIGN KEY (job_id) REFERENCES jobs(job_id),
  CONSTRAINT fk_job_history_2employees FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
)

-- 1
alter table employees add constraint fk_employees_2_employees foreign key (manager_id) references employees(employee_id)

-- 2
select concat(e.first_name,' ',e.last_name) fullname, j.job_title, e.department_id, d.department_name
from employees e, departments d, jobs j, locations l 
where e.department_id = d.department_id and e.job_id = j.job_id and d.location_id = l.location_id and lower(l.city) = 'london'

-- 3
select d.department_id, d.department_name, e.first_name
from departments d, employees e
where d.department_id = e.department_id and d.manager_id = e.employee_id

-- 4
select e1.employee_id, e1.last_name, e2.employee_id, e2.last_name
from employees e1 left join employees e2
on e1.manager_id = e2.employee_id

-- 7
select distinct jh.employee_id
from job_history jh, departments d, locations l, countries c, regions r 
where jh.department_id = d.department_id and d.location_id = l.location_id and l.country_id = c.country_id and c.region_id = r.region_id and lower(r.region_name)='europe'
except
select distinct jh.employee_id
from job_history jh, departments d, locations l, countries c, regions r 
where jh.department_id = d.department_id and d.location_id = l.location_id and l.country_id = c.country_id and c.region_id = r.region_id and lower(r.region_name)='asia'

-- 8
select jh.employee_id, j.job_title, DATEDIFF(day, JH.start_date, ISNULL(JH.end_date, CAST(GETDATE() as date))) as diff_date
from job_history jh, jobs j
where jh.job_id = j.job_id and jh.department_id = 20;

-- 10
select e.last_name, e.salary, e.salary - (select min(salary) from employees e, jobs j  where e.job_id = j.job_id and lower(j.job_title) = 'mechanism engineer') diff
from employees e, jobs j 
where e.job_id = j.job_id and lower(j.job_title) = 'mechanism engineer'

-- 13
select d.department_id, avg(salary) average_salary
from departments d right join employees e on d.department_id = e.department_id
group by d.department_id
having count(e.employee_id) > 10

-- 14
select j.job_title, avg(e.salary)
from employees e left join jobs j on e.job_id = j.job_id
group by j.job_title







