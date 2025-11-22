-- A few practical queries on top of the employee / project database.
-- These are the kind of questions a PM, team lead or analyst might ask.

SET search_path TO company_mgmt;

------------------------------------------------------------
-- 1) Basic check: list all active employees with their dept
------------------------------------------------------------
SELECT
    e.employee_id,
    e.employee_code,
    e.first_name,
    e.last_name,
    d.department_name,
    r.role_name,
    e.hire_date,
    e.is_active
FROM employees e
LEFT JOIN departments d ON d.department_id = e.department_id
LEFT JOIN job_roles   r ON r.role_id       = e.role_id
WHERE e.is_active = TRUE
ORDER BY d.department_name, e.last_name, e.first_name;


------------------------------------------------------------
-- 2) Current projects and their owners
------------------------------------------------------------
SELECT
    p.project_id,
    p.project_code,
    p.project_name,
    p.status,
    p.start_date,
    p.end_date,
    p.budget_amount,
    (own.first_name || ' ' || own.last_name) AS owner_name,
    d.department_name AS owner_department
FROM projects p
JOIN employees   own ON own.employee_id   = p.project_owner
JOIN departments d   ON d.department_id   = own.department_id
ORDER BY p.status, p.start_date;


------------------------------------------------------------
-- 3) Total hours logged per project
--    (useful for viewing  which projects are getting the most effort)
------------------------------------------------------------
SELECT
    ph.project_id,
    ph.project_code,
    ph.project_name,
    SUM(ph.total_hours) AS total_hours_logged
FROM v_project_hours ph
GROUP BY ph.project_id, ph.project_code, ph.project_name
ORDER BY total_hours_logged DESC;


------------------------------------------------------------
-- 4) Top 5 busiest employees by hours worked (across all projects)
------------------------------------------------------------
SELECT
    ph.employee_id,
    ph.employee_code,
    ph.first_name,
    ph.last_name,
    SUM(ph.total_hours) AS total_hours_logged
FROM v_project_hours ph
GROUP BY ph.employee_id, ph.employee_code, ph.first_name, ph.last_name
ORDER BY total_hours_logged DESC
LIMIT 5;


------------------------------------------------------------
-- 5) Hours per project, split by employee
--    (quick utilisation view for a given project)
------------------------------------------------------------
-- Change :project_code here if you want a different project.
SELECT
    ph.project_code,
    ph.project_name,
    ph.employee_code,
    ph.first_name,
    ph.last_name,
    ph.total_hours
FROM v_project_hours ph
WHERE ph.project_code = 'PRJ001'
ORDER BY ph.total_hours DESC;


------------------------------------------------------------
-- 6) Simple utilisation summary:
--    how many active projects is each employee currently assigned to?
------------------------------------------------------------
SELECT
    e.employee_id,
    e.employee_code,
    e.first_name,
    e.last_name,
    COUNT(DISTINCT pa.project_id) AS active_projects
FROM employees e
LEFT JOIN project_assignments pa
    ON pa.employee_id = e.employee_id
   AND (pa.assigned_to IS NULL OR pa.assigned_to >= CURRENT_DATE)
LEFT JOIN projects p
    ON p.project_id = pa.project_id
   AND p.status IN ('Planned','Active')
GROUP BY e.employee_id, e.employee_code, e.first_name, e.last_name
ORDER BY active_projects DESC, e.last_name;


------------------------------------------------------------
-- 7) Budget vs hours: very rough "cost per hour" metric per project.
--    (Assumes budget is mainly labour, just for illustration.)
------------------------------------------------------------
WITH project_hours AS (
    SELECT
        project_id,
        SUM(hours_worked) AS total_hours
    FROM timesheets
    GROUP BY project_id
)
SELECT
    p.project_code,
    p.project_name,
    p.status,
    p.budget_amount,
    ph.total_hours,
    CASE
        WHEN ph.total_hours IS NULL OR ph.total_hours = 0 THEN NULL
        ELSE ROUND(p.budget_amount / ph.total_hours, 2)
    END AS approx_budget_per_hour
FROM projects p
LEFT JOIN project_hours ph ON ph.project_id = p.project_id
ORDER BY p.status, p.project_code;


------------------------------------------------------------
-- 8) Timesheet sanity check:
--    look for any days where someone logged more than 10 hours.
------------------------------------------------------------
SELECT
    t.timesheet_id,
    t.employee_id,
    e.employee_code,
    e.first_name,
    e.last_name,
    t.project_id,
    p.project_code,
    t.work_date,
    t.hours_worked,
    t.work_description
FROM timesheets t
JOIN employees e ON e.employee_id = t.employee_id
JOIN projects  p ON p.project_id   = t.project_id
WHERE t.hours_worked > 10
ORDER BY t.work_date DESC;


------------------------------------------------------------
-- 9) Simple project status summary:
--    number of projects by status.
------------------------------------------------------------
SELECT
    status,
    COUNT(*) AS project_count
FROM projects
GROUP BY status
ORDER BY project_count DESC;


------------------------------------------------------------
-- 10) Department-level view:
--     total hours spent by each department on each project.
------------------------------------------------------------
SELECT
    d.department_name,
    p.project_code,
    p.project_name,
    SUM(t.hours_worked) AS total_hours
FROM timesheets t
JOIN employees   e ON e.employee_id   = t.employee_id
JOIN departments d ON d.department_id = e.department_id
JOIN projects    p ON p.project_id    = t.project_id
GROUP BY d.department_name, p.project_code, p.project_name
ORDER BY d.department_name, p.project_code;
