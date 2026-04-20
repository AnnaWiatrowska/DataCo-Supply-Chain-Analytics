/* ==================================================
 ETAP 3: TWORZENIE TABEL WYMIARÓW I TESTY INTEGRALNOŚCI
================================================== */

-- Inicjalizacja słownika dat (Dim_Date)
CREATE TABLE [dbo].[Dim_Date] (
    [DateKey] INT PRIMARY KEY,
    [FullDate] DATE,
    [Year] INT,
    [Month] INT,
    [MonthName] NVARCHAR(20),
    [Quarter] INT,
    [DayOfWeek] INT
);

-- Generowanie danych dla tabeli kalendarza
DECLARE @StartDate DATE = '2015-01-01';
DECLARE @EndDate DATE = '2018-12-31';

WHILE @StartDate <= @EndDate
BEGIN
    INSERT INTO [dbo].[Dim_Date]
    SELECT 
        CONVERT(INT, CONVERT(VARCHAR(8), @StartDate, 112)),
        @StartDate,
        YEAR(@StartDate),
        MONTH(@StartDate),
        DATENAME(MONTH, @StartDate),
        DATEPART(QUARTER, @StartDate),
        DATEPART(WEEKDAY, @StartDate);
    
    SET @StartDate = DATEADD(DAY, 1, @StartDate);
END

-- Tworzenie tabeli przejściowej dla wymiaru klienta
SELECT [Customer_City], [Customer_Country], [Customer_Email], [Customer_Fname], 
       [Customer_Id], [Customer_Lname], [Customer_Segment], [Customer_State], 
       [Customer_Street], [Customer_Zipcode], [Latitude], [Longitude], [Market]
INTO [dbo].PrepDim_Customer
FROM [DataCo Supply Chain].[dbo].[stg_DataCoSupplyChainDataset];

-- Walidacja typów danych przed migracją do Dim_Customer
SELECT 
    COUNT(*) AS Wszystkie_Wiersze,
    SUM(CASE WHEN TRY_CAST([Customer_Id] AS INT) IS NULL AND [Customer_Id] IS NOT NULL THEN 1 ELSE 0 END) AS [Customer_Id]
FROM [dbo].PrepDim_Customer;

-- Pomiar maksymalnych długości stringów dla optymalizacji typów danych
SELECT MAX(LEN(Customer_Street)), MAX(LEN(Longitude)), MAX(LEN(Latitude)), MAX(LEN(Market))
FROM [dbo].PrepDim_Customer;

-- Inicjalizacja tabeli wymiaru klienta
CREATE TABLE dbo.Dim_Customer (
    Customer_Id INT PRIMARY KEY,
    Customer_Lname nvarchar(50),
    Customer_Fname nvarchar(50),
    Customer_City nvarchar(50),
    Customer_Country nvarchar(20),
    Customer_Segment nvarchar(20),
    Customer_State nvarchar(5),
    Customer_Street nvarchar(100),
    Customer_Zipcode INT,
    Latitude decimal(18,4),
    Longitude decimal(18,4),
    Market nvarchar(20)
);

-- Migracja danych z deduplikacją (DISTINCT)
INSERT INTO dbo.Dim_Customer (...)
SELECT DISTINCT 
    TRY_CAST([Customer_Id] AS INT),
    TRY_CAST([Customer_Lname] AS NVARCHAR(50)),
    TRY_CAST([Customer_Fname] AS NVARCHAR(50)),
    TRY_CAST([Customer_City] AS NVARCHAR(50)),
    TRY_CAST([Customer_Country] AS NVARCHAR(20)),
    TRY_CAST([Customer_Segment] AS NVARCHAR(20)),
    TRY_CAST([Customer_State] AS NVARCHAR(5)),
    TRY_CAST([Customer_Street] AS NVARCHAR(100)),
    TRY_CAST([Customer_Zipcode] AS INT),
    TRY_CAST([Latitude] AS DECIMAL(18,4)),
    TRY_CAST([Longitude] AS DECIMAL(18,4))
FROM [dbo].PrepDim_Customer;

-- Analiza duplikatów Customer_Id w tabeli źródłowej
SELECT [Customer_Id], COUNT(*) AS Liczba_Wystapien
FROM [dbo].PrepDim_Customer
GROUP BY [Customer_Id]
HAVING COUNT(*) > 1
ORDER BY Liczba_Wystapien DESC;

-- Tworzenie tabeli przejściowej dla wymiaru zamówień
SELECT [Type], [Delivery_Status], [Market], [Order_City], [Order_Country], 
       [Order_Customer_Id], [order_date_DateOrders], [Order_Id], [Order_Region], 
       [Order_State], [Order_Status], [Order_Zipcode], [Product_Status], [Shipping_Mode]
INTO [dbo].PrepDim_Order
FROM [DataCo Supply Chain].[dbo].[stg_DataCoSupplyChainDataset];

-- Inicjalizacja tabeli wymiaru zamówień
CREATE TABLE dbo.Dim_Order (
    [Type] nvarchar(20), [Delivery_Status] nvarchar(20), [Market] nvarchar(20), 
    [Order_City] nvarchar(20), [Order_Country] nvarchar(20), [Order_Customer_Id] INT, 
    [order_date_DateOrders] datetime2, [Order_Id] INT PRIMARY KEY, 
    [Order_Region] nvarchar(50), [Order_State] nvarchar(20), [Order_Status] nvarchar(20), 
    [Order_Zipcode] INT, [Product_Status] INT, [Shipping_Mode] nvarchar(20)
);

-- Migracja danych do Dim_Order
INSERT INTO dbo.Dim_Order (...)
SELECT DISTINCT 
    TRY_CAST([Type] AS nvarchar(20)),
    TRY_CAST([Delivery_Status] AS nvarchar(20)),
    TRY_CAST([Market] AS nvarchar(20)),
    TRY_CAST([Order_City] AS nvarchar(20)),
    TRY_CAST([Order_Country] AS nvarchar(20)),
    TRY_CAST([Order_Customer_Id] AS INT),
    TRY_CAST([order_date_DateOrders] AS datetime2),
    TRY_CAST([Order_Id] AS INT),
    TRY_CAST([Order_Region] AS nvarchar(50)),
    TRY_CAST([Order_State] AS nvarchar(20)),
    TRY_CAST([Order_Status] AS nvarchar(20)),
    TRY_CAST([Order_Zipcode] AS INT),
    TRY_CAST([Product_Status] AS INT),
    TRY_CAST([Shipping_Mode] AS nvarchar(20))
FROM [dbo].PrepDim_Order;

-- Inicjalizacja tabeli wymiaru produktu
CREATE TABLE Dim_Product (
    [Category_Id] INT,
    [Category_Name] nvarchar(30),
    [Department_Id] INT,
    [Department_Name] nvarchar(20),
    [Product_Card_Id] INT PRIMARY KEY,
    [Product_Category_Id] INT,
    [Product_Name] nvarchar(50),
    [Product_Price] decimal(18,2)
);

-- Migracja danych do Dim_Product
INSERT INTO Dim_Product (...)
SELECT DISTINCT 
    TRY_CAST([Category_Id] AS INT),
    TRY_CAST([Category_Name] AS nvarchar(30)),
    TRY_CAST([Department_Id] AS INT),
    TRY_CAST([Department_Name] AS nvarchar(20)),
    TRY_CAST([Product_Card_Id] AS INT),
    TRY_CAST([Product_Category_Id] AS INT),
    TRY_CAST([Product_Name] AS nvarchar(50)),
    TRY_CAST([Product_Price] AS decimal(18,2))
FROM dbo.PrepDim_Product;

-- Test integralności: wyszukiwanie rekordów osieroconych (orphan records)
SELECT TOP 10 f.Order_Id, c.Customer_Id, p.Product_Name
FROM Fact_Sales f
LEFT JOIN Dim_Customer c ON f.Customer_Id = c.Customer_Id
LEFT JOIN Dim_Product p ON f.Product_Card_Id = p.Product_Card_Id
WHERE c.Customer_Id IS NULL;