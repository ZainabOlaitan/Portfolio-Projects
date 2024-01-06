USE AdventureWorksDW2019;

SELECT *
FROM AdventureWorksDW2019.INFORMATION_SCHEMA.TABLES;

SELECT *
FROM AdventureWorksDW2019.INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE';

SELECT COUNT(*) AS [Number of Tables]
FROM AdventureWorksDW2019.INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE';

--Exploring the tables in the database
SELECT *
FROM DimReseller;

SELECT *
FROM DimCurrency;

SELECT *
FROM DimCustomer;

SELECT *
FROM DimDate;

--Checking the last time the database was updated
SELECT TOP 1 FullDateAlternateKey AS [Last Date]
FROM DimDate
ORDER BY FullDateAlternateKey DESC;

SELECT *
FROM DimSalesReason;
 
SELECT *
FROM DimEmployee;

SELECT *
FROM DimGeography;

SELECT *
FROM FactInternetSalesReason;

SELECT *
FROM DimProduct;

SELECT *
FROM DimProductCategory;

SELECT *
FROM FactInternetSales;

SELECT *
FROM FactResellerSales;

--Exploring the tables
SELECT *
FROM AdventureWorksDW2019.INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME = 'EmployeeKey';

SELECT *
FROM AdventureWorksDW2019.INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME = 'ScenarioKey';

SELECT *
FROM AdventureWorksDW2019.INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME = 'DateKey';

SELECT *
FROM AdventureWorksDW2019.INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME = 'DepartmentGroupKey';

SELECT *
FROM AdventureWorksDW2019.INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME = 'GeographyKey';

SELECT *
FROM AdventureWorksDW2019.INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME = 'OrganizationKey';

SELECT *
FROM AdventureWorksDW2019.INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME = 'SurveyResponseKey';

SELECT *
FROM AdventureWorksDW2019.INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME = 'SalesOrderNumber';

SELECT *
FROM AdventureWorksDW2019.INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME = 'OrderDateKey';

SELECT *
FROM AdventureWorksDW2019.INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME = 'ProductCategoryKey';

SELECT *
FROM AdventureWorksDW2019.INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME = 'CustomerKey';

SELECT *
FROM AdventureWorksDW2019.INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME = 'SalesReasonKey';

SELECT *
FROM AdventureWorksDW2019.INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME = 'SalesOrderNumber';

SELECT *
FROM AdventureWorksDW2019.INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME = 'CurrencyKey';

SELECT *
FROM AdventureWorksDW2019.INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME = 'DateKey';

/*Cleaning the Fact Internet Sales Table*/

SELECT *
FROM AdventureWorksDW2019.INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'FactInternetSales'

SELECT *
FROM FactInternetSales

--Number of Columns
SELECT COUNT (*) AS NumberofColumns
FROM AdventureWorksDW2019.INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'FactInternetSales';

--Number of Rows
SELECT COUNT(*) AS NumberofRows
FROM FactInternetSales

--Checking for null values
SELECT *
FROM FactInternetSales
WHERE SalesOrderNumber IS NULL;

--Checking the different currency involved in sales
SELECT DISTINCT F.CurrencyKey, D.CurrencyName
FROM FactInternetSales AS F
JOIN DimCurrency AS D
ON F.CurrencyKey = D.CurrencyKey;


--Confirming that the values of unit price and extended amount are equal
SELECT UnitPrice, ExtendedAmount 
FROM FactInternetSales
WHERE UnitPrice <> ExtendedAmount;

--Since it is, let's check if the unit price is always the same as the sales amount 
SELECT UnitPrice, SalesAmount 
FROM FactInternetSales
WHERE UnitPrice <> SalesAmount;

--Checking for Product Standard Cost and Total Product Cost
SELECT ProductStandardCost, TotalProductCost 
FROM FactInternetSales
WHERE ProductStandardCost <> TotalProductCost;


--Creating a new sales table with necessary columns
CREATE VIEW SalesTable AS
SELECT ProductKey, CustomerKey, OrderQuantity, OverallProductCost, SalesAmount,
		(SalesAmount - OverallProductCost) AS Profit, CurrencyName, 
		SalesReasonName, S.SalesTerritoryKey, SalesTerritoryGroup, SalesTerritoryCountry, SalesTerritoryRegion,
		OrderDateKey, DueDateKey, ShipDateKey
FROM (
	SELECT ProductKey, CustomerKey, CurrencyKey, SalesTerritoryKey, SalesOrderNumber, OrderQuantity, 
		(TaxAmt + Freight + TotalProductCost) AS OverallProductCost, SalesAmount, OrderDateKey, DueDateKey, ShipDateKey
	FROM FactInternetSales) AS S
JOIN FactInternetSalesReason AS F
ON S.SalesOrderNumber = F.SalesOrderNumber
JOIN DimSalesReason AS D
ON F.SalesReasonKey = D.SalesReasonKey
JOIN DimCurrency AS C
ON S.CurrencyKey = C.CurrencyKey
JOIN DimSalesTerritory AS T
ON S.SalesTerritoryKey = T.SalesTerritoryKey;

SELECT * 
FROM SalesTable

/*Cleaning the Products Table*/
SELECT *
FROM DimProduct;

SELECT COLUMN_NAME
FROM AdventureWorksDW2019.INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'DimProduct';

SELECT COUNT(COLUMN_NAME) AS 'Number of Columns'
FROM AdventureWorksDW2019.INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'DimProduct';

SELECT COUNT(*) AS 'Number of Rows'
FROM DimProduct;

SELECT *
FROM DimProductCategory;

SELECT *
FROM DimProductSubcategory;

SELECT *
FROM DimProduct
WHERE StandardCost IS NOT NULL
ORDER BY StandardCost DESC;

--Checking if the product cost in the FactInternetSales is the same as the one in the DimProduct
SELECT D.ProductKey, D.StandardCost, F.ProductStandardCost
FROM DimProduct as D
JOIN FactInternetSales AS F
ON D.ProductKey = F.ProductKey
WHERE D.StandardCost <> F.ProductStandardCost
ORDER BY StandardCost;


SELECT DISTINCT(FinishedGoodsFlag)
FROM DimProduct;

SELECT DISTINCT(ProductLine)
FROM DimProduct;

--Finding a common name for the product line codes
SELECT *
FROM DimProduct
WHERE ProductLine = 'T';

SELECT *
FROM DimProduct
WHERE StandardCost IS NULL;

--Checking if the product with null values as standardcost exist in the sales table
SELECT D.ProductKey, StandardCost, F.ProductStandardCost
FROM DimProduct AS D
JOIN FactInternetSales AS F
ON D.ProductKey = F.ProductKey
WHERE StandardCost IS NULL;
--Since it doesn't, we can remove it later on

SELECT *
FROM DimProduct
WHERE EnglishDescription IS NOT NULL;

SELECT DISTINCT(Status)
FROM DimProduct;

SELECT *
FROM DimProductCategory;

--Creating a new products table with necessary columns
CREATE VIEW ProductTable AS 
SELECT ProductKey, D.ProductSubcategoryKey, C.ProductCategoryKey, 
		EnglishProductName AS ProductName, 
		EnglishProductCategoryName AS ProductCategory,
		EnglishProductSubcategoryName AS ProductSubcategory, 
		StandardCost,
		REPLACE(REPLACE(FinishedGoodsFlag, 0, 'No'), 1, 'Yes') AS FinishedGoodsFlag,
		DaysToManufacture, 
		REPLACE(REPLACE(REPLACE(REPLACE(ProductLine, 'T', 'Touring'), 'R ', 'Road'), 'M', 'Mountain'), 'S', 'Sports') AS ProductLine
FROM DimProduct AS D
JOIN DimProductSubcategory AS S
ON D.ProductSubcategoryKey = S.ProductSubcategoryKey
JOIN DimProductCategory AS C
ON S.ProductCategoryKey = C.ProductCategoryKey
WHERE StandardCost IS NOT NULL AND ProductLine IS NOT NULL;

SELECT *
FROM ProductTable

/*Cleaning the Customer Table*/
SELECT *
FROM AdventureWorksDW2019.INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'DimCustomer'

--Number of Columns
SELECT COUNT (*) AS NumberofColumns
FROM AdventureWorksDW2019.INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'DimCustomer';

--Number of Rows
SELECT COUNT(*) AS NumberofRows
FROM DimCustomer

SELECT *
FROM DimCustomer

SELECT *
FROM DimCustomer
WHERE CustomerKey IS NULL;

SELECT DISTINCT (MaritalStatus)
FROM DimCustomer

SELECT DISTINCT (HouseOwnerFlag)
FROM DimCustomer

SELECT DISTINCT (Title)
FROM DimCustomer

SELECT DISTINCT (Gender)
FROM DimCustomer

SELECT DISTINCT (Suffix)
FROM DimCustomer

--Creating a new customers table with necessary columns
CREATE VIEW CustomerTable AS
SELECT CustomerKey, GeographyKey,
		CONCAT(Title, ' ', FirstName, ' ', LastName, ' ', MiddleName, ' ', Suffix) AS FullName, 
		DATEDIFF (yy, BirthDate, GETDATE()) AS CustomerAge,
		REPLACE (REPLACE (MaritalStatus, 'S', 'Single'), 'M', 'Married') AS MaritalStatus,
		REPLACE (REPLACE (Gender, 'M', 'Male'), 'F', 'Female') AS Gender,
		YearlyIncome, TotalChildren, NumberChildrenAtHome, EnglishEducation, EnglishOccupation,
		REPLACE (REPLACE (HouseOwnerFlag, '1', 'Yes'), '0', 'No') AS HouseOwner,
		NumberCarsOwned, DateFirstPurchase
FROM DimCustomer

SELECT *
FROM CustomerTable
