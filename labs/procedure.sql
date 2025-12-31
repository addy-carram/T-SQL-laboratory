SELECT * FROM Product;

CREATE SCHEMA Profit_Report;
GO

DROP PROCEDURE AddData;
GO

ALTER TABLE Product
ADD Income INT,
    VAT INT,
    Sale_Price INT;
GO

BEGIN TRANSACTION add_column;

ALTER TABLE Product
ADD To_Manager INT;
GO

COMMIT;
GO

CREATE PROCEDURE AddData
    @incomePercent FLOAT, 
    @vatPercent FLOAT
AS
BEGIN
    BEGIN TRANSACTION Income_Report;
    
    UPDATE Product
    SET Income = (total_price * @incomePercent) * stock_quantity;

    SAVE TRANSACTION Report_1;
    PRINT 'The first update was completed.';
    
    UPDATE Product
    SET VAT = (total_price * @vatPercent) * stock_quantity;

    SAVE TRANSACTION Report_2;
    PRINT 'The second update was completed.';

    UPDATE Product
    SET Sale_Price = ((total_price * @vatPercent) * stock_quantity + total_price);
    
    PRINT 'The columns were updated successfully.';
    COMMIT TRANSACTION Income_Report;
END;
GO

-- Execute the procedure
EXEC AddData @incomePercent = 0.15, @vatPercent = 0.18;
GO

CREATE PROCEDURE Delete_Product 
    @deleted_product INT
AS
BEGIN TRANSACTION DELETE_PRODUCT;

IF EXISTS (SELECT * FROM Product WHERE id_product = @deleted_product)
    DELETE FROM Product
    WHERE id_product = @deleted_product;

COMMIT;
GO

EXEC Delete_Product @deleted_product = 10;
GO

CREATE PROCEDURE Calculate_Models
AS
-- grouping products by model name
SELECT model_name, COUNT(model_name) AS Similar_Models
FROM Product
GROUP BY model_name;
GO

EXEC Calculate_Models;
GO

CREATE PROCEDURE Update_Stock_Quantity
    @managerPercent INT
AS
BEGIN
    BEGIN TRANSACTION Stock_Report;
    
    UPDATE Product
    SET stock_quantity = stock_quantity * @managerPercent;
    
    PRINT 'Stock quantity was updated.';
    SAVE TRANSACTION stock_1;

    UPDATE Product
    SET stock_quantity = stock_quantity - @managerPercent;

    COMMIT TRANSACTION Stock_Report;
END;
GO

EXEC Update_Stock_Quantity @managerPercent = 3;
GO

CREATE PROCEDURE Manager_Salary
    @managerPercent FLOAT
AS
BEGIN
    BEGIN TRANSACTION Salary_Report;
    
    UPDATE Product
    SET To_Manager = Sale_Price * @managerPercent;

    COMMIT TRANSACTION Salary_Report;
END;
GO

EXEC Manager_Salary @managerPercent = 0.13;
GO

DROP PROCEDURE Manager_Salary;
