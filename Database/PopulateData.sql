USE [PersonnelManagement]
GO

-- truncate data ----------------------------------------------------------------------------------
--TRUNCATE TABLE [dbo].[Account]
--TRUNCATE TABLE [dbo].[Employee]
--TRUNCATE TABLE [dbo].[SalaryLevel]
--TRUNCATE TABLE [dbo].[Department]
--TRUNCATE TABLE [dbo].[JobPosition]
--TRUNCATE TABLE [dbo].[SalaryScale]
EXECUTE sys.sp_MSForEachTable @command1 = 'ALTER TABLE ? NOCHECK CONSTRAINT all'
EXECUTE sys.sp_MSForEachTable @command1 = 'DELETE FROM ?'
EXECUTE sys.sp_MSForEachTable @command1 = 'ALTER TABLE ? WITH CHECK CHECK CONSTRAINT all'
DBCC CHECKIDENT ('[dbo].[Account]', RESEED, 1)
DBCC CHECKIDENT ('[dbo].[SalaryLevel]', RESEED, 1)
DBCC CHECKIDENT ('[dbo].[SalaryScale]', RESEED, 1)
GO

-- procedure to populate data ---------------------------------------------------------------------
CREATE OR ALTER PROCEDURE [dbo].[usp_CreateDefaultAccount]
    @Username               VARCHAR(50),
    @EmployeeId             VARCHAR(10)
AS BEGIN
    SET NOCOUNT ON

    DECLARE @DefaultPassword    VARCHAR(50) = 'P@55w0rd'
    DECLARE @Salt               VARBINARY(Max)
    DECLARE @HashedPassword     VARBINARY(Max)
    DECLARE @SaltedPassword     VARCHAR(Max)

    SET @Salt = crypt_gen_random(32)
    SET @SaltedPassword = @DefaultPassword + Cast(@Salt AS VARCHAR(Max))
    SET @HashedPassword = Cast(HashBytes('SHA2_256', @SaltedPassword) AS VARBINARY(Max))

    INSERT INTO [dbo].[Account]
            ([Username],    [Password],         [Salt], [EmployeeId])
    VALUES  (@Username,     @HashedPassword,    @Salt,  @EmployeeId)
END
GO

INSERT INTO [dbo].[SalaryScale]
        ([Group],   [Name])
VALUES  ('A3.1',    N'Chuyên viên cao cấp nhóm 1')  -- 1
     ,  ('A3.2',    N'Chuyên viên cao cấp nhóm 2')  -- 2
     ,  ('A2.1',    N'Chuyên viên chính nhóm 1')    -- 3
     ,  ('A2.2',    N'Chuyên viên chính nhóm 2')    -- 4
     ,  ('A1',      N'Chuyên viên')                 -- 5
     ,  ('A0',      N'Cán sự')                      -- 6
     ,  ('B',       N'Nhân viên')                   -- 7
     ,  ('C1',      N'Khác nhóm 1')                 -- 8
     ,  ('C2',      N'Khác nhóm 2')                 -- 9
     ,  ('C3',      N'Khác nhóm 3')                 -- 10
GO

INSERT INTO [dbo].[JobPosition]
        ([JobPositionId],   [JobTitle],         [AllowanceCoefficient])
VALUES  ('POS00001',        N'Giám đốc',        3.5)
     ,  ('POS00002',        N'Phó giám đốc',    2.0)
     ,  ('POS00003',        N'Trưởng phòng',    1.2)
     ,  ('POS00004',        N'Nhân viên',       1.05)
GO

INSERT INTO [dbo].[Department]
        ([DepartmentId],    [Name],             [ManagerId])
VALUES  ('DEP00001',        N'Phòng giám đốc',  'EMP00001')
     ,  ('DEP00002',        N'Phòng nhân sự',   'EMP00002')
     ,  ('DEP00003',        N'Phòng tài vụ',    'EMP00003')
GO

INSERT INTO [dbo].[SalaryLevel]
        ([Level],   [Coefficient],  [SalaryScaleId])
VALUES  (N'Bậc 1',  6.20,           1)  -- 1
     ,  (N'Bậc 2',  6.56,           1)
     ,  (N'Bậc 3',  6.92,           1)
     ,  (N'Bậc 4',  7.28,           1)
     ,  (N'Bậc 5',  7.64,           1)
     ,  (N'Bậc 6',  8.00,           1)
     ,  (N'Bậc 1',  5.75,           2)  -- 2
     ,  (N'Bậc 2',  6.11,           2)
     ,  (N'Bậc 3',  6.47,           2)
     ,  (N'Bậc 4',  6.83,           2)
     ,  (N'Bậc 5',  7.19,           2)
     ,  (N'Bậc 6',  7.55,           2)
     ,  (N'Bậc 1',  4.40,           3)  -- 3
     ,  (N'Bậc 2',  4.74,           3)
     ,  (N'Bậc 3',  5.08,           3)
     ,  (N'Bậc 4',  5.42,           3)
     ,  (N'Bậc 5',  5.76,           3)
     ,  (N'Bậc 6',  6.10,           3)
     ,  (N'Bậc 7',  6.44,           3)
     ,  (N'Bậc 8',  6.78,           3)
     ,  (N'Bậc 1',  4.00,           4)  -- 4
     ,  (N'Bậc 2',  4.34,           4)
     ,  (N'Bậc 3',  4.68,           4)
     ,  (N'Bậc 4',  5.02,           4)
     ,  (N'Bậc 5',  5.36,           4)
     ,  (N'Bậc 6',  5.70,           4)
     ,  (N'Bậc 7',  6.04,           4)
     ,  (N'Bậc 8',  6.38,           4)
     ,  (N'Bậc 1',  2.34,           5)  -- 5
     ,  (N'Bậc 2',  2.67,           5)
     ,  (N'Bậc 3',  3.00,           5)
     ,  (N'Bậc 4',  3.33,           5)
     ,  (N'Bậc 5',  3.66,           5)
     ,  (N'Bậc 6',  3.99,           5)
     ,  (N'Bậc 7',  4.32,           5)
     ,  (N'Bậc 8',  4.65,           5)
     ,  (N'Bậc 9',  4.98,           5)
     ,  (N'Bậc 1',  2.10,           6)  -- 6
     ,  (N'Bậc 2',  2.41,           6)
     ,  (N'Bậc 3',  2.72,           6)
     ,  (N'Bậc 4',  3.03,           6)
     ,  (N'Bậc 5',  3.34,           6)
     ,  (N'Bậc 6',  3.65,           6)
     ,  (N'Bậc 7',  3.96,           6)
     ,  (N'Bậc 8',  4.27,           6)
     ,  (N'Bậc 9',  4.58,           6)
     ,  (N'Bậc 10', 4.89,           6)
     ,  (N'Bậc 1',  1.86,           7)  -- 7
     ,  (N'Bậc 2',  2.06,           7)
     ,  (N'Bậc 3',  2.26,           7)
     ,  (N'Bậc 4',  2.46,           7)
     ,  (N'Bậc 5',  2.66,           7)
     ,  (N'Bậc 6',  2.86,           7)
     ,  (N'Bậc 7',  3.06,           7)
     ,  (N'Bậc 8',  3.26,           7)
     ,  (N'Bậc 9',  3.46,           7)
     ,  (N'Bậc 10', 3.66,           7)
     ,  (N'Bậc 11', 3.86,           7)
     ,  (N'Bậc 12', 4.06,           7)
     ,  (N'Bậc 1',  1.65,           8)  -- 8
     ,  (N'Bậc 2',  1.83,           8)
     ,  (N'Bậc 3',  2.01,           8)
     ,  (N'Bậc 4',  2.19,           8)
     ,  (N'Bậc 5',  2.37,           8)
     ,  (N'Bậc 6',  2.55,           8)
     ,  (N'Bậc 7',  2.73,           8)
     ,  (N'Bậc 8',  2.91,           8)
     ,  (N'Bậc 9',  3.09,           8)
     ,  (N'Bậc 10', 3.27,           8)
     ,  (N'Bậc 11', 3.45,           8)
     ,  (N'Bậc 12', 3.63,           8)
     ,  (N'Bậc 1',  1.50,           9)  -- 9
     ,  (N'Bậc 2',  1.68,           9)
     ,  (N'Bậc 3',  1.86,           9)
     ,  (N'Bậc 4',  2.04,           9)
     ,  (N'Bậc 5',  2.22,           9)
     ,  (N'Bậc 6',  2.40,           9)
     ,  (N'Bậc 7',  2.58,           9)
     ,  (N'Bậc 8',  2.76,           9)
     ,  (N'Bậc 9',  2.94,           9)
     ,  (N'Bậc 10', 3.12,           9)
     ,  (N'Bậc 11', 3.30,           9)
     ,  (N'Bậc 12', 3.48,           9)
     ,  (N'Bậc 1',  1.35,           10) -- 10
     ,  (N'Bậc 2',  1.53,           10)
     ,  (N'Bậc 3',  1.71,           10)
     ,  (N'Bậc 4',  1.89,           10)
     ,  (N'Bậc 5',  2.07,           10)
     ,  (N'Bậc 6',  2.25,           10)
     ,  (N'Bậc 7',  2.43,           10)
     ,  (N'Bậc 8',  2.61,           10)
     ,  (N'Bậc 9',  3.79,           10)
     ,  (N'Bậc 10', 3.97,           10)
     ,  (N'Bậc 11', 3.15,           10)
     ,  (N'Bậc 12', 3.33,           10)
GO

-- giám đốc -------------------------------------
EXECUTE [dbo].[usp_InsertEmployee]
    @EmployeeId     = 'EMP00001'
  , @Fullname       = N'Trần Tuấn Toàn'
  , @Sex            = 1
  , @DateOfBirth    = '1975-09-21'
  , @PhoneNumber    = '0963187264'
  , @TaxCode        = '5891734895-427'
  , @SalaryLevelId  = 30
  , @JobPositionId  = 'POS00001'
  , @DepartmentId   = 'DEP00001'

-- trưởng phòng ---------------------------------
EXECUTE [dbo].[usp_InsertEmployee]
    @EmployeeId     = 'EMP00002'
  , @Fullname       = N'Phan Tuấn Tài'
  , @Sex            = 1
  , @DateOfBirth    = '1990-03-21'
  , @PhoneNumber    = '0264837482'
  , @TaxCode        = '6378162539'
  , @SalaryLevelId  = 30
  , @JobPositionId  = 'POS00003'
  , @DepartmentId   = 'DEP00002'

EXECUTE [dbo].[usp_InsertEmployee]
    @EmployeeId     = 'EMP00003'
  , @Fullname       = N'Trần Thị Ngọc Châu'
  , @Sex            = 0
  , @DateOfBirth    = '1985-09-01'
  , @PhoneNumber    = '0752358287'
  , @TaxCode        = '4923874923-853'
  , @SalaryLevelId  = 19
  , @JobPositionId  = 'POS00003'
  , @DepartmentId   = 'DEP00003'

-- nhân viên ---------------------------------
-- phòng nhân sự
EXECUTE [dbo].[usp_InsertEmployee]
    @EmployeeId     = 'EMP00004'
  , @Fullname       = N'Trần Anh Tuấn'
  , @Sex            = 1
  , @DateOfBirth    = '1995-05-19'
  , @PhoneNumber    = '0480399240'
  , @TaxCode        = '1923157862-873'
  , @SalaryLevelId  = 49
  , @JobPositionId  = 'POS00004'
  , @DepartmentId   = 'DEP00002'

EXECUTE [dbo].[usp_InsertEmployee]
    @EmployeeId     = 'EMP00005'
  , @Fullname       = N'Trần Đình Vũ'
  , @Sex            = 1
  , @DateOfBirth    = '1990-03-15'
  , @PhoneNumber    = '0234716538'
  , @TaxCode        = '9257390619-759'
  , @SalaryLevelId  = 48
  , @JobPositionId  = 'POS00004'
  , @DepartmentId   = 'DEP00002'

EXECUTE [dbo].[usp_InsertEmployee]
    @EmployeeId     = 'EMP00006'
  , @Fullname       = N'Trương Mai Anh'
  , @Sex            = 0
  , @DateOfBirth    = '1980-05-19'
  , @PhoneNumber    = '0952387759'
  , @TaxCode        = '5792378571'
  , @SalaryLevelId  = 55
  , @JobPositionId  = 'POS00004'
  , @DepartmentId   = 'DEP00002'

EXECUTE [dbo].[usp_InsertEmployee]
    @EmployeeId     = 'EMP00007'
  , @Fullname       = N'Vương Trắc'
  , @Sex            = 0
  , @DateOfBirth    = '1987-01-17'
  , @PhoneNumber    = '0480399240'
  , @TaxCode        = '8502935028'
  , @SalaryLevelId  = 52
  , @JobPositionId  = 'POS00004'
  , @DepartmentId   = 'DEP00002'

-- phòng tài vụ
EXECUTE [dbo].[usp_InsertEmployee]
    @EmployeeId     = 'EMP00008'
  , @Fullname       = N'Phan Ngô Ngọc Lam'
  , @Sex            = 0
  , @DateOfBirth    = '2000-04-01'
  , @PhoneNumber    = '0157863874'
  , @TaxCode        = '1952638756-298'
  , @SalaryLevelId  = 48
  , @JobPositionId  = 'POS00004'
  , @DepartmentId   = 'DEP00003'

EXECUTE [dbo].[usp_InsertEmployee]
    @EmployeeId     = 'EMP00009'
  , @Fullname       = N'Huỳnh Vũ'
  , @Sex            = 1
  , @DateOfBirth    = '1999-07-28'
  , @PhoneNumber    = '0691871351'
  , @TaxCode        = '6528735682-523'
  , @SalaryLevelId  = 50
  , @JobPositionId  = 'POS00004'
  , @DepartmentId   = 'DEP00003'

EXECUTE [dbo].[usp_InsertEmployee]
    @EmployeeId     = 'EMP00010'
  , @Fullname       = N'Tố Huỳnh Nga'
  , @Sex            = 0
  , @DateOfBirth    = '1982-07-18'
  , @PhoneNumber    = '0458237568'
  , @TaxCode        = '9523847598'
  , @SalaryLevelId  = 57
  , @JobPositionId  = 'POS00004'
  , @DepartmentId   = 'DEP00003'

EXECUTE [dbo].[usp_InsertEmployee]
    @EmployeeId     = 'EMP00011'
  , @Fullname       = N'Phạm Tuấn Phong'
  , @Sex            = 1
  , @DateOfBirth    = '1999-08-22'
  , @PhoneNumber    = '0593487298'
  , @TaxCode        = '2984672947'
  , @SalaryLevelId  = 48
  , @JobPositionId  = 'POS00004'
  , @DepartmentId   = 'DEP00003'
GO

EXECUTE [dbo].[usp_CreateDefaultAccount] @Username = 'tranvantoan',     @EmployeeId = 'EMP00001'
EXECUTE [dbo].[usp_CreateDefaultAccount] @Username = 'phantuantai',     @EmployeeId = 'EMP00002'
EXECUTE [dbo].[usp_CreateDefaultAccount] @Username = 'tranngocchau',    @EmployeeId = 'EMP00003'
EXECUTE [dbo].[usp_CreateDefaultAccount] @Username = 'trananhtuan',     @EmployeeId = 'EMP00004'
EXECUTE [dbo].[usp_CreateDefaultAccount] @Username = 'trandinhvu',      @EmployeeId = 'EMP00005'
EXECUTE [dbo].[usp_CreateDefaultAccount] @Username = 'truongmaianh',    @EmployeeId = 'EMP00006'
EXECUTE [dbo].[usp_CreateDefaultAccount] @Username = 'vuongtrac',       @EmployeeId = 'EMP00007'
EXECUTE [dbo].[usp_CreateDefaultAccount] @Username = 'phanngongoclam',  @EmployeeId = 'EMP00008'
EXECUTE [dbo].[usp_CreateDefaultAccount] @Username = 'huynhvu',         @EmployeeId = 'EMP00009'
EXECUTE [dbo].[usp_CreateDefaultAccount] @Username = 'tohuynhnga',      @EmployeeId = 'EMP00010'
EXECUTE [dbo].[usp_CreateDefaultAccount] @Username = 'phamtuanphong',   @EmployeeId = 'EMP00011'

-- drop unnecessary procedures --------------------------------------------------------------------
DROP PROCEDURE [dbo].[usp_CreateDefaultAccount]

---------------------------------------------------------------------------------------------------
--SELECT [SalaryLevel].[SalaryLevelId]
--     , [SalaryLevel].[Level]
--     , [SalaryLevel].[Coefficient]
--     , [SalaryScale].[Group]
--     , [SalaryScale].[Name]
--FROM [dbo].[SalaryScale]
--INNER JOIN [dbo].[SalaryLevel]
--        ON [dbo].[SalaryScale].[SalaryScaleId] = [dbo].[SalaryLevel].[SalaryScaleId]
--WHERE [SalaryScale].[Group] = 'B'

-- DELETE FROM Employee
-- SELECT * FROM Employee

-- DELETE FROM Account
-- SELECT * FROM Account
-- GO

--SELECT * FROM SalaryScale
--SELECT * FROM SalaryLevel
--GO

--OPEN SYMMETRIC KEY SalaryLevelSymKey DECRYPTION BY PASSWORD = 'W34kP4ssw0rd@'
--DECLARE @Temp           VARBINARY(Max) = EncryptByKey(key_guid('SalaryLevelSymKey'), Cast(6.2 AS NVARCHAR(Max)))
--DECLARE @EncryptedTemp  NVARCHAR(Max)  = Cast(DecryptByKey(@Temp) AS NVARCHAR(Max))
--SELECT @Temp, @EncryptedTemp
--CLOSE SYMMETRIC KEY SalaryLevelSymKey
--GO

-- DECLARE @Temp VARBINARY(Max) = (SELECT [dbo].[Employee].[TaxCode] FROM [dbo].[Employee] WHERE [dbo].[Employee].[EmployeeId] = 'EMP00002')
-- SELECT Cast(@Temp AS VARCHAR(Max))
-- GO

---------------------------------------------------------------------------------------------------
-- DECLARE @TaxCode VARBINARY(Max) = (SELECT TaxCode FROM Employee WHERE EmployeeId = 'EMP00001')

-- OPEN SYMMETRIC KEY EmployeeSymKey DECRYPTION BY PASSWORD = 'W34kP4ssw0rd@'
-- DECLARE @DecryptedTaxCode VARBINARY(Max) = DecryptByKey(@TaxCode)
-- CLOSE SYMMETRIC KEY EmployeeSymKey

-- SELECT Cast(@DecryptedTaxCode AS VARCHAR(Max))

---------------------------------------------------------------------------------------------------
--SELECT * FROM sys.symmetric_keys
--GO
