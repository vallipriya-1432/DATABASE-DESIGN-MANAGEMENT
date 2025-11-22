SET search_path TO company_mgmt;

-- lookup data
INSERT INTO departments (department_name) VALUES
    ('IT'),
    ('HR'),
    ('Finance'),
    ('Operations');

INSERT INTO job_roles (role_name) VALUES
    ('Developer'),
    ('Business Analyst'),
    ('Project Manager'),
    ('Support Engineer');

-- employees
INSERT INTO employees (employee_code, first_name, last_name, email, hire_date, department_id, role_id)
VALUES
    ('EMP001','Aisha','Khan','aisha.khan@example.com','2021-03-15', 1, 1),
    ('EMP002','Rahul','Menon','rahul.menon@example.com','2020-07-01', 4, 2),
    ('EMP003','Sara','Lee','sara.lee@example.com','2019-11-20', 1, 3),
    ('EMP004','Vikram','Patel','vikram.patel@example.com','2022-01-10', 3, 2),
    ('EMP005','Emily','Brown','emily.brown@example.com','2023-05-05', 2, 4);

-- projects
INSERT INTO projects (project_code, project_name, project_owner, start_date, end_date, status, budget_amount)
VALUES
    ('PRJ001','Order Processing Optimisation', 3, '2023-01-01', NULL,        'Active',     50000),
    ('PRJ002','HR Onboarding Revamp',          5, '2023-04-01', '2023-11-30','Completed',  20000),
    ('PRJ003','Finance Reporting Automation',  4, '2023-06-15', NULL,        'Active',     75000);

-- project assignments as who should be working on which project.
INSERT INTO project_assignments (project_id, employee_id, assigned_from, assigned_to, allocation_pct)
VALUES
    (1, 1, '2023-01-01', NULL, 60.0),   -- Aisha on PRJ001
    (1, 2, '2023-02-01', NULL, 40.0),   -- Rahul on PRJ001
    (2, 5, '2023-04-01', '2023-11-30', 50.0),   -- Emily on PRJ002
    (3, 4, '2023-06-15', NULL, 70.0),   -- Vikram on PRJ003
    (3, 2, '2023-06-20', NULL, 30.0);   -- Rahul also on PRJ003

-- timesheets: a few days of work logs
INSERT INTO timesheets (employee_id, project_id, work_date, hours_worked, work_description)
VALUES
    (1,1,'2023-08-01', 6.0,'Investigated slow batch job'),
    (1,1,'2023-08-02', 7.5,'Optimised SQL queries'),
    (2,1,'2023-08-02', 4.0,'Updated documentation'),
    (5,2,'2023-05-10', 5.0,'Gathered onboarding requirements'),
    (4,3,'2023-07-01', 8.0,'Set up reporting ETL pipeline'),
    (2,3,'2023-07-02', 3.5,'Built finance dashboard draft');