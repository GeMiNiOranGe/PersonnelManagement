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
    Salary VARBINARY(MAX),
    Allowance VARBINARY(MAX),
    TaxCode VARCHAR(30),
    DepartmentID VARCHAR(10)
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
)

CREATE TABLE Accounts (
    AccountID INT PRIMARY KEY IDENTITY(1,1),
    Username VARCHAR(50) NOT NULL UNIQUE,
    Password VARBINARY(MAX) NOT NULL,
    Salt UNIQUEIDENTIFIER NOT NULL,
    EmployeeID VARCHAR(10),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
)

CREATE TABLE Logs (
    LogID INT PRIMARY KEY IDENTITY(1,1),
    AccountID INT NOT NULL,
    TableName VARCHAR(50) NOT NULL,
    PrimaryKeyValue VARCHAR(MAX) NOT NULL,
    ColumnName VARCHAR(50) NOT NULL,
    OldValue NVARCHAR(MAX),
    NewValue NVARCHAR(MAX),
    ActionType VARCHAR(10) NOT NULL, -- INSERT, UPDATE, DELETE
    LogDate DATETIME NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID)
)
GO

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

CREATE TABLE Permissions (
	PermissionID INT PRIMARY KEY IDENTITY(1,1),
    PermissionName VARCHAR(10) NOT NULL UNIQUE
)

CREATE TABLE RolePermissions (
	RolePermissionID INT PRIMARY KEY IDENTITY(1,1),
	RoleID INT NOT NULL,
	PermissionID INT NOT NULL,
	TableName VARCHAR(50) NOT NULL,
	ArrayColumnName VARCHAR(MAX) NOT NULL,
	Condition NVARCHAR(MAX),
	FOREIGN KEY (RoleID) REFERENCES Roles(RoleID),
	FOREIGN KEY (PermissionID) REFERENCES Permissions(PermissionID)
)

--------------------------------------------------------------------------------
-- Them khoa ngoai
ALTER TABLE Departments
ADD FOREIGN KEY (ManagerID) REFERENCES Employees(EmployeeID)
GO

-------------------------------------------------------------------------------------------------------
-- Tao key
CREATE SYMMETRIC KEY EmployeeSymKey
    WITH ALGORITHM = AES_256
    ENCRYPTION BY PASSWORD = '123456'
GO

-- Tao Permission
INSERT INTO Permissions VALUES ('SELECT')
INSERT INTO Permissions VALUES ('INSERT')
INSERT INTO Permissions VALUES ('UPDATE')
INSERT INTO Permissions VALUES ('DELETE')
GO

-- Tao tai khoan Admin, GiamDoc (Khong co trong bang Employees)
CREATE OR ALTER PROC spInsertAccount1
    @Username               VARCHAR(50)
AS BEGIN
    SET NOCOUNT ON

    DECLARE @DefaultPassword    VARCHAR(50) = '123456'
    DECLARE @Salt               UNIQUEIDENTIFIER
    DECLARE @HashedPassword     VARBINARY(MAX)
    DECLARE @SaltedPassword     VARCHAR(MAX)

    SET @Salt = NEWID()
    SET @SaltedPassword = @DefaultPassword + Cast(@Salt AS VARCHAR(MAX))
    SET @HashedPassword = Cast(HashBytes('SHA2_256', @SaltedPassword) AS VARBINARY(MAX))

    INSERT INTO Accounts
            (Username,  Password,        Salt,  EmployeeId)
    VALUES  (@Username, @HashedPassword, @Salt, null)
END
GO

EXEC spInsertAccount1 Admin123
EXEC spInsertAccount1 GiamDoc123

-- Tao Role cho Admin
INSERT INTO Roles VALUES ('Admin')

-- Cap quyen cho Role Admin
INSERT INTO RolePermissions VALUES (1, 1, 'Departments', 'ALL', NULL)
INSERT INTO RolePermissions VALUES (1, 2, 'Departments', 'ALL', NULL)
INSERT INTO RolePermissions VALUES (1, 3, 'Departments', 'ALL', NULL)
INSERT INTO RolePermissions VALUES (1, 4, 'Departments', 'ALL', NULL)
INSERT INTO RolePermissions VALUES (1, 1, 'Employees', 'ALL', NULL)
INSERT INTO RolePermissions VALUES (1, 2, 'Employees', 'ALL', NULL)
INSERT INTO RolePermissions VALUES (1, 3, 'Employees', 'ALL', NULL)
INSERT INTO RolePermissions VALUES (1, 4, 'Employees', 'ALL', NULL)
INSERT INTO RolePermissions VALUES (1, 1, 'Accounts', 'ALL', NULL)
INSERT INTO RolePermissions VALUES (1, 2, 'Accounts', 'ALL', NULL)
INSERT INTO RolePermissions VALUES (1, 3, 'Accounts', 'ALL', NULL)
INSERT INTO RolePermissions VALUES (1, 4, 'Accounts', 'ALL', NULL)
INSERT INTO RolePermissions VALUES (1, 1, 'Logs', 'ALL', NULL)
INSERT INTO RolePermissions VALUES (1, 2, 'Logs', 'ALL', NULL)
INSERT INTO RolePermissions VALUES (1, 3, 'Logs', 'ALL', NULL)
INSERT INTO RolePermissions VALUES (1, 4, 'Logs', 'ALL', NULL)
INSERT INTO RolePermissions VALUES (1, 1, 'Roles', 'ALL', NULL)
INSERT INTO RolePermissions VALUES (1, 2, 'Roles', 'ALL', NULL)
INSERT INTO RolePermissions VALUES (1, 3, 'Roles', 'ALL', NULL)
INSERT INTO RolePermissions VALUES (1, 4, 'Roles', 'ALL', NULL)
INSERT INTO RolePermissions VALUES (1, 1, 'AccountRoles', 'ALL', NULL)
INSERT INTO RolePermissions VALUES (1, 2, 'AccountRoles', 'ALL', NULL)
INSERT INTO RolePermissions VALUES (1, 3, 'AccountRoles', 'ALL', NULL)
INSERT INTO RolePermissions VALUES (1, 4, 'AccountRoles', 'ALL', NULL)
INSERT INTO RolePermissions VALUES (1, 1, 'RolePermissions', 'ALL', NULL)
INSERT INTO RolePermissions VALUES (1, 2, 'RolePermissions', 'ALL', NULL)
INSERT INTO RolePermissions VALUES (1, 3, 'RolePermissions', 'ALL', NULL)
INSERT INTO RolePermissions VALUES (1, 4, 'RolePermissions', 'ALL', NULL)

-- Gan Role cho tai khoan Admin
INSERT INTO AccountRoles VALUES (1, 1)
GO

--------------------------------------------------------------------------------------------------
-- Tao Role moi
CREATE OR ALTER PROC spInsertRole
	@RoleNameInsert VARCHAR(50),
	@RoleName VARCHAR(50)
AS BEGIN
	SET NOCOUNT ON

    -- Kiem tra xem RoleNameInsert co quyen INSERT tren bang Roles khong
    IF NOT EXISTS (
        SELECT 1
        FROM RolePermissions RP
        JOIN Roles R ON RP.RoleID = R.RoleID
        JOIN Permissions P ON RP.PermissionID = P.PermissionID
        WHERE R.RoleName = @RoleNameInsert
            AND P.PermissionName = 'INSERT'
            AND RP.TableName = 'Roles'
            AND RP.ArrayColumnName = 'ALL'
    )
    BEGIN
        RETURN
    END

    -- Kiem tra xem Role co ton tai
    IF EXISTS (SELECT 1 FROM Roles WHERE RoleName = @RoleName)
    BEGIN
        RETURN
    END

    -- Tao Role moi
    INSERT INTO Roles (RoleName)
    VALUES (@RoleName);
END
GO

EXEC spInsertRole @RoleNameInsert = 'Admin', @RoleName = 'GiamDoc'
EXEC spInsertRole @RoleNameInsert = 'Admin', @RoleName = 'TPNhanSu'
EXEC spInsertRole @RoleNameInsert = 'Admin', @RoleName = 'TruongPhong'
EXEC spInsertRole @RoleNameInsert = 'Admin', @RoleName = 'NVNhanSu'
EXEC spInsertRole @RoleNameInsert = 'Admin', @RoleName = 'NVTaiVu'
EXEC spInsertRole @RoleNameInsert = 'Admin', @RoleName = 'NhanVien'

-- Cap quyen cho Role GiamDoc
-- Viet proc cap quyen






















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





















