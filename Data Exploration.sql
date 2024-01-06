
SELECT *
FROM DimDate

SELECT *
FROM DimGeography


SELECT *
FROM ProductTable;

SELECT *
FROM CustomerTable

SELECT *
FROM SalesTable;


--What day of the week has the most orders
SELECT EnglishDayNameOfWeek AS 'Day of the Week', SUM(OrderQuantity) AS 'TotalOrders'  
FROM SalesTable AS S
JOIN DimDate AS D
ON S.OrderDateKey = D.DateKey
GROUP BY EnglishDayNameOfWeek
ORDER BY SUM(OrderQuantity) DESC

--What product has the highest orders
SELECT H.*, ProductCategory, ProductSubCategory, StandardCost, FinishedGoodsFlag, DaysToManufacture, ProductLine
FROM 
	(SELECT TOP 5 ProductName, SUM(OrderQuantity) AS 'TotalOrders', SUM(SalesAmount) AS 'TotalSalesAmount', 
		SUM(Profit) AS 'Total Profit'
	FROM ProductTable AS P
	JOIN SalesTable AS S
	ON P.ProductKey = S.ProductKey
	GROUP BY ProductName
	ORDER BY SUM(OrderQuantity) DESC) AS H
JOIN ProductTable AS P
ON H.ProductName = P.ProductName
;


--Product Category With the highest orders
SELECT ProductCategory, SUM(OrderQuantity) AS 'TotalOrders'
FROM ProductTable AS P
JOIN SalesTable AS S
ON P.ProductKey = S.ProductKey
GROUP BY ProductCategory
ORDER BY SUM(OrderQuantity) DESC
;

--Product Category that generates the highest profits
SELECT ProductCategory, SUM(Profit) AS 'TotalProfit'
FROM ProductTable AS P
JOIN SalesTable AS S
ON P.ProductKey = S.ProductKey
GROUP BY ProductCategory
ORDER BY SUM(Profit) DESC

--Product Category that generates the highest profits
SELECT ProductLine, SUM(Profit) AS 'TotalProfit'
FROM ProductTable AS P
JOIN SalesTable AS S
ON P.ProductKey = S.ProductKey
GROUP BY ProductLine
ORDER BY SUM(Profit) DESC


--Customer with highest number of orders

SELECT FullName, CustomerAge, MaritalStatus, Gender, TotalOrders, 
		YearlyIncome, EnglishEducation, EnglishOccupation, 
		(City + ', ' + StateProvinceName + ', ' + EnglishCountryRegionName) AS 'Location'
FROM (
	SELECT TOP 10 C.CustomerKey, SUM(OrderQuantity) AS 'TotalOrders'
	FROM SalesTable AS S
	JOIN CustomerTable AS C
	ON S.CustomerKey = C.CustomerKey
	GROUP BY C.CustomerKey
	ORDER BY SUM(OrderQuantity) DESC) AS O
JOIN CustomerTable AS C
ON O.CustomerKey = C.CustomerKey
JOIN DimGeography AS G
ON C.GeographyKey = G.GeographyKey;

--Total Cost, Sales and Profit
SELECT SUM(OverallProductCost) AS 'TotalCost' ,SUM(SalesAmount) AS 'Total Sales', SUM(Profit) AS 'Total Profit'
FROM SalesTable;

--Number of Products Sold
SELECT COUNT(*) AS 'Number of Products Sold'
FROM ProductTable

--Product Categories Sold
SELECT DISTINCT(ProductCategory)
FROM ProductTable

--Product Lines
SELECT DISTINCT(ProductLine)
FROM ProductTable

--Most expensive goods and how often they are ordered
SELECT TOP 20 ProductName, ProductCategory, StandardCost, COUNT(OrderQuantity) AS 'Number of Orders'
FROM ProductTable AS P
JOIN SalesTable AS S
ON P.ProductKey = S.ProductKey
GROUP BY ProductName, ProductCategory, StandardCost
ORDER BY StandardCost DESC, COUNT(OrderQuantity) DESC


--Aggregation of Sales by Region
SELECT SalesTerritoryRegion AS 'Region', SalesTerritoryCountry AS 'Country' ,SUM(SalesAmount) AS 'Total Sales' 
FROM SalesTable
GROUP BY SalesTerritoryRegion, SalesTerritoryCountry
ORDER BY SUM(SalesAmount) DESC

--Aggregation of Sales by Country
SELECT SalesTerritoryCountry AS 'Country' ,SUM(SalesAmount) AS 'Total Sales' , AVG(SalesAmount) AS 'Average Sales'
FROM SalesTable
GROUP BY SalesTerritoryCountry
ORDER BY SUM(SalesAmount) DESC

--AVerage Sales by country

--Total Number of Customers
SELECT COUNT(*) AS 'Number of Customers'
FROM CustomerTable

--Cites with the most customers
SELECT TOP 10 City, StateProvinceName, EnglishCountryRegionName, COUNT(*) AS 'Number of Customers'
FROM CustomerTable AS C
JOIN DimGeography AS D
ON C.GeographyKey = D.GeographyKey
GROUP BY City, StateProvinceName, EnglishCountryRegionName
ORDER BY COUNT(*) DESC

--Countries with the number of Customers
SELECT EnglishCountryRegionName, COUNT(*) AS 'Number of Customers'
FROM CustomerTable AS C
JOIN DimGeography AS D
ON C.GeographyKey = D.GeographyKey
GROUP BY EnglishCountryRegionName
ORDER BY COUNT(*) DESC

--Distribution of Customers by Marital Status

SELECT MaritalStatus, COUNT(*) AS 'Number of Customers'
FROM CustomerTable
GROUP BY MaritalStatus
ORDER BY COUNT(*) DESC

--Distribution of Customers by Gender
SELECT Gender, COUNT(*) AS 'Number of Customers'
FROM CustomerTable
GROUP BY Gender
ORDER BY COUNT(*) DESC

--Distribution of Customers by Income
SELECT YearlyIncome, COUNT(*) AS 'Number of Customers'
FROM CustomerTable
GROUP BY YearlyIncome
ORDER BY COUNT(*) DESC

--Distribution of Customers by Degree of Education
SELECT EnglishEducation, COUNT(*) AS 'Number of Customers'
FROM CustomerTable
GROUP BY EnglishEducation
ORDER BY COUNT(*) DESC

--Distribution of Customers by Occupation
SELECT EnglishOccupation, COUNT(*) AS 'Number of Customers'
FROM CustomerTable
GROUP BY EnglishOccupation
ORDER BY COUNT(*) DESC

--How many customers are house owners
SELECT  COUNT(*) AS 'Number of Customers'
FROM CustomerTable
WHERE HouseOwner = 'Yes'

----How many customers have kids
SELECT  COUNT(*) AS 'Number of Customers'
FROM CustomerTable
WHERE TotalChildren <> 0

--How many customers have more than two cars
SELECT  COUNT(*) AS 'Number of Customers'
FROM CustomerTable
WHERE NumberCarsOwned > 2

--Grouping Customers based on Number of Cars Owned
SELECT NumberCarsOwned, COUNT(*) AS 'Number of Customers'
FROM CustomerTable
GROUP BY NumberCarsOwned
ORDER BY COUNT(*) DESC;

SELECT *
FROM CustomerTable

--Total Orders made by customers
SELECT MaritalStatus, SUM(OrderQuantity) AS 'Total Orders'
FROM SalesTable AS S
JOIN CustomerTable AS C
ON S.CustomerKey = C.CustomerKey
GROUP BY MaritalStatus
ORDER BY SUM(OrderQuantity) DESC

--How often are orders made based on education
SELECT EnglishEducation, COUNT(*) AS 'Frequency of Orders'
FROM CustomerTable AS C
JOIN SalesTable AS S
ON C.CustomerKey = S.CustomerKey
GROUP BY EnglishEducation
ORDER BY COUNT(*)

--
--Products and how often they are ordered depending on occupation
SELECT TOP 5 *
FROM(
		SELECT EnglishOccupation, ProductName, COUNT(ProductName) AS 'Number of Orders'
		FROM CustomerTable AS C
		JOIN SalesTable AS S
		ON C.CustomerKey = S.CustomerKey
		JOIN ProductTable AS P
		ON S.ProductKey = P.ProductKey
		GROUP BY ProductName, EnglishOccupation) AS M
WHERE EnglishOccupation = 'Professional'
ORDER BY [Number of Orders] DESC;

SELECT *
FROM DimDate

SELECT *
FROM SalesTable


--Trend of Sales per year
SELECT CalendarYear, SUM(SalesAmount) AS 'Total Sales'
FROM SalesTable AS S
JOIN DimDate AS D
ON S.OrderDateKey = D.DateKey
GROUP BY CalendarYear
ORDER BY SUM(SalesAmount) DESC

--Trend of sales per month
SELECT EnglishMonthName, SUM(SalesAmount) AS 'Total Sales'
FROM SalesTable AS S
JOIN DimDate AS D
ON S.OrderDateKey = D.DateKey
GROUP BY EnglishMonthName
ORDER BY SUM(SalesAmount) DESC

--Trend of sales per quarter
SELECT CalendarQuarter, SUM(SalesAmount) AS 'Total Sales'
FROM SalesTable AS S
JOIN DimDate AS D
ON S.OrderDateKey = D.DateKey
GROUP BY CalendarQuarter
ORDER BY SUM(SalesAmount) DESC

--How long has a customer spent with the company
SELECT TOP 10 FullName, DATEDIFF(YY, DateFirstPurchase, MAX(FullDateAlternateKey)) AS 'Number of Years Spent'
FROM CustomerTable AS C
JOIN SalesTable AS S
ON C.CustomerKey = S.CustomerKey
JOIN DimDate AS D
ON S.OrderDateKey =D.DateKey
GROUP BY FullName,  DateFirstPurchase
ORDER BY [Number of Years Spent] DESC;

SELECT MAX(CustomerAge), MIN(CustomerAge)
FROM CustomerTable

--Grouping Customers by Age
SELECT AgeRange, COUNT(AgeRange) AS 'Number of Customers'
FROM (
	SELECT 
	CASE
		WHEN CustomerAge BETWEEN 38 AND 48 THEN '38-48'
		WHEN CustomerAge BETWEEN 48 AND 58 THEN '48-58'
		WHEN CustomerAge BETWEEN 58 AND 68 THEN '58-68'
		WHEN CustomerAge BETWEEN 68 AND 78 THEN '68-78'
		WHEN CustomerAge BETWEEN 78 AND 88 THEN '78-88'
		WHEN CustomerAge BETWEEN 88 AND 98 THEN '88-98'
		WHEN CustomerAge BETWEEN 98 AND 108 THEN '98-108'
		END AS AgeRange
	FROM CustomerTable) AS C
GROUP BY AgeRange
ORDER BY [Number of Customers] DESC;

--Orders by Age Group
SELECT AgeRange, SUM(OrderQuantity) AS 'Total Orders'
FROM (
	SELECT CustomerKey, 
	CASE
		WHEN CustomerAge BETWEEN 38 AND 48 THEN '38-48'
		WHEN CustomerAge BETWEEN 48 AND 58 THEN '48-58'
		WHEN CustomerAge BETWEEN 58 AND 68 THEN '58-68'
		WHEN CustomerAge BETWEEN 68 AND 78 THEN '68-78'
		WHEN CustomerAge BETWEEN 78 AND 88 THEN '78-88'
		WHEN CustomerAge BETWEEN 88 AND 98 THEN '88-98'
		WHEN CustomerAge BETWEEN 98 AND 108 THEN '98-108'
		END AS AgeRange
	FROM CustomerTable) AS C
JOIN SalesTable AS S
ON C.CustomerKey = S.CustomerKey
GROUP BY AgeRange
ORDER BY [Total Orders] DESC;

--Number of Products in each ProductLine
SELECT ProductLine ,COUNT(*) AS 'Number of Products'
FROM ProductTable
GROUP BY ProductLine;

