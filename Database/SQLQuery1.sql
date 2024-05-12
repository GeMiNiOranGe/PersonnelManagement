CREATE DATABASE PersonnelManagement
GO

USE PersonnelManagement
GO

----------------------------------------------------------------------------
-- Tao bang
CREATE TABLE Departments (
    DepartmentID VARCHAR(10) PRIMARY KEY,
    DepartmentName NVARCHAR(100) NOT NULL,
    ManagerID VARCHAR(10),
)

CREATE TABLE Employees (
    EmployeeID VARCHAR(10) PRIMARY KEY,
    FullName NVARCHAR(100) NOT NULL,
    Gender BIT NOT NULL, -- 0 = Nam, 1 = Nữ
    DateOfBirth DATE NOT NULL,
    PhoneNumber VARCHAR(20) NOT NULL,
    Salary VARBINARY(Max),
    Allowance VARBINARY(Max),
    TaxCode VARCHAR(30),
    DepartmentID VARCHAR(10)
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
)

CREATE TABLE Accounts (
    AccountID INT PRIMARY KEY IDENTITY(1,1),
    Username VARCHAR(50) NOT NULL UNIQUE,
    Password VARBINARY(Max) NOT NULL,
    Salt UNIQUEIDENTIFIER NOT NULL,
    EmployeeID VARCHAR(10),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
)

CREATE TABLE Roles (
    RoleID INT PRIMARY KEY IDENTITY(1,1),
    RoleName VARCHAR(50) NOT NULL UNIQUE
)

CREATE TABLE AccountRoles (
    AccountRoleID INT PRIMARY KEY IDENTITY(1,1),
    AccountID INT NOT NULL,
    RoleID INT NOT NULL,
    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID),
    FOREIGN KEY (RoleID) REFERENCES Roles(RoleID)
)

CREATE TABLE Logs (
    LogID INT PRIMARY KEY IDENTITY(1,1),
    AccountID INT NOT NULL,
    TableName VARCHAR(50) NOT NULL,
    PrimaryKeyValue VARCHAR(MAX) NOT NULL,
    FieldName VARCHAR(50) NOT NULL,
    OldValue NVARCHAR(MAX),
    NewValue NVARCHAR(MAX),
    ActionType VARCHAR(10) NOT NULL, -- INSERT, UPDATE, DELETE
    LogDate DATETIME NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID)
)
GO

--------------------------------------------------------------------------------
-- Them khoa ngoai
ALTER TABLE Departments
ADD FOREIGN KEY (ManagerID) REFERENCES Employees(EmployeeID)
GO

-----------------------------------------------------------------------------------------------------
-- Them du lieu
INSERT INTO Departments VALUES ('DEP001', N'Nhân sự', null)
INSERT INTO Departments VALUES ('DEP002', N'Tài vụ', null)
INSERT INTO Departments VALUES ('DEP003', N'Thiết kế', null)

--UPDATE Departments SET ManagerID = 'EMP00001' WHERE DepartmentID = 'DEP001'
--UPDATE Departments SET ManagerID = 'EMP00002' WHERE DepartmentID = 'DEP002'
--UPDATE Departments SET ManagerID = 'EMP00003' WHERE DepartmentID = 'DEP003'

INSERT INTO Roles VALUES ('Admin')
INSERT INTO Roles VALUES ('GiamDoc')
INSERT INTO Roles VALUES ('TPNhanSu')
INSERT INTO Roles VALUES ('TruongPhong')
INSERT INTO Roles VALUES ('NVNhanSu')
INSERT INTO Roles VALUES ('NVTaiVu')
INSERT INTO Roles VALUES ('NhanVien')

-------------------------------------------------------------------------------------------------------
-- Create security key
CREATE SYMMETRIC KEY EmployeeSymKey
    WITH ALGORITHM = AES_256
    ENCRYPTION BY PASSWORD = '123456'
GO

CREATE ROLE Admin
CREATE ROLE GiamDoc
CREATE ROLE TPNhanSu
CREATE ROLE TruongPhong
CREATE ROLE NVNhanSu
CREATE ROLE NVTaiVu
CREATE ROLE NhanVien
GO

CREATE OR ALTER PROC spInsertAccount
    @Username               VARCHAR(50)
AS BEGIN
    SET NOCOUNT ON

    DECLARE @DefaultPassword    VARCHAR(50) = '123456'
    DECLARE @Salt               UNIQUEIDENTIFIER
    DECLARE @HashedPassword     VARBINARY(Max)
    DECLARE @SaltedPassword     VARCHAR(Max)

    SET @Salt = NEWID()
    SET @SaltedPassword = @DefaultPassword + Cast(@Salt AS VARCHAR(Max))
    SET @HashedPassword = Cast(HashBytes('SHA2_256', @SaltedPassword) AS VARBINARY(Max))

    INSERT INTO Accounts
            ([Username],    [Password],         [Salt], [EmployeeId])
    VALUES  (@Username,     @HashedPassword,    @Salt,  null)
END
GO

EXEC spInsertAccount Admin123
EXEC spInsertAccount GiamDoc123
select * from Accounts

INSERT INTO AccountRoles VALUES (1, 1)
INSERT INTO AccountRoles VALUES (2, 2)
GO
delete Accounts
CREATE OR ALTER PROC spLogin
    @USERNAME VARCHAR(50),
    @PASSWORD VARCHAR(50),
    @KETQUA INT OUTPUT,
    @ROLENAME VARCHAR(100) OUTPUT
AS
BEGIN
    DECLARE @SALT UNIQUEIDENTIFIER
    DECLARE @HASHED_PASSWORD VARBINARY(MAX)
    DECLARE @INPUT_PASSWORD_SALTED VARCHAR(MAX)
    DECLARE @INPUT_HASHED_PASSWORD VARBINARY(MAX)

    -- Lấy salt và mật khẩu đã được hash từ bảng Accounts dựa trên username được cung cấp
    SELECT @SALT = [Salt], @HASHED_PASSWORD = [Password]
    FROM Accounts
    WHERE [Username] = @USERNAME

    -- Nếu không tìm thấy tên người dùng, gán kết quả là 0 và kết thúc
    IF (@SALT IS NULL OR @HASHED_PASSWORD IS NULL)
    BEGIN
        SET @KETQUA = 0
        RETURN
    END

    -- Tạo một mật khẩu được tạo ra từ mật khẩu nhập và salt từ cơ sở dữ liệu
    SET @INPUT_PASSWORD_SALTED = @PASSWORD + CAST(@SALT AS VARCHAR(MAX))
    SET @INPUT_HASHED_PASSWORD = CAST(HASHBYTES('SHA2_256', @INPUT_PASSWORD_SALTED) AS VARBINARY(MAX))

    -- Kiểm tra xem mật khẩu nhập có khớp với mật khẩu đã hash trong cơ sở dữ liệu không
    IF (@INPUT_HASHED_PASSWORD = @HASHED_PASSWORD)
    BEGIN
        -- Nếu khớp, gán kết quả là 1
        SET @KETQUA = 1

        -- Lấy RoleName từ bảng Roles dựa trên RoleId trong bảng AccountRoles
        SELECT @ROLENAME = R.RoleName
        FROM Roles R
        INNER JOIN AccountRoles AR ON R.RoleId = AR.RoleId
        INNER JOIN Accounts A ON AR.AccountId = A.AccountID
        WHERE A.[Username] = @USERNAME

        -- Nếu không tìm thấy RoleName tương ứng, gán @ROLENAME = NULL hoặc thực hiện các xử lý tùy thuộc vào yêu cầu của bạn
    END
    ELSE
    BEGIN
        -- Nếu không khớp, gán kết quả là 0
        SET @KETQUA = 0
    END
END

GRANT SELECT ON Employees TO Admin
DENY SELECT ON Employees TO GiamDoc



















