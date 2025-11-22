# Employee & Project Management Database (PostgreSQL)

This project is a small but realistic database designed to manage employees, departments, projects, project assignments, and timesheets.    
schema design, constraints, indexing, and writing queries that support reporting and operations.

---

## ⭐ Project Overview

The goal was to design a clean relational database from scratch :

- Normalised tables (employees, departments, roles, projects, assignments, timesheets)
- Clear primary/foreign key relationships
- Data quality rules built directly into the schema (CHECK constraints)
- Practical indexes based on expected query patterns
- Reporting views that make querying easier for analysts or PMs
- A set of SQL queries that answer typical business questions

The entire project was tested using PostgreSQL (via dbfiddle.uk), but the SQL files can run on any modern Postgres instance.

---

## 📂 Files in this Repository

| File | Purpose |
|------|---------|
| **01_schema.sql** | Creates the database schema and all tables with constraints |
| **02_sample_data.sql** | Inserts a small, readable sample dataset for testing |
| **03_indexes.sql** | Index definitions based on common lookup and reporting needs |
| **04_views.sql** | Reporting-friendly views (employees, projects, project hours) |
| **05_analysis_queries.sql** | Useful SQL queries that answer real operational questions |

---

## 🧱 Database Design Highlights

**Entities included:**
- Departments  
- Job Roles  
- Employees  
- Projects  
- Project Assignments (many-to-many)  
- Timesheets  
- Audit table (simple event logging structure)

**Key points:**
- Employees must belong to a department  
- Projects belong to a project owner  
- End dates cannot be earlier than start dates  
- Timesheets allow only one entry per employee/project/day  
- Email format validation on employees  
- Hours worked are capped at 0–24  
- Allocation % for project assignment is validated  

---

## 📊 Example Views

A few views were added to simplify reporting, for example:

### `v_employees_extended`
Employee details joined with department and role names.

### `v_projects_overview`
High-level view of projects with the owner's full name.

### `v_project_hours`
Aggregated hours per employee per project.

These are the kinds of views analysts, PMs, or BI tools often rely on.

---

## 🔍 Example Analysis Queries

The `05_analysis_queries.sql` file includes examples such as:

- Busiest employees by hours worked  
- Total hours per project  
- Cost-per-hour approximation using project budgets  
- Department-level workload distribution  
- Timesheet sanity checks (e.g., >10 hours per day)

These queries help show how this database could actually be used in a real environment.

---

## ▶️ How to Run This Project

1. Open **https://dbfiddle.uk**  
2. Select **PostgreSQL (v15 or above)**  
3. Copy the contents of `01_schema.sql` into the Schema panel and click **Build Schema**  
4. Paste the other SQL files one by one and click **Run**  
5. Try the queries in `05_analysis_queries.sql` to explore the data

---

## 🎯 Why This Project Matters 

This project demonstrates:

- Ability to design a relational model from scratch  
- Understanding of constraints and data validation  
- Awareness of indexing and performance  
- Comfort with SQL joins, grouping, and reporting queries  
- Organising database work into clean, maintainable files  
- Clear communication through documentation


---

If you'd like to try the database or explore the queries, all files are included in this repository.

