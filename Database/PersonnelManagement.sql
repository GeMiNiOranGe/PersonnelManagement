CREATE DATABASE PersonnelManagement
GO

USE PersonnelManagement
GO

--------------------------------------------------------------------------------------------------
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
	Name VARCHAR(50), -- Ten table, view, sp
	ColumnName VARCHAR(MAX), -- 
	FOREIGN KEY (RoleID) REFERENCES Roles(RoleID),
	FOREIGN KEY (PermissionID) REFERENCES Permissions(PermissionID)
)
GO

------------------------------------------------------------------------------------------------------
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

-- Ham tang DepartmentID
CREATE OR ALTER FUNCTION setDepartmentID()
RETURNS VARCHAR(10)
AS
BEGIN
    DECLARE @MaxDepartmentID VARCHAR(10)
    DECLARE @NewDepartmentID VARCHAR(10)
    
    SELECT @MaxDepartmentID = MAX(DepartmentID) FROM Departments;
    
    SET @NewDepartmentID = CASE
                            WHEN @MaxDepartmentID IS NULL THEN 'DEP00001'
                            ELSE 'DEP' + RIGHT('00000' + CAST(CAST(SUBSTRING(@MaxDepartmentID, 4, LEN(@MaxDepartmentID)) AS INT) + 1 AS VARCHAR(8)), 5)
                         END
    
    RETURN @NewDepartmentID
END
GO

INSERT INTO Departments VALUES (dbo.setDepartmentID(), N'Nhân sự', null)
INSERT INTO Departments VALUES (dbo.setDepartmentID(), N'Tài vụ', null)
INSERT INTO Departments VALUES (dbo.setDepartmentID(), N'Thiết kế', null)
GO

-- Ham tang EmployeeID
CREATE OR ALTER FUNCTION setEmployeeID()
RETURNS VARCHAR(10)
AS
BEGIN
    DECLARE @MaxEmployeeID VARCHAR(10)
    DECLARE @NewEmployeeID VARCHAR(10)
    
    SELECT @MaxEmployeeID = MAX(EmployeeID) FROM Employees;
    
    SET @NewEmployeeID = CASE
                            WHEN @MaxEmployeeID IS NULL THEN 'EMP00001'
                            ELSE 'EMP' + RIGHT('00000' + CAST(CAST(SUBSTRING(@MaxEmployeeID, 4, LEN(@MaxEmployeeID)) AS INT) + 1 AS VARCHAR(8)), 5)
                         END
    
    RETURN @NewEmployeeID
END
GO

-- SP them Full cac cot Nhan vien
CREATE OR ALTER PROCEDURE spInsertEmployeeFull
    @EmployeeId     VARCHAR(10),
    @Fullname       NVARCHAR(150),
    @Gender         BIT             = NULL, 
    @DateOfBirth    DATE            = NULL,
    @PhoneNumber    VARCHAR(10)     = NULL,
	@Salary         VARCHAR(15),
    @Allowance      VARCHAR(15),
    @TaxCode        VARCHAR(14)     = NULL,
    @DepartmentId   VARCHAR(10)
AS BEGIN
	IF @EmployeeId IS NULL
    SET @EmployeeId = dbo.setEmployeeID()

    DECLARE @EncryptedSalary VARBINARY(MAX)
	DECLARE @EncryptedAllowance VARBINARY(MAX)

    OPEN SYMMETRIC KEY EmployeeSymKey DECRYPTION BY PASSWORD = '123456'
    SET @EncryptedSalary = EncryptByKey(key_guid('EmployeeSymKey'), @Salary)
	SET @EncryptedAllowance = EncryptByKey(key_guid('EmployeeSymKey'), @Allowance)
    CLOSE SYMMETRIC KEY EmployeeSymKey

    INSERT INTO Employees
            (EmployeeId,  Fullname,  Gender,  DateOfBirth,  PhoneNumber,  Salary,           Allowance,           TaxCode,  DepartmentId)
    VALUES  (@EmployeeId, @Fullname, @Gender, @DateOfBirth, @PhoneNumber, @EncryptedSalary, @EncryptedAllowance, @TaxCode, @DepartmentId)
END
GO

-- Truong phong Nhan su
EXECUTE spInsertEmployeeFull
    @EmployeeId     = NULL
  , @Fullname       = N'Trần Tuấn Toàn'
  , @Gender         = 0
  , @DateOfBirth    = '19750921'
  , @PhoneNumber    = '0963187264'
  , @Salary         = '12000000'
  , @Allowance      = '800000'
  , @TaxCode        = '5891734895-427'
  , @DepartmentId   = 'DEP00001'

-- Truong phong Tai vu
EXECUTE spInsertEmployeeFull
    @EmployeeId     = NULL
  , @Fullname       = N'Phan Tuấn Tài'
  , @Gender         = 0
  , @DateOfBirth    = '19900321'
  , @PhoneNumber    = '0264837482'
  , @Salary         = '11000000'
  , @Allowance      = '700000'
  , @TaxCode        = '6378162539-953'
  , @DepartmentId   = 'DEP00002'

-- Truong phong Thiet ke
EXECUTE spInsertEmployeeFull
    @EmployeeId     = NULL
  , @Fullname       = N'Trần Thị Ngọc Châu'
  , @Gender         = 1
  , @DateOfBirth    = '19850901'
  , @PhoneNumber    = '0752358287'
  , @Salary         = '10000000'
  , @Allowance      = '600000'
  , @TaxCode        = '4923874923-853'
  , @DepartmentId   = 'DEP00003'

-- Nhan vien phong nhan su
EXECUTE spInsertEmployeeFull
    @EmployeeId     = NULL
  , @Fullname       = N'Trần Anh Tuấn'
  , @Gender         = 0
  , @DateOfBirth    = '19950519'
  , @PhoneNumber    = '0480399240'
  , @Salary         = '9000000'
  , @Allowance      = '500000'
  , @TaxCode        = '1923157862-873'
  , @DepartmentId   = 'DEP00001'

-- Nhan vien phong Tai vu
EXECUTE spInsertEmployeeFull
    @EmployeeId     = NULL
  , @Fullname       = N'Trần Đình Vũ'
  , @Gender         = 0
  , @DateOfBirth    = '19900315'
  , @PhoneNumber    = '0234716538'
  , @Salary         = '8000000'
  , @Allowance      = '400000'
  , @TaxCode        = '9257390619-759'
  , @DepartmentId   = 'DEP00002'

-- Nhan vien phong Thiet ke
EXECUTE spInsertEmployeeFull
    @EmployeeId     = NULL
  , @Fullname       = N'Trương Mai Anh'
  , @Gender         = 1
  , @DateOfBirth    = '19800519'
  , @PhoneNumber    = '0952387759'
  , @Salary         = '7000000'
  , @Allowance      = '400000'
  , @TaxCode        = '5792378571-371'
  , @DepartmentId   = 'DEP00003'
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

EXEC spInsertAccount1 'Admin123'
EXEC spInsertAccount1 'GiamDoc123'
GO

-- Tao tai khoan Nhan vien
CREATE OR ALTER PROC spInsertAccount2
	@EmployeeID             VARCHAR(10),
    @Username               VARCHAR(50)
AS BEGIN
    SET NOCOUNT ON

    DECLARE @DefaultPassword    VARCHAR(50) = @EmployeeID
    DECLARE @Salt               UNIQUEIDENTIFIER
    DECLARE @HashedPassword     VARBINARY(MAX)
    DECLARE @SaltedPassword     VARCHAR(MAX)

    SET @Salt = NEWID()
    SET @SaltedPassword = @DefaultPassword + Cast(@Salt AS VARCHAR(MAX))
    SET @HashedPassword = Cast(HashBytes('SHA2_256', @SaltedPassword) AS VARBINARY(MAX))

    INSERT INTO Accounts
            (Username,  Password,        Salt,  EmployeeId)
    VALUES  (@Username, @HashedPassword, @Salt, @EmployeeID)
END
GO

EXEC spInsertAccount2 'EMP00001', 'EMP00001'
EXEC spInsertAccount2 'EMP00002', 'EMP00002'
EXEC spInsertAccount2 'EMP00003', 'EMP00003'
EXEC spInsertAccount2 'EMP00004', 'EMP00004'
EXEC spInsertAccount2 'EMP00005', 'EMP00005'
EXEC spInsertAccount2 'EMP00006', 'EMP00006'
GO

INSERT INTO Roles VALUES ('Admin')
INSERT INTO Roles VALUES ('GiamDoc')
INSERT INTO Roles VALUES ('TPNhanSu')
INSERT INTO Roles VALUES ('TruongPhong')
INSERT INTO Roles VALUES ('NVNhanSu')
INSERT INTO Roles VALUES ('NVTaiVu')
INSERT INTO Roles VALUES ('NhanVien')

INSERT INTO AccountRoles VALUES (1, 1)
INSERT INTO AccountRoles VALUES (2, 2)
INSERT INTO AccountRoles VALUES (3, 3)
INSERT INTO AccountRoles VALUES (4, 4)
INSERT INTO AccountRoles VALUES (5, 4)
INSERT INTO AccountRoles VALUES (6, 5)
INSERT INTO AccountRoles VALUES (7, 6)
INSERT INTO AccountRoles VALUES (8, 7)

INSERT INTO Permissions VALUES ('SELECT')
INSERT INTO Permissions VALUES ('INSERT')
INSERT INTO Permissions VALUES ('UPDATE')
INSERT INTO Permissions VALUES ('DELETE')

-- Cap quyen cho Admin
INSERT INTO RolePermissions (RoleID, PermissionID, Name, ColumnName)
SELECT 1, 1, 'Employees', LEFT(
                                (
                                    SELECT STRING_AGG(COLUMN_NAME + ',', '')
                                    FROM INFORMATION_SCHEMA.COLUMNS
                                    WHERE TABLE_NAME = 'Employees'
                                ),
                                LEN((
                                    SELECT STRING_AGG(COLUMN_NAME + ',', '')
                                    FROM INFORMATION_SCHEMA.COLUMNS
                                    WHERE TABLE_NAME = 'Employees'
                                )) - 1
                            )
INSERT INTO RolePermissions (RoleID, PermissionID, Name, ColumnName)
SELECT 1, 2, 'Employees', LEFT(
                                (
                                    SELECT STRING_AGG(COLUMN_NAME + ',', '')
                                    FROM INFORMATION_SCHEMA.COLUMNS
                                    WHERE TABLE_NAME = 'Employees'
                                ),
                                LEN((
                                    SELECT STRING_AGG(COLUMN_NAME + ',', '')
                                    FROM INFORMATION_SCHEMA.COLUMNS
                                    WHERE TABLE_NAME = 'Employees'
                                )) - 1
                            )
INSERT INTO RolePermissions (RoleID, PermissionID, Name, ColumnName)
SELECT 1, 3, 'Employees', LEFT(
                                (
                                    SELECT STRING_AGG(COLUMN_NAME + ',', '')
                                    FROM INFORMATION_SCHEMA.COLUMNS
                                    WHERE TABLE_NAME = 'Employees'
                                ),
                                LEN((
                                    SELECT STRING_AGG(COLUMN_NAME + ',', '')
                                    FROM INFORMATION_SCHEMA.COLUMNS
                                    WHERE TABLE_NAME = 'Employees'
                                )) - 1
                            )
INSERT INTO RolePermissions VALUES (1, 4, 'Employees', null)

-- Cap quyen cho GiamDoc
INSERT INTO RolePermissions VALUES (2, 1, 'vPresident', null)
INSERT INTO RolePermissions (RoleID, PermissionID, Name, ColumnName)
SELECT 2, 3, 'vPresident', LEFT(
                                (
                                    SELECT STRING_AGG(
                                        COALESCE(
                                            CASE WHEN COLUMN_NAME IN ('Salary', 'Allowance')
                                            THEN COLUMN_NAME + ','
                                            END, 'NULL,'
                                        ),
                                        ''
                                    )
                                    FROM INFORMATION_SCHEMA.COLUMNS
                                    WHERE TABLE_NAME = 'Employees'
                                ),
                                LEN((
                                    SELECT STRING_AGG(
                                        COALESCE(
                                            CASE WHEN COLUMN_NAME IN ('Salary', 'Allowance')
                                            THEN COLUMN_NAME + ','
                                            END, 'NULL,'
                                        ),
                                        ''
                                    )
                                    FROM INFORMATION_SCHEMA.COLUMNS
                                    WHERE TABLE_NAME = 'Employees'
                                )) - 1
                            )

-- Cap quyen cho TPNhanSu
INSERT INTO RolePermissions VALUES (3, 1, 'vManagerPersonnel', null)
INSERT INTO RolePermissions (RoleID, PermissionID, Name, ColumnName)
SELECT 3, 3, 'vManagerPersonnel', LEFT(
                                        (
                                            SELECT STRING_AGG(
                                                COALESCE(
                                                    CASE WHEN COLUMN_NAME NOT IN ('Salary', 'Allowance')
                                                    THEN COLUMN_NAME + ','
                                                    END, 'NULL,'
                                                ),
                                                ''
                                            )
                                            FROM INFORMATION_SCHEMA.COLUMNS
                                            WHERE TABLE_NAME = 'Employees'
                                        ),
                                        LEN((
                                            SELECT STRING_AGG(
                                                COALESCE(
                                                    CASE WHEN COLUMN_NAME NOT IN ('Salary', 'Allowance')
                                                    THEN COLUMN_NAME + ','
                                                    END, 'NULL,'
                                                ),
                                                ''
                                            )
                                            FROM INFORMATION_SCHEMA.COLUMNS
                                            WHERE TABLE_NAME = 'Employees'
                                        )) - 1
                                    )

-- Cap quyen cho TruongPhong
INSERT INTO RolePermissions VALUES (4, 1, 'vManager', null)

-- Cap quyen cho NVNhanSu
INSERT INTO RolePermissions VALUES (5, 1, 'vEmployeePersonnel', null)
INSERT INTO RolePermissions VALUES (5, 2, 'vEmployeePersonnel', null)
INSERT INTO RolePermissions (RoleID, PermissionID, Name, ColumnName)
SELECT 3, 3, 'vManagerPersonnel', LEFT(
                                        (
                                            SELECT STRING_AGG(
                                                COALESCE(
                                                    CASE WHEN COLUMN_NAME NOT IN ('Salary', 'Allowance')
                                                    THEN COLUMN_NAME + ','
                                                    END, 'NULL,'
                                                ),
                                                ''
                                            )
                                            FROM INFORMATION_SCHEMA.COLUMNS
                                            WHERE TABLE_NAME = 'Employees'
                                        ),
                                        LEN((
                                            SELECT STRING_AGG(
                                                COALESCE(
                                                    CASE WHEN COLUMN_NAME NOT IN ('Salary', 'Allowance')
                                                    THEN COLUMN_NAME + ','
                                                    END, 'NULL,'
                                                ),
                                                ''
                                            )
                                            FROM INFORMATION_SCHEMA.COLUMNS
                                            WHERE TABLE_NAME = 'Employees'
                                        )) - 1
                                    )

-- Cap quyen cho NVTaiVu
INSERT INTO RolePermissions VALUES (6, 1, 'vEmployeeFinancial', null)

-- Cap quyen cho NhanVien
INSERT INTO RolePermissions VALUES (7, 1, 'vEmployees', null)
GO

-- Select bang Employees
CREATE OR ALTER PROC spSelectEmployees
    @RoleID INT
AS
BEGIN
    BEGIN TRY
        OPEN SYMMETRIC KEY EmployeeSymKey
        DECRYPTION BY PASSWORD='123456'
    END TRY
    BEGIN CATCH
        PRINT N'Error opening symmetric key: ' + ERROR_MESSAGE()
        RETURN
    END CATCH

    IF NOT EXISTS (SELECT * FROM RolePermissions WHERE PermissionID = 1 AND RoleID = @RoleID)
    BEGIN
        RETURN
    END

    DECLARE @ViewName VARCHAR(50)
    DECLARE @AccountID INT
    DECLARE @SQL NVARCHAR(MAX)

    SELECT @ViewName = Name
    FROM RolePermissions
    WHERE RoleID = @RoleID

    SELECT @AccountID = AccountID
    FROM AccountRoles
    WHERE RoleID = @RoleID

    -- View for Employees
    IF @ViewName = 'vEmployees'
    BEGIN
        IF EXISTS (SELECT 1 FROM sys.views WHERE Name = 'vEmployees')
        BEGIN
            EXEC('DROP VIEW vEmployees')
        END

        SET @SQL = '
        CREATE VIEW vEmployees AS
        SELECT EmployeeID, FullName, Gender, DateOfBirth, PhoneNumber, TaxCode, DepartmentID
        FROM Employees 
        WHERE DepartmentID IN (SELECT DepartmentID 
                               FROM Employees AS E
                               JOIN Accounts AS A ON E.EmployeeID = A.EmployeeID
                               WHERE A.AccountID = ' + CAST(@AccountID AS NVARCHAR) + ')'

        EXEC sp_executesql @SQL

        SELECT * FROM vEmployees
    END

    -- View for Manager (except HR manager)
    ELSE IF @ViewName = 'vManager'
    BEGIN
        IF EXISTS (SELECT 1 FROM sys.views WHERE Name = 'vManager')
        BEGIN
            EXEC('DROP VIEW vManager')
        END

        SET @SQL = '
        CREATE VIEW vManager AS
        SELECT EmployeeID, FullName, Gender, DateOfBirth, PhoneNumber,
               CONVERT(VARCHAR(MAX), DECRYPTBYKEY(Salary)) AS Salary,
               CONVERT(VARCHAR(MAX), DECRYPTBYKEY(Allowance)) AS Allowance,
               TaxCode, DepartmentID
        FROM Employees
        WHERE DepartmentID IN (SELECT DepartmentID 
                               FROM Employees AS E 
                               JOIN Accounts AS A ON E.EmployeeID = A.EmployeeID 
                               WHERE A.AccountID = ' + CAST(@AccountID AS NVARCHAR) + ')'

        EXEC sp_executesql @SQL

        SELECT * FROM vManager
    END

    -- View for HR Employees
    ELSE IF @ViewName = 'vEmployeePersonnel'
    BEGIN
        IF EXISTS (SELECT 1 FROM sys.views WHERE Name = 'vEmployeePersonnel')
        BEGIN
            EXEC('DROP VIEW vEmployeePersonnel')
        END

        SET @SQL = '
        CREATE VIEW vEmployeePersonnel AS
        SELECT EmployeeID, FullName, Gender, DateOfBirth, PhoneNumber, TaxCode, DepartmentID
        FROM Employees
        WHERE DepartmentID NOT IN (SELECT DepartmentID 
                                   FROM Employees AS E 
                                   JOIN Accounts AS A ON E.EmployeeID = A.EmployeeID 
                                   WHERE A.AccountID = ' + CAST(@AccountID AS NVARCHAR) + ')'

        EXEC sp_executesql @SQL

        SELECT * FROM vEmployeePersonnel
    END

    -- View for HR Manager
    ELSE IF @ViewName = 'vManagerPersonnel'
    BEGIN
        IF EXISTS (SELECT 1 FROM sys.views WHERE Name = 'vManagerPersonnel')
        BEGIN
            EXEC('DROP VIEW vManagerPersonnel')
        END

        SET @SQL = '
        CREATE VIEW vManagerPersonnel AS
        SELECT EmployeeID, FullName, Gender, DateOfBirth, PhoneNumber, TaxCode, DepartmentID
        FROM Employees'

        EXEC sp_executesql @SQL

        SELECT * FROM vManagerPersonnel
    END

    -- View for Financial Employees
    ELSE IF @ViewName = 'vEmployeeFinancial'
    BEGIN
        IF EXISTS (SELECT 1 FROM sys.views WHERE Name = 'vEmployeeFinancial')
        BEGIN
            EXEC('DROP VIEW vEmployeeFinancial')
        END

        SET @SQL = '
        CREATE VIEW vEmployeeFinancial AS
        SELECT EmployeeID, FullName, Gender, DateOfBirth, PhoneNumber, 
               CONVERT(VARCHAR(MAX), DECRYPTBYKEY(Salary)) AS Salary, 
               CONVERT(VARCHAR(MAX), DECRYPTBYKEY(Allowance)) AS Allowance,
               TaxCode, DepartmentID
        FROM Employees
        WHERE DepartmentID IN (SELECT DepartmentID 
                               FROM Employees AS E 
                               JOIN Accounts AS A ON E.EmployeeID = A.EmployeeID 
                               WHERE A.AccountID = ' + CAST(@AccountID AS NVARCHAR) + ')
        UNION
        SELECT EmployeeID, NULL AS FullName, NULL AS Gender, NULL AS DateOfBirth, 
               NULL AS PhoneNumber,  CONVERT(VARCHAR(MAX), DECRYPTBYKEY(Salary)) AS Salary,
               CONVERT(VARCHAR(MAX), DECRYPTBYKEY(Allowance)) AS Allowance, TaxCode, NULL AS DepartmentID
        FROM Employees
        WHERE DepartmentID NOT IN (SELECT DepartmentID 
                                   FROM Employees AS E 
                                   JOIN Accounts AS A ON E.EmployeeID = A.EmployeeID 
                                   WHERE A.AccountID = ' + CAST(@AccountID AS NVARCHAR) + ')'

        EXEC sp_executesql @SQL

        SELECT * FROM vEmployeeFinancial
    END

    -- View for President
    ELSE IF @ViewName = 'vPresident'
    BEGIN
        IF EXISTS (SELECT 1 FROM sys.views WHERE Name = 'vPresident')
        BEGIN
            EXEC('DROP VIEW vPresident')
        END

        SET @SQL = '
        CREATE VIEW vPresident AS
        SELECT EmployeeID, FullName, Gender, DateOfBirth, PhoneNumber,
               CONVERT(VARCHAR(MAX), DECRYPTBYKEY(Salary)) AS Salary,
               CONVERT(VARCHAR(MAX), DECRYPTBYKEY(Allowance)) AS Allowance,
               TaxCode, DepartmentID
        FROM Employees'

        EXEC sp_executesql @SQL

        SELECT * FROM vPresident
    END
    ELSE
    BEGIN
        DECLARE @ColumnName VARCHAR(MAX)
        SELECT @ColumnName = ColumnName
        FROM RolePermissions
        WHERE RoleID = 1
          AND PermissionID = 1

        IF @ColumnName IS NOT NULL
        BEGIN
            -- Create dynamic SQL to select data from Employees with specified columns
            SET @SQL = '
            SELECT ' + @ColumnName + '
            FROM Employees'

            -- Execute dynamic SQL
            EXEC sp_executesql @SQL;
        END
        ELSE
        BEGIN
            PRINT N'Không tìm thấy tên cột.'
        END
    END

    CLOSE SYMMETRIC KEY EmployeeSymKey
END
GO

EXEC spSelectEmployees 7
GO
CREATE OR ALTER PROC spInsertEmployees
    @RoleID INT,
	@ValueList NVARCHAR(MAX)
AS
BEGIN
    -- Kiểm tra quyền của RoleID
    IF NOT EXISTS (SELECT 1 FROM RolePermissions WHERE PermissionID = 2 AND RoleID = @RoleID)
    BEGIN
        PRINT 'OUT'
        RETURN
    END

    -- Lấy tên các cột từ view
	--DECLARE @ValueList NVARCHAR(MAX) = N'Nguyễn Cát Tường,1,20031119,0234671652,70000000,123456789,null'
    DECLARE @columnList NVARCHAR(MAX)
    SELECT @columnList = COALESCE(@columnList + ', ', '') + COLUMN_NAME
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'vEmployeePersonnel'

    -- Tạo câu lệnh INSERT
    DECLARE @insertQuery NVARCHAR(MAX)
    SET @insertQuery = 'INSERT INTO Employees (' + @columnList + ') VALUES '

    -- Phân tách chuỗi dữ liệu và ghép vào câu lệnh INSERT
    SET @insertQuery = @insertQuery + '('
	--print @insertQuery
-- Lặp qua từng giá trị trong chuỗi dữ liệu
DECLARE @startIndex INT = 1
DECLARE @endIndex INT = CHARINDEX(',', @ValueList, @startIndex)
WHILE @endIndex > 0
BEGIN
    DECLARE @value NVARCHAR(MAX) = SUBSTRING(@ValueList, @startIndex, @endIndex - @startIndex)

    -- Mã hóa giá trị của cột salary và allowance
    IF @columnList LIKE '%salary%'
    BEGIN
        IF CHARINDEX('salary', @columnList) > 0
        BEGIN
            SET @value = CONVERT(NVARCHAR(MAX), EncryptByKey(Key_GUID('EmployeeSymKey'), @value))
        END
    END

    IF @columnList LIKE '%allowance%'
    BEGIN
        IF CHARINDEX('allowance', @columnList) > 0
        BEGIN
            SET @value = CONVERT(NVARCHAR(MAX), EncryptByKey(Key_GUID('EmployeeSymKey'), @value))
        END
    END

    -- Thêm giá trị vào chuỗi truy vấn
    SET @insertQuery = @insertQuery + '''' + @value + ''', '

    SET @startIndex = @endIndex + 1
    SET @endIndex = CHARINDEX(',', @ValueList, @startIndex)
END

-- Loại bỏ dấu phẩy cuối cùng
SET @insertQuery = LEFT(@insertQuery, LEN(@insertQuery) - 1)

-- In ra câu truy vấn
PRINT @insertQuery

-- Thực thi câu lệnh INSERT
EXEC sp_executesql @insertQuery




    -- Thực thi câu lệnh INSERT
    EXEC sp_executesql @insertQuery




	DECLARE @ValueList NVARCHAR(MAX) = N'Nguyễn Cát Tường,1,20031119,0234671652,70000000,123456789,null'
DECLARE @columnList NVARCHAR(MAX)

-- Lấy tên các cột từ view
SELECT @columnList = COALESCE(@columnList + ', ', '') + COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'vEmployeePersonnel'

-- Tạo câu lệnh INSERT
DECLARE @insertQuery NVARCHAR(MAX)
SET @insertQuery = 'INSERT INTO Employees (' + @columnList + ') VALUES (dbo.setEmployeeID(), '

-- Thay thế chuỗi "null" bằng NULL
--SET @ValueList = REPLACE(@ValueList, ',null,', ',NULL,')
--SET @ValueList = REPLACE(@ValueList, ',null', ',NULL')

-- Tách các giá trị từ chuỗi @ValueList
DECLARE @ValuesTable TABLE ([Value] NVARCHAR(MAX))
DECLARE @Pos INT
DECLARE @End INT
SET @Pos = 1
WHILE CHARINDEX(',', @ValueList, @Pos) > 0
BEGIN
    SET @End = CHARINDEX(',', @ValueList, @Pos)
    INSERT INTO @ValuesTable ([Value]) VALUES (SUBSTRING(@ValueList, @Pos, @End - @Pos))
    SET @Pos = @End + 1
END
INSERT INTO @ValuesTable ([Value]) VALUES (SUBSTRING(@ValueList, @Pos, LEN(@ValueList) - @Pos + 1))

-- Lấy giá trị từ bảng tạm và thêm vào câu lệnh INSERT
DECLARE @EncryptedValue NVARCHAR(MAX)
SELECT @insertQuery = @insertQuery + 
    CASE 
		WHEN Value = 'null' THEN 'null'
		WHEN Value = 'NULL' THEN 'null'
        WHEN @columnList LIKE 'Salary' AND Value = 'NULL' THEN 'NULL'
        WHEN @columnList LIKE 'Salary' THEN CONVERT(varbinary(max), EncryptByKey(Key_GUID('EmployeeSymKey'), CONVERT(varbinary(max), CAST([Value] AS varchar(MAX)))))
        --WHEN @columnList LIKE 'Allowance' AND Value = 'NULL' THEN 'NULL'
        --WHEN @columnList LIKE 'Allowance' THEN CONVERT(varbinary(max), EncryptByKey(Key_GUID('EmployeeSymKey'), CONVERT(varbinary(max), CAST([Value] AS varchar(MAX)))))
        ELSE 'N''' + Value + ''''
    END + ','
FROM @ValuesTable

-- Loại bỏ dấu phẩy cuối cùng
SET @insertQuery = LEFT(@insertQuery, LEN(@insertQuery) - 1)
SET @insertQuery = @insertQuery + ')'
-- In ra câu truy vấn INSERT hoàn chỉnh
PRINT @insertQuery
EXEC sp_executesql @insertQuery
END
GO


EXEC spInsertEmployees 5, N'Nguyễn Cát Tường,1,20031119,0234671652,70000000,123456789,null'
--EmployeeID, FullName, Gender, DateOfBirth, PhoneNumber, TaxCode, DepartmentID
select * from employees
-- Update bang Employees
GO
CREATE OR ALTER PROCEDURE dbo.usp_UpdateEmployee
    @RoleID     INT,
    @ValueList  NVARCHAR(MAX),
    @EmployeeID VARCHAR(10)
AS BEGIN
    DECLARE @ViewName VARCHAR(50)
    DECLARE @ColumnList NVARCHAR(MAX)

    SELECT @ViewName = Name
    FROM RolePermissions
    WHERE RoleID = @RoleID
    AND PermissionID = 3

    SELECT @ColumnList = ColumnName
    FROM RolePermissions
    WHERE RoleID = @RoleID
    AND PermissionID = 3
    AND Name = @ViewName

    DECLARE @ColumnTable TABLE (Value NVARCHAR(MAX), RowNum INT)
    INSERT INTO @ColumnTable(Value, RowNum)
    SELECT value, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS RowNum
    FROM STRING_SPLIT(@ColumnList, ',')

    DECLARE @ValueTable TABLE (Value NVARCHAR(MAX), RowNum INT)
    INSERT INTO @ValueTable(Value, RowNum)
    SELECT value, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS RowNum
    FROM STRING_SPLIT(@ValueList, ',')

    DELETE VT
    FROM @ValueTable VT
    JOIN @ColumnTable CT ON VT.RowNum + 1 = CT.RowNum
    WHERE CT.Value IS NULL OR CT.Value = 'NULL' OR CT.Value = 'null'

    DELETE FROM @ColumnTable WHERE Value = 'null' OR Value = 'NULL'

    -- Bảng tạm để lưu trữ các câu lệnh UPDATE
    DECLARE @UpdateCommands TABLE (UpdateCommand NVARCHAR(MAX))

    -- Xây dựng các câu lệnh UPDATE động
    DECLARE @EncryptedValue VARBINARY(MAX)
    DECLARE @SQL NVARCHAR(MAX)

    -- Vòng lặp qua các giá trị trong @ColumnTable và @ValueTable để xây dựng câu lệnh UPDATE
    DECLARE @ColumnValue NVARCHAR(MAX)
    DECLARE @Value NVARCHAR(MAX)

    DECLARE UpdateCursor CURSOR FOR
    SELECT CT.Value, VT.Value
    FROM @ColumnTable CT
    JOIN @ValueTable VT ON CT.RowNum = VT.RowNum + 1

    OPEN UpdateCursor
    FETCH NEXT FROM UpdateCursor INTO @ColumnValue, @Value

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Kiểm tra nếu giá trị của cột là 'Salary' hoặc 'Allowance' thì mã hóa giá trị
        IF @ColumnValue = 'Salary' OR @ColumnValue = 'Allowance'
        BEGIN
            IF @Value = 'null' OR @Value = 'NULL'
            BEGIN
                SET @SQL = 'UPDATE Employees SET ' + @ColumnValue + ' = null WHERE EmployeeID = ''' + @EmployeeID + ''''
            END
            ELSE
            BEGIN
                OPEN SYMMETRIC KEY EmployeeSymKey DECRYPTION BY PASSWORD = '123456'
                SET @EncryptedValue = EncryptByKey(key_guid('EmployeeSymKey'), @Value)
                CLOSE SYMMETRIC KEY EmployeeSymKey

                -- Tạo câu lệnh UPDATE với giá trị mã hóa
                SET @SQL = 'UPDATE Employees SET ' + @ColumnValue + ' = @EncryptedValue WHERE EmployeeID = ''' + @EmployeeID + ''''
            END
        END
        ELSE
        BEGIN
            IF @Value = 'null' OR @Value = 'NULL'
            BEGIN
                -- Tạo câu lệnh UPDATE thông thường với giá trị NULL
                SET @SQL = 'UPDATE Employees SET ' + @ColumnValue + ' = null WHERE EmployeeID = ''' + @EmployeeID + ''''
            END
            ELSE
            BEGIN
                -- Tạo câu lệnh UPDATE thông thường
                SET @SQL = 'UPDATE Employees SET ' + @ColumnValue + ' = N''' + @Value + ''' WHERE EmployeeID = ''' + @EmployeeID + ''''
            END
        END
        -- Thực thi câu lệnh
        EXEC sp_executesql @SQL, N'@EncryptedValue VARBINARY(MAX)', @EncryptedValue

        FETCH NEXT FROM UpdateCursor INTO @ColumnValue, @Value
    END

    CLOSE UpdateCursor
    DEALLOCATE UpdateCursor
END
-------------------------------------------------------------------------------------------------------







--------------------------------------------------------------------------------------------------
-- Viết trigger chặn select, insert, update, delete bảng trực tiếp
--------------------------------------------------------------------------------------------------


-- Tao Role moi
CREATE OR ALTER PROC spInsertRole
	@RoleNamePer VARCHAR(50),
	@RoleName VARCHAR(50)
AS BEGIN
	SET NOCOUNT ON

    -- Kiem tra xem RoleNameInsert co quyen INSERT tren bang Roles khong
    EXEC spCheckRolePermissions @RoleNamePer, 'INSERT', 'Roles'

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

EXEC spInsertRole 'Admin', 'GiamDoc'
EXEC spInsertRole 'Admin', 'TPNhanSu'
EXEC spInsertRole 'Admin', 'TruongPhong'
EXEC spInsertRole 'Admin', 'NVNhanSu'
EXEC spInsertRole 'Admin', 'NVTaiVu'
EXEC spInsertRole 'Admin', 'NhanVien'
GO

-- Cap quyen cho Role moi
CREATE OR ALTER PROC spInsertRolePermissions
	@RoleNamePer VARCHAR(50),
	@RoleID INT,
	@PermissionID INT,
	@TableName VARCHAR(50),
	@ArrayColumnName NVARCHAR(MAX)
AS BEGIN
	SET NOCOUNT ON

	EXEC spCheckRolePermissions @RoleNamePer, 'INSERT', 'RolePermissions'

	INSERT INTO RolePermissions (RoleID, PermissionID, TableName, ArrayColumnName)
	VALUES (@RoleID, @PermissionID, @TableName, @ArrayColumnName)
END
GO




















CREATE OR ALTER PROC spLogin
    @USERNAME VARCHAR(50),
    @PASSWORD VARCHAR(50),
    @KETQUA INT OUTPUT,
    @ROLEID INT OUTPUT, -- Thay đổi để xuất RoleID
    @NAME VARCHAR(MAX) OUTPUT -- Thay đổi để xuất danh sách Name
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

        -- Lấy RoleID từ bảng Roles dựa trên RoleId trong bảng AccountRoles
        SELECT @ROLEID = R.RoleId
        FROM Roles R
        INNER JOIN AccountRoles AR ON R.RoleId = AR.RoleId
        INNER JOIN Accounts A ON AR.AccountId = A.AccountID
        WHERE A.[Username] = @USERNAME

        -- Nếu không tìm thấy RoleID tương ứng, gán @ROLEID = NULL hoặc thực hiện các xử lý tùy thuộc vào yêu cầu của bạn
        IF @ROLEID IS NULL
        BEGIN
            SET @NAME = NULL
            RETURN
        END

        -- Lấy các quyền từ bảng RolePermissions dựa trên RoleId và ghép các tên quyền thành một chuỗi
        SELECT @NAME = STRING_AGG(Name, ',')
        FROM RolePermissions
        WHERE RoleID = @ROLEID
    END
    ELSE
    BEGIN
        -- Nếu không khớp, gán kết quả là 0
        SET @KETQUA = 0
    END
END





















