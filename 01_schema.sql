
-- Target: shows schema design + constraints 

DROP SCHEMA IF EXISTS company_mgmt CASCADE;
CREATE SCHEMA company_mgmt;

SET search_path TO company_mgmt;

-- departments: small lookup
CREATE TABLE departments (
    department_id   SERIAL PRIMARY KEY,
    department_name TEXT NOT NULL UNIQUE
);

-- roles: job  positions
CREATE TABLE job_roles (
    role_id   SERIAL PRIMARY KEY,
    role_name TEXT NOT NULL UNIQUE
);

-- employees: core entity
CREATE TABLE employees (
    employee_id     SERIAL PRIMARY KEY,
    employee_code   TEXT NOT NULL UNIQUE,      -- e.g. EMP001
    first_name      TEXT NOT NULL,
    last_name       TEXT NOT NULL,
    email           TEXT NOT NULL UNIQUE,
    hire_date       DATE NOT NULL,
    department_id   INT NOT NULL REFERENCES departments(department_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    role_id         INT REFERENCES job_roles(role_id)
        ON UPDATE CASCADE ON DELETE SET NULL,
    is_active       BOOLEAN NOT NULL DEFAULT TRUE,
    -- basic email format check (not perfect, good enough here)
    CHECK (email ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')
);

-- projects: belongs to a project owners (employee)
CREATE TABLE projects (
    project_id      SERIAL PRIMARY KEY,
    project_code    TEXT NOT NULL UNIQUE,
    project_name    TEXT NOT NULL,
    project_owner   INT NOT NULL REFERENCES employees(employee_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    start_date      DATE NOT NULL,
    end_date        DATE,
    status          TEXT NOT NULL CHECK (status IN ('Planned','Active','On Hold','Completed','Cancelled')),
    budget_amount   NUMERIC(12,2) CHECK (budget_amount >= 0),
    -- doesn't allow end date before start
    CHECK (end_date IS NULL OR end_date >= start_date)
);

-- link table: in which employees are assigned to which projects
CREATE TABLE project_assignments (
    project_id      INT NOT NULL REFERENCES projects(project_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    employee_id     INT NOT NULL REFERENCES employees(employee_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    assigned_from   DATE NOT NULL,
    assigned_to     DATE,
    allocation_pct  NUMERIC(5,2) NOT NULL CHECK (allocation_pct > 0 AND allocation_pct <= 100),
    PRIMARY KEY (project_id, employee_id, assigned_from),
    CHECK (assigned_to IS NULL OR assigned_to >= assigned_from)
);

-- timesheets: simple work log per employee/project/day
CREATE TABLE timesheets (
    timesheet_id    SERIAL PRIMARY KEY,
    employee_id     INT NOT NULL REFERENCES employees(employee_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    project_id      INT NOT NULL REFERENCES projects(project_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    work_date       DATE NOT NULL,
    hours_worked    NUMERIC(5,2) NOT NULL CHECK (hours_worked >= 0 AND hours_worked <= 24),
    work_description TEXT,
    -- no duplicate log for the same employee/project/day
    CONSTRAINT uq_timesheet UNIQUE (employee_id, project_id, work_date)
);

-- audit log table (for admin / change tracking later)
CREATE TABLE audit_log (
    audit_id        SERIAL PRIMARY KEY,
    event_time      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    actor           TEXT NOT NULL,       -- who caused the change (username, tool, etc.)
    action          TEXT NOT NULL,       -- e.g. 'INSERT', 'UPDATE', 'DELETE'
    entity_type     TEXT NOT NULL,       -- e.g. 'employee', 'project'
    entity_id       INT,
    details         TEXT
);