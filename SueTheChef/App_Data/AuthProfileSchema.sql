/*
  Optional: only if your CUSTOMERS table does not already have a Password column.
  Team schema: CustomerID, FirstName, LastName, Email, Phone, VehicleInfo, Password.
*/
IF COL_LENGTH(N'dbo.CUSTOMERS', N'Password') IS NULL
    ALTER TABLE dbo.CUSTOMERS ADD [Password] NVARCHAR(200) NULL;

PRINT N'CUSTOMERS.[Password] column is present.';
