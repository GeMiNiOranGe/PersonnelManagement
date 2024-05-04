USE [PersonnelManagement]
GO

-- for employee -----------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE [dbo].[usp_InsertEmployee]
    @EmployeeId     VARCHAR(10),
    @Fullname       NVARCHAR(150),
    @Sex            BIT             = NULL, -- 1 is male, 0 is female
    @DateOfBirth    DATE            = NULL,
    @PhoneNumber    VARCHAR(10)     = NULL,
    @TaxCode        VARCHAR(14)     = NULL,
    @SalaryLevelId  INT,
    @JobPositionId  VARCHAR(10),
    @DepartmentId   VARCHAR(10)
AS BEGIN
    DECLARE @EncryptedTaxCode VARBINARY(Max)

    OPEN SYMMETRIC KEY [EmployeeSymKey] DECRYPTION BY PASSWORD = 'W34kP4ssw0rd@'
    SET @EncryptedTaxCode = EncryptByKey(key_guid('EmployeeSymKey'), @TaxCode)
    CLOSE SYMMETRIC KEY [EmployeeSymKey]

    INSERT INTO [dbo].[Employee]
            ([EmployeeId],  [Fullname], [Sex],  [DateOfBirth],  [PhoneNumber],  [TaxCode],          [SalaryLevelId],    [JobPositionId],    [DepartmentId])
    VALUES  (@EmployeeId,   @Fullname,  @Sex,   @DateOfBirth,   @PhoneNumber,   @EncryptedTaxCode,  @SalaryLevelId,     @JobPositionId,     @DepartmentId)
END
GO

-- for account ------------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE [dbo].[usp_GetAccountDetails]
    @AccountName    VARCHAR(50)
AS BEGIN
    SET NOCOUNT ON

    SELECT [AccountId]
         , [Username]
         , [Password]
         , [Salt]
         , [EmployeeId]
    FROM [dbo].[Account]
    WHERE @AccountName IN ([Account].[Username], [Account].[EmployeeId])
END
GO

CREATE OR ALTER PROCEDURE [dbo].[usp_InsertAccount]
    @Username       VARCHAR(50),
    @HashedPassword VARBINARY(Max),
    @Salt           VARBINARY(Max),
    @EmployeeId     VARCHAR(10)
AS BEGIN
    INSERT INTO [dbo].[Account]
            ([Username],    [Password],         [Salt], [EmployeeId])
    VALUES  (@Username,     @HashedPassword,    @Salt,  @EmployeeId)
END
GO