/* ==================================================
 ETAP 2: TRANSFORMACJA I ŁADOWANIE (TABELA FAKTÓW)
================================================== */

-- Analiza zakresów wartości dla zmiennych finansowych i dat
SELECT 
    MIN(Discount) AS Min_Discount, MAX(Discount) AS Max_Discount,
    MIN(OrderItemTotal) AS Min_Item_Total, MAX(OrderItemTotal) AS Max_Item_Total,
    MIN(Sales) AS Min_Sales, MAX(Sales) AS Max_Sales,
    MIN(Profit) AS Min_Profit, MAX(Profit) AS Max_Profit,
    MIN(Order_Date) AS Min_Date, MAX(Order_Date) AS Max_Date
FROM [dbo].[Fact_Sales];

-- Inicjalizacja tabeli faktów
CREATE TABLE dbo.Fact_Sales (
    Order_Item_Id INT PRIMARY KEY,
    Order_Id INT,
    Customer_Id INT,
    Product_Card_Id INT,
    Category_Id INT,
    Department_Id INT,
    Order_Date DATETIME2,
    Shipping_Date DATETIME2,
    Sales DECIMAL (18,2),
    Quantity INT,
    OrderItemTotal DECIMAL (18,2),
    Profit Decimal(18,2),
    Discount Decimal(18,2),
    DaysShippingReal INT,
    DaysShippmentScheduled INT,
    LateDelicetyRisk INT
);

-- Migracja danych z warstwą castowania typów do tabeli faktów
INSERT INTO [dbo].[Fact_Sales]
SELECT 
    TRY_CAST([Order_Item_Id] AS INT),
    TRY_CAST([Order_Id] AS INT),
    TRY_CAST([Customer_Id] AS INT),
    TRY_CAST([Product_Card_Id] AS INT),
    TRY_CAST([Category_Id] AS INT),
    TRY_CAST([Department_Id] AS INT),
    TRY_CAST(order_date_DateOrders AS DATETIME2),
    TRY_CAST(shipping_date_DateOrders AS DATETIME2),
    TRY_CAST([Sales] AS decimal(18,2)),
    TRY_CAST([Order_Item_Quantity] AS INT),
    TRY_CAST([Order_Item_Total] AS decimal(18,2)),
    TRY_CAST([Order_Profit_Per_Order] AS decimal(18,2)),
    TRY_CAST(Order_Item_Discount AS decimal(18,2)),
    TRY_CAST([Days_for_shipping_real] AS int),
    TRY_CAST([Days_for_shipment_scheduled] AS int),
    TRY_CAST([Late_delivery_risk] AS INT)
FROM [dbo].[DataCo_FactPrep];

-- Audyt schematu: identyfikacja kolumn niewykorzystanych w tabeli faktów
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'stg_DataCoSupplyChainDataset'
AND TABLE_SCHEMA = 'dbo'
AND COLUMN_NAME NOT IN (
    'Order_Item_Id', 'Order_Id', 'Customer_Id', 'Product_Card_Id', 'Category_Id',
    'Department_Id', 'order_date_DateOrders', 'shipping_date_DateOrders', 'Sales',
    'Order_Item_Quantity', 'Order_Item_Total', 'Order_Profit_Per_Order',
    'Order_Item_Discount', 'Days_for_shipping_real',
    'Days_for_shipment_scheduled', 'Late_delivery_risk'
);

-- Dodanie kolumny daty do tabeli faktów dla relacji z Dim_Date
ALTER TABLE Fact_Sales ADD Order_Date_Only Date;
UPDATE Fact_Sales SET Order_Date_Only = CAST(Order_Date AS DATE);