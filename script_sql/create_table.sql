/****** Script to create database ******/
IF NOT EXISTS(SELECT * FROM sys.databases WHERE name = 'smb_dev')
BEGIN

CREATE DATABASE [smb_dev]
END
GO

USE [smb_dev]
GO

/****** Script to create table Employee ******/
IF  NOT EXISTS (SELECT * FROM sys.objects 
WHERE object_id = OBJECT_ID(N'[dbo].[Employee]') AND type in (N'U'))

BEGIN
CREATE TABLE [Employee]
(
    Id INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeId NVARCHAR(10) UNIQUE,
    FullName NVARCHAR(100) NOT NULL,
    BirthDate DATE NOT NULL,
    Address NVARCHAR(500)
)

END

/****** Script to inserting data into each table ******/
INSERT INTO [Employee] (EmployeeId, FullName, BirthDate, Address)
VALUES
('10105001', 'Ali Anton', '1982-08-19', 'Jakarta Utara'),
('10105002', 'Rara Siva', '1982-01-01', 'Mandalika'),
('10105003', 'Rini Aini', '1982-02-20', 'Sumbawa Besar'),
('10105004', 'Budi', '1982-02-22', 'Mataram Kota');


/****** Script to create table PositionHistory ******/
IF  NOT EXISTS (SELECT * FROM sys.objects 
WHERE object_id = OBJECT_ID(N'[dbo].[PositionHistory]') AND type in (N'U'))

BEGIN
CREATE TABLE [PositionHistory]
(
    Id INT IDENTITY(1,1) PRIMARY KEY,
    PosId NVARCHAR(10) NOT NULL,
    PosTitle NVARCHAR(100) NOT NULL,
    EmployeeId NVARCHAR(10) NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL
)

END

/****** Script to inserting data into each table ******/
INSERT INTO [PositionHistory] (PosId, PosTitle, EmployeeId, StartDate, EndDate)
VALUES
('50000', 'IT Manager', '10105001', '2022-01-01', '2022-02-28'),
('50001', 'IT Sr. Manager', '10105001', '2022-03-01', '2022-12-31'),
('50002', 'Programmer Analyst', '10105002', '2022-01-01', '2022-02-28'),
('50003', 'Sr. Programmer Analyst', '10105002', '2022-03-01', '2022-12-31'),
('50004', 'IT Admin', '10105003', '2022-01-01', '2022-02-28'),
('50005', 'IT Secretary', '10105003', '2022-03-01', '2022-12-31');


/****** Create query to display all employee (EmployeeId, FullName, BirthDate, Address) data with ******/
/****** their current position information (PosId, PosTitle, EmployeeId, StartDate, EndDate). ******/
SELECT e.EmployeeId, e.FullName, e.BirthDate, e.Address, ph.PosId, ph.PosTitle, ph.StartDate, ph.EndDate
FROM [Employee] e
INNER JOIN (
    SELECT EmployeeId, MAX(StartDate) AS MaxStartDate
    FROM [PositionHistory]
    GROUP BY EmployeeId
) latest ON e.EmployeeId = latest.EmployeeId
INNER JOIN [PositionHistory] ph ON latest.EmployeeId = ph.EmployeeId AND latest.MaxStartDate = ph.StartDate;