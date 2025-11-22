SET search_path TO company_mgmt;

-- helpful indexes (based on likely queries)

-- people often search employees by email or code
CREATE INDEX idx_employees_email ON employees(email);
CREATE INDEX idx_employees_code  ON employees(employee_code);

-- reports  often filter projects by status / owner
CREATE INDEX idx_projects_status       ON projects(status);
CREATE INDEX idx_projects_project_owner ON projects(project_owner);

-- timesheet reporting almost always filters by date + project
CREATE INDEX idx_timesheets_project_date
    ON timesheets(project_id, work_date);

-- quick lookup of assignments by employee
CREATE INDEX idx_assignments_employee
    ON project_assignments(employee_id);