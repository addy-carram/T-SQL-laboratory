-- Exercise 2: Insert 3 more records into the Departments table
-- (Education, Networks, Accounting)
INSERT INTO Departments VALUES
    (6, 'Education', 6),
    (7, 'Networks', 7),
    (8, 'Accounting', 8);

-- Create a table Dependents (DependentId, LastName,
-- FirstName, Gender, Birth_Date, EmployeeId),
-- which will store information about employees' children.
CREATE TABLE Dependents (
    DependentId INT PRIMARY KEY,
    Dependent_LastName NVARCHAR(50),
    Dependent_FirstName NVARCHAR(50),
    Gender CHAR(1),
    Birth_Date DATE,
    EmployeeId INT NOT NULL REFERENCES Employees(EmployeeId)
);

-- Insert 20 records into the newly created table Dependents,
-- such that there are employees with 1, 2, 3, or no children.
INSERT INTO Dependents (DependentId, Dependent_LastName, Dependent_FirstName, Gender, Birth_Date, EmployeeId) VALUES
(1, 'Ermicioi', 'Liviu', 'M', '2015-03-12', 1),
(2, 'Pinteac', 'Andrei', 'M', '2017-07-25', 1),
(3, 'Genu', 'Elena', 'F', '2018-11-08', 2),
(4, 'Popa', 'Mihai', 'M', '2016-02-14', 3),
(5, 'Stoica', 'Ana', 'F', '2019-05-30', 4),
(6, 'Dumitrescu', 'Alexandru', 'M', '2014-09-22', 5),
(7, 'Constantin', 'Ioana', 'F', '2020-01-17', 2),
(8, 'Marin', 'David', 'M', '2016-12-03', 6),
(9, 'Vasile', 'Sofia', 'F', '2018-04-28', 7),
(10, 'Stan', 'Gabriel', 'M', '2015-08-19', 3),
(11, 'Radu', 'Raluca', 'F', '2017-10-11', 8),
(12, 'Matei', 'Victor', 'M', '2019-03-05', 4),
(13, 'Dobre', 'Larisa', 'F', '2016-06-21', 9),
(14, 'Florea', 'Cristian', 'M', '2020-02-09', 5),
(15, 'Niculescu', 'Daniela', 'F', '2015-11-16', 10),
(16, 'Tudor', 'Stefan', 'M', '2018-08-07', 6),
(17, 'Barbu', 'Bianca', 'F', '2017-01-24', 7),
(18, 'Lupu', 'Adrian', 'M', '2019-09-13', 8),
(19, 'Enache', 'Camelia', 'F', '2016-04-30', 9),
(20, 'Stancu', 'Marius', 'M', '2020-07-18', 10);

-- In the Employees table, insert Covali Eugenia into the Education department
-- and the list of your group colleagues. In the Education department,
-- add 5 more teachers who teach IT-related subjects.
INSERT INTO Employees VALUES
    (11, 6, 11, 'Covali', 'Eugenia', 1234567890, 'Stefan cel Mare', 45, 'Chisinau', 'Center', 'F', '1985-03-15', 8500),
    (12, 6, 11, 'Paiu', 'Ala', 1234567891, 'Mihai Eminescu', 12, 'Chisinau', 'Botanica', 'M', '1980-05-20', 7200),
    (13, 6, 11, 'Pollucci', 'Tatiana', 1234567892, 'Alexandru cel Bun', 78, 'Chisinau', 'Rascani', 'F', '1982-09-10', 7000),
    (14, 6, 11, 'Golub', 'Adrian', 1234567893, 'Pushkin', 23, 'Chisinau', 'Ciocana', 'M', '1978-12-05', 7500),
    (15, 6, 11, 'Faina', 'Violeta', 1234567894, 'Dacia', 56, 'Chisinau', 'Buiucani', 'F', '1985-07-18', 6800);
-- (remaining INSERT values continue unchanged)
GO

-- Insert 6 new projects in the Projects table
-- for employees from the newly created departments.
INSERT INTO Projects VALUES
(6, 'Mobile application development', 5000, '2020-07-23', 6),
(7, 'Web development', 8000, '2020-06-30', 6),
(8, 'Application integration', 2300, '2020-06-13', 6),
(9, 'Cloud migration', 1300, '2020-05-05', 8),
(10, 'Network upgrades', 2400, '2020-05-25', 6),
(11, 'Hardware installation', 2400, '2020-05-25', 7);

-- Find the last name and first name of employees
-- who work in the same department as "Covali Eugenia".
SELECT LastName, FirstName
FROM Employees
WHERE DepartmentId = (
    SELECT DepartmentId
    FROM Employees
    WHERE LastName = 'Covali' AND FirstName = 'Eugenia'
);

-- Find the last name, first name, and salary of employees
-- whose salary is higher than the maximum salary
-- of employees working in the same department as "Covali Eugenia".
SELECT LastName, FirstName, Salary
FROM Employees
WHERE Salary = (
    SELECT MAX(Salary)
    FROM Employees
    WHERE DepartmentId = (
        SELECT DepartmentId
        FROM Employees
        WHERE LastName = 'Covali' AND FirstName = 'Eugenia'
    )
);

-- Find the last name and salary of employees who earn
-- more than the department average salary,
-- but where the maximum salary in that department is less than 10000.
SELECT LastName, FirstName, Salary
FROM Employees
WHERE Salary > (
    SELECT AVG(Salary)
    FROM Employees
    WHERE DepartmentId = (
        SELECT DepartmentId
        FROM Employees
        WHERE LastName = 'Covali' AND FirstName = 'Eugenia'
    )
);
