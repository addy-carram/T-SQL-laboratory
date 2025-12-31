-- Write the script to drop the created views.
-- Create 2 synonyms for the created views.
-- Create a schema and move the created views into the created schema.

-- Create a view (view) Personal_Data, which contains the employee's
-- last name, first name, and the name of the department they belong to.
CREATE VIEW Personal_Data AS
SELECT LastName, FirstName, d.Department_Name
FROM Employees a
JOIN Departments d ON a.DepartmentId = d.DepartmentId;
GO

-- Create a view (view) Parents, which displays each dependent (child)
-- and the name of the parent.
CREATE VIEW Parents AS
SELECT  
    CONCAT(Dependent_LastName, ' ', Dependent_FirstName) AS Child_Name,
    CONCAT(p.LastName, ' ', p.FirstName) AS Parent_Name
FROM Dependents i
JOIN Employees p ON p.EmployeeId = i.EmployeeId
WITH CHECK OPTION;
GO

-- Create a view (view) Department_Data, which displays
-- the average, minimum, and maximum salary, and the number of employees for each department.
CREATE VIEW Department_Data AS 
SELECT 
    AVG(A.salary) AS average_salary,
    MIN(A.salary) AS minimum_salary,
    MAX(A.salary) AS maximum_salary,
    COUNT(A.EmployeeId) AS employee_count,
    D.Department_Name
FROM Employees A
JOIN Departments D ON A.DepartmentId = D.DepartmentId
GROUP BY D.Department_Name
WITH CHECK OPTION;
GO

-- Insert and update 2 records in the Parents view.
SELECT * FROM Parents;

UPDATE Parents
SET Child_Name = 'Dobre Liviu'
WHERE Parent_Name = 'Caminschi Leonid';

SELECT * FROM Parents;

UPDATE Employees
SET LastName = 'Bespalco'
WHERE LastName = 'Bachinshi';

SELECT * FROM Dependents;
SELECT * FROM Employees;

INSERT INTO Dependents (DependentId, Dependent_LastName, Dependent_FirstName, Gender, Birth_Date, EmployeeId)
VALUES 
(21, 'Bacu', 'Cristi', 'M', '2007-10-22', 20),
(22, 'Golic', 'Ana', 'M', '2007-09-22', 16);
GO

-- Create 2 synonyms for the created views.
CREATE SYNONYM Parents_and_Dependents FOR Parents;
CREATE SYNONYM Department_Report FOR Department_Data;
GO

-- Create a schema and move the created views into the created schema.
CREATE SCHEMA user_access;
GO

CREATE VIEW user_access.Employee_Report AS
SELECT * FROM Department_Report;
GO

CREATE ROLE administrator;
GO

GRANT SELECT ON SCHEMA::user_access TO administrator;
GO

CREATE LOGIN IT_Company_Manager
WITH PASSWORD = 'manager_company_it';
GO
    
CREATE USER manager FOR LOGIN IT_Company_Manager;
GO

ALTER ROLE administrator ADD MEMBER manager;
GO

SELECT * FROM Employees;
