CREATE DATABASE EmployeeManagement;
use EmployeeManagement;
CREATE TABLE Departments (
    DepartmentID INT IDENTITY(1,1) PRIMARY KEY,
    DepartmentName NVARCHAR(100) NOT NULL UNIQUE
);


CREATE TABLE Employees (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    DepartmentID INT NOT NULL,
    HireDate DATE NOT NULL DEFAULT GETDATE()
);

CREATE TABLE Salaries (
    EmployeeID INT PRIMARY KEY,
    BaseSalary DECIMAL(10,2) NOT NULL,
    Bonus DECIMAL(10,2) DEFAULT 0,
    Deductions DECIMAL(10,2) DEFAULT 0,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID) ON DELETE CASCADE
);

CREATE TABLE SalaryHistory (
    HistoryID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT NOT NULL,
    OldBaseSalary DECIMAL(10,2),
    NewBaseSalary DECIMAL(10,2),
    ChangeDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID) ON DELETE CASCADE
);



INSERT INTO Departments (DepartmentName) VALUES 
('HR'), ('IT'), ('Finance'), ('Marketing');


INSERT INTO Employees (Name, DepartmentID, HireDate) VALUES 
('Pooja', 1, '2023-01-15'),
('Bob', 2, '2022-03-20'),
('Charlie', 3, '2021-07-10');


INSERT INTO Salaries (EmployeeID, BaseSalary, Bonus, Deductions) VALUES 
(1, 50000, 5000, 2000),
(2, 60000, 7000, 2500),
(3, 55000, 6000, 2300);


SELECT * FROM Employees;
SELECT * FROM Departments;
SELECT * FROM Salaries;
SELECT * FROM SalaryHistory;


SELECT e.EmployeeID, e.Name, d.DepartmentName, e.HireDate
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID;

SELECT e.EmployeeID, e.Name, s.BaseSalary, s.Bonus, s.Deductions,
       (s.BaseSalary + s.Bonus - s.Deductions) AS NetSalary
FROM Employees e
JOIN Salaries s ON e.EmployeeID = s.EmployeeID;


SELECT TOP 1 d.DepartmentName, 
             AVG(s.BaseSalary + s.Bonus - s.Deductions) AS AvgSalary
FROM Departments d
JOIN Employees e ON d.DepartmentID = e.DepartmentID
JOIN Salaries s ON e.EmployeeID = s.EmployeeID
GROUP BY d.DepartmentID, d.DepartmentName
ORDER BY AvgSalary DESC;

EXEC AddEmployee 'John Doe', 2, '2024-02-16';


EXEC CalculatePayroll 2;

EXEC CalculatePayroll NULL;

CREATE VIEW EmployeeSalaryView AS
SELECT 
    e.EmployeeID, 
    e.Name, 
    d.DepartmentName, 
    s.BaseSalary, 
    s.Bonus, 
    s.Deductions, 
    (s.BaseSalary + s.Bonus - s.Deductions) AS NetSalary
FROM Employees e
JOIN Salaries s ON e.EmployeeID = s.EmployeeID
JOIN Departments d ON e.DepartmentID = d.DepartmentID;



SELECT * FROM EmployeeSalaryView;


CREATE VIEW HighEarnerView AS
SELECT 
    e.EmployeeID, 
    e.Name, 
    d.DepartmentName, 
    s.BaseSalary, 
    s.Bonus, 
    s.Deductions, 
    (s.BaseSalary + s.Bonus - s.Deductions) AS NetSalary
FROM Employees e
JOIN Salaries s ON e.EmployeeID = s.EmployeeID
JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE (s.BaseSalary + s.Bonus - s.Deductions) > 60000;


SELECT * FROM HighEarnerView;







