SET search_path TO company_mgmt;

-- full employee details with department & role names
CREATE OR REPLACE VIEW v_employees_extended AS
SELECT
    e.employee_id,
    e.employee_code,
    e.first_name,
    e.last_name,
    e.email,
    e.hire_date,
    d.department_name,
    r.role_name,
    e.is_active
FROM employees e
LEFT JOIN departments d ON d.department_id = e.department_id
LEFT JOIN job_roles r    ON r.role_id = e.role_id;

--  project overview with owner name
CREATE OR REPLACE VIEW v_projects_overview AS
SELECT
    p.project_id,
    p.project_code,
    p.project_name,
    p.status,
    p.start_date,
    p.end_date,
    p.budget_amount,
    (e.first_name || ' ' || e.last_name) AS project_owner_name
FROM projects p
JOIN employees e ON e.employee_id = p.project_owner;

-- total hours per project & employee( useful for utilisation reporting)
CREATE OR REPLACE VIEW v_project_hours AS
SELECT
    t.project_id,
    p.project_code,
    p.project_name,
    t.employee_id,
    e.employee_code,
    e.first_name,
    e.last_name,
    SUM(t.hours_worked) AS total_hours
FROM timesheets t
JOIN employees e ON e.employee_id = t.employee_id
JOIN projects  p ON p.project_id = t.project_id
GROUP BY
    t.project_id, p.project_code, p.project_name,
    t.employee_id, e.employee_code, e.first_name, e.last_name;