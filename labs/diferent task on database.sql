CREATE DATABASE CurrencyExchange;
GO

USE CurrencyExchange;
GO

-- Create 1–2 tables using transactions
BEGIN TRANSACTION currency_id;
BEGIN
    IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Currency')
       AND EXISTS (SELECT * FROM sys.tables WHERE name = 'Clients')
    BEGIN
        ROLLBACK TRANSACTION currency_id;
    END
    ELSE
    BEGIN
        CREATE TABLE Currency (
            currency_id INT PRIMARY KEY,
            currency_name NVARCHAR(50) UNIQUE
        );

        CREATE TABLE Clients (
            client_id INT PRIMARY KEY,
            last_name NVARCHAR(100) NOT NULL,
            first_name NVARCHAR(100) NOT NULL
        );

        CREATE TABLE Receipt (
            receipt_id INT PRIMARY KEY,
            currency_id INT REFERENCES Currency(currency_id),
            client_id INT REFERENCES Clients(client_id) ON DELETE CASCADE
        );
    END
END;
GO

COMMIT TRANSACTION currency_id;
GO

SELECT * FROM Currency;
GO

ROLLBACK TRANSACTION currency_id;
GO

-- Insert 5–6 records using a stored procedure
CREATE PROCEDURE insert_data 
    @currency_id INT,
    @name NVARCHAR(10)
AS
BEGIN
    BEGIN TRANSACTION insert_currency;

    INSERT INTO Currency(currency_id, currency_name)
    VALUES (@currency_id, @name);

    COMMIT TRANSACTION insert_currency;
END;
GO

EXEC insert_data 1, 'MDL';
EXEC insert_data 2, 'EURO';
EXEC insert_data 3, 'DOLLAR';
EXEC insert_data 4, 'POUND';
EXEC insert_data 5, 'RUBLE';
EXEC insert_data 6, 'DIRHAM';
GO

SELECT * FROM Currency;
GO

-- Perform calculations using a function (scalar or table-valued)
CREATE FUNCTION dbo.total_currencies ()
RETURNS INT
AS
BEGIN 
    DECLARE @Total INT;

    SELECT @Total = COUNT(currency_id)
    FROM Currency;

    RETURN @Total;
END;
GO  

SELECT dbo.total_currencies() AS TotalCurrencies;
GO

-- Create a trigger (INSERT, UPDATE, DELETE) that forbids
-- one operation on MDL by checking a specific condition
CREATE TRIGGER prevent_currency_update
ON Currency
FOR UPDATE
AS
IF UPDATE(currency_name)
BEGIN
    RAISERROR('Changing the currency name is not allowed.', 16, 1);
    ROLLBACK;
END;
GO

UPDATE Currency
SET currency_name = 'Mdl'
WHERE currency_name = 'MDL';
GO

-- Backup
BACKUP DATABASE CurrencyExchange
TO DISK = 'D:\BACKUP\currency_exchange.bak'
WITH INIT, STATS = 10;
