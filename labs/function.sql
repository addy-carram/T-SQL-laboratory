CREATE PROCEDURE Salary_Update (@percent FLOAT) 
AS
BEGIN 
    UPDATE Employees
    SET Salary = (Salary + Salary * @percent)
    WHERE Salary <> (SELECT MAX(Salary) FROM Employees);
END;
GO

EXEC Salary_Update 0.5;

SELECT * FROM Employees;
GO

-- Returns salary calculated including VAT
CREATE FUNCTION CalculateTotal (@VAT INT, @Salary INT)
RETURNS INT
AS
BEGIN
   RETURN @Salary * @VAT;
END;
GO 

SELECT LastName, FirstName, Salary, dbo.CalculateTotal(8, Salary) AS Total
FROM Employees;
GO

-- Inline table-valued function that returns dependents with a specific gender
CREATE FUNCTION Female_Employees (@Gender CHAR)
RETURNS TABLE
AS
RETURN
    SELECT Dependent_LastName, Dependent_FirstName, Gender
    FROM Dependents
    WHERE Gender = @Gender;
GO

SELECT * FROM Female_Employees('F');
GO

-- Multi-statement table-valued function that returns
-- the department in which each employee works
CREATE FUNCTION Employee_Department ()
RETURNS @Employee_Department TABLE
(
    Name NVARCHAR(50),
    Department NVARCHAR(50)
)
AS
BEGIN
    INSERT INTO @Employee_Department (Name, Department)
    SELECT A.LastName, D.Department_Name
    FROM Employees A
    JOIN Departments D ON A.DepartmentId = D.DepartmentId;

    RETURN;
END;
GO

SELECT * FROM Employee_Department();
