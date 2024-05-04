USE [Master]
GO

DECLARE @DBName     NVARCHAR(50)  = N'PersonnelManagement' -- change DBName here and...
DECLARE @DeleteStmt NVARCHAR(Max) = N'DROP    DATABASE IF EXISTS '  + QuoteName(@DBName)
DECLARE @CreateStmt NVARCHAR(Max) = N'CREATE  DATABASE '            + QuoteName(@DBName)
EXECUTE sys.sp_ExecuteSql @stmt = @DeleteStmt
EXECUTE sys.sp_ExecuteSql @stmt = @CreateStmt
GO

USE [PersonnelManagement] -- here!!!
GO

-- create security key --------------------------
CREATE SYMMETRIC KEY EmployeeSymKey
    WITH ALGORITHM = AES_256
    ENCRYPTION BY PASSWORD = 'W34kP4ssw0rd@'
GO

-- have no key ----------------------------------
CREATE TABLE [dbo].[SalaryScale] (
    [SalaryScaleId]         INT             NOT NULL    IDENTITY(1, 1),
    [Group]                 VARCHAR(10)     NOT NULL,
    [Name]                  NVARCHAR(50)    NOT NULL,
);

CREATE TABLE [dbo].[JobPosition] (
    [JobPositionId]         VARCHAR(10)     NOT NULL,
    [JobTitle]              NVARCHAR(20)    NOT NULL,
    [AllowanceCoefficient]  DECIMAL(4, 2)   NOT NULL,
);

CREATE TABLE [dbo].[Department] (
    [DepartmentId]          VARCHAR(10)     NOT NULL,
    [Name]                  NVARCHAR(50)    NOT NULL,
    [ManagerId]             VARCHAR(10)     NOT NULL,
);

-- has a foreign key ----------------------------
CREATE TABLE [dbo].[SalaryLevel] (
    [SalaryLevelId]         INT             NOT NULL    IDENTITY(1, 1),
    [Level]                 NVARCHAR(10)    NOT NULL,
    [Coefficient]           DECIMAL(4, 2)   NOT NULL,

    [SalaryScaleId]         INT             NOT NULL,
);

CREATE TABLE [dbo].[Employee] (
    [EmployeeId]            VARCHAR(10)     NOT NULL,
    [Fullname]              NVARCHAR(150)   NOT NULL,
    [Sex]                   BIT, -- 1 is male, 0 is female
    [DateOfBirth]           DATE,
    [PhoneNumber]           VARCHAR(10),
    [TaxCode]               VARBINARY(Max),

    [SalaryLevelId]         INT             NOT NULL,
    [JobPositionId]         VARCHAR(10)     NOT NULL,
    [DepartmentId]          VARCHAR(10)     NOT NULL,
);

CREATE TABLE [dbo].[Account] (
    [AccountId]             INT             NOT NULL    IDENTITY(1, 1),
    [Username]              VARCHAR(50)     NOT NULL,
    [Password]              VARBINARY(Max)  NOT NULL,
    [Salt]                  VARBINARY(Max)  NOT NULL,
    -- TODO: add email column

    [EmployeeId]            VARCHAR(10)     NOT NULL,
);
GO

-- add unique key --------------------------------------------------------
ALTER TABLE [dbo].[Account]
ADD CONSTRAINT UK_Username      UNIQUE ([Username])
  , CONSTRAINT UK_EmployeeId    UNIQUE ([EmployeeId]);
GO

-- add primary key -------------------------------------------------------
ALTER TABLE [dbo].[SalaryScale] ADD CONSTRAINT [PK_SalaryScale] PRIMARY KEY ([SalaryScaleId]);
ALTER TABLE [dbo].[JobPosition] ADD CONSTRAINT [PK_JobPosition] PRIMARY KEY ([JobPositionId]);
ALTER TABLE [dbo].[Department]  ADD CONSTRAINT [PK_Department]  PRIMARY KEY ([DepartmentId]);
ALTER TABLE [dbo].[SalaryLevel] ADD CONSTRAINT [PK_SalaryLevel] PRIMARY KEY ([SalaryLevelId]);
ALTER TABLE [dbo].[Employee]    ADD CONSTRAINT [PK_Employee]    PRIMARY KEY ([EmployeeId]);
ALTER TABLE [dbo].[Account]     ADD CONSTRAINT [PK_Account]     PRIMARY KEY ([AccountId]);
GO

-- add foreign key -------------------------------------------------------
ALTER TABLE [dbo].[SalaryLevel]
ADD CONSTRAINT [FK_SalaryLevel_SalaryScale] FOREIGN KEY ([SalaryScaleId])   REFERENCES [dbo].[SalaryScale]([SalaryScaleId]);
GO

ALTER TABLE [dbo].[Employee]
ADD CONSTRAINT [FK_Employee_SalaryLevel]    FOREIGN KEY ([SalaryLevelId])   REFERENCES [dbo].[SalaryLevel]([SalaryLevelId])
  , CONSTRAINT [FK_Employee_JobPosition]    FOREIGN KEY ([JobPositionId])   REFERENCES [dbo].[JobPosition]([JobPositionId])
  , CONSTRAINT [FK_Employee_Department]     FOREIGN KEY ([DepartmentId])    REFERENCES [dbo].[Department]([DepartmentId]);
GO

ALTER TABLE [dbo].[Account]
ADD CONSTRAINT [FK_Account_Employee]        FOREIGN KEY ([EmployeeId])      REFERENCES [dbo].[Employee]([EmployeeId]);
GO
