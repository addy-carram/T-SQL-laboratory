SELECT * FROM Departments;

BEGIN TRANSACTION Update_Department;
IF EXISTS (
    SELECT Department_Name 
    FROM Departments
    WHERE Department_Name = 'Tester1'
)
BEGIN
    UPDATE Departments
    SET Department_Name = 'Tester'
    WHERE Department_Name = 'Tester1';
END
ELSE
BEGIN
    INSERT INTO Departments (DepartmentId, Department_Name, Manager_Id)
    VALUES (9, 'Tester', 1);
END;

COMMIT;
GO

BEGIN TRANSACTION FEMALE_SALARY_UPDATE;
IF EXISTS (
    SELECT Department_Name 
    FROM Departments 
    WHERE Department_Name = 'Education'
)
BEGIN
    UPDATE Employees
    SET Salary = (SELECT AVG(Salary) FROM Employees WHERE DepartmentId = 6) * 0.1 + Salary
    WHERE Gender = 'F' AND DepartmentId = 6;
END;

COMMIT;
ROLLBACK;
GO

SELECT * FROM Employees;
