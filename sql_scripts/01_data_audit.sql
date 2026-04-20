/* ==================================================
 ETAP 1: AUDYT I ANALIZA JAKOŚCI DANYCH
================================================== */

-- Analiza źródła
SELECT TOP (1000) * FROM [DataCo Supply Chain].[dbo].[DataCo_FactPrep];

-- Weryfikacja unikalności Order_Item_Id
SELECT [Order_Item_Id], COUNT(*) 
FROM DataCo_FactPrep
GROUP BY [Order_Item_Id] 
HAVING COUNT(*) > 1;

-- Identyfikacja duplikatów Customer_Id
SELECT [Customer_Id], COUNT(*) AS PowtórzeniaKlient
FROM DataCo_FactPrep
GROUP BY [Customer_Id] 
HAVING COUNT(*) > 1
ORDER BY Customer_Id;

-- Sprawdzenie wartości NULL w kluczu głównym
SELECT [Customer_Id]
FROM DataCo_FactPrep
WHERE Customer_Id IS NULL;

-- Audyt brakujących wartości (NULL check) dla wszystkich kolumn
SELECT 
    SUM(CASE WHEN [Days_for_shipping_real] IS NULL THEN 1 ELSE 0 END) AS Braki_Days_for_shipping_real,
    SUM(CASE WHEN [Days_for_shipment_scheduled] IS NULL THEN 1 ELSE 0 END) AS Braki_Days_for_shipment_scheduled,
    SUM(CASE WHEN [Late_delivery_risk] IS NULL THEN 1 ELSE 0 END) AS Braki_Late_delivery_risk,
    SUM(CASE WHEN Category_Id IS NULL THEN 1 ELSE 0 END) AS Braki_Category_Id,
    SUM(CASE WHEN Customer_Id IS NULL THEN 1 ELSE 0 END) AS Braki_Customer_Id,
    SUM(CASE WHEN Department_Id IS NULL THEN 1 ELSE 0 END) AS Braki_Department_Id,
    SUM(CASE WHEN order_date_DateOrders IS NULL THEN 1 ELSE 0 END) AS Braki_order_date_DateOrders,
    SUM(CASE WHEN Order_Id IS NULL THEN 1 ELSE 0 END) AS Braki_Order_Id,
    SUM(CASE WHEN Order_Item_Discount IS NULL THEN 1 ELSE 0 END) AS Order_Item_Discount,
    SUM(CASE WHEN Sales IS NULL THEN 1 ELSE 0 END) AS Braki_Sales,
    SUM(CASE WHEN [Order_Item_Total] IS NULL THEN 1 ELSE 0 END) AS Braki_Order_Item_Total,
    SUM(CASE WHEN [Order_Profit_Per_Order] IS NULL THEN 1 ELSE 0 END) AS Braki_Order_Profit_Per_Order,
    SUM(CASE WHEN [Product_Card_Id] IS NULL THEN 1 ELSE 0 END) AS Braki_Product_Card_Id,
    SUM(CASE WHEN [shipping_date_DateOrders] IS NULL THEN 1 ELSE 0 END) AS Braki_shipping_date_DateOrders
FROM [dbo].[DataCo_FactPrep];

-- Walidacja konwersji typów danych (identyfikacja rekordów niekompatybilnych)
SELECT 
    COUNT(*) AS Wszystkie_Wiersze,
    SUM(CASE WHEN TRY_CAST([Days_for_shipping_real] AS int) IS NULL AND [Days_for_shipping_real] IS NOT NULL THEN 1 ELSE 0 END) AS [Days_for_shipping_real],
    SUM(CASE WHEN TRY_CAST([Days_for_shipment_scheduled] AS int) IS NULL AND [Days_for_shipment_scheduled] IS NOT NULL THEN 1 ELSE 0 END) AS [Days_for_shipment_scheduled],
    SUM(CASE WHEN TRY_CAST([Late_delivery_risk] AS INT) IS NULL AND [Late_delivery_risk] IS NOT NULL THEN 1 ELSE 0 END) AS [Late_delivery_risk],
    SUM(CASE WHEN TRY_CAST([Category_Id] AS INT) IS NULL AND [Category_Id] IS NOT NULL THEN 1 ELSE 0 END) AS [Category_Id],
    SUM(CASE WHEN TRY_CAST([Customer_Id] AS INT) IS NULL AND [Customer_Id] IS NOT NULL THEN 1 ELSE 0 END) AS [Customer_Id],
    SUM(CASE WHEN TRY_CAST([Department_Id] AS INT) IS NULL AND [Department_Id] IS NOT NULL THEN 1 ELSE 0 END) AS [Department_Id],
    SUM(CASE WHEN TRY_CAST([Order_Id] AS INT) IS NULL AND [Order_Id] IS NOT NULL THEN 1 ELSE 0 END) AS [Order_Id],
    SUM(CASE WHEN TRY_CAST(Order_Item_Discount AS decimal(18,4)) IS NULL AND Order_Item_Discount IS NOT NULL THEN 1 ELSE 0 END) AS Order_Item_Discount,
    SUM(CASE WHEN TRY_CAST([Order_Item_Id] AS INT) IS NULL AND [Order_Item_Id] IS NOT NULL THEN 1 ELSE 0 END) AS [Order_Item_Id],
    SUM(CASE WHEN TRY_CAST([Order_Item_Quantity] AS INT) IS NULL AND [Order_Item_Quantity] IS NOT NULL THEN 1 ELSE 0 END) AS [Order_Item_Quantity],
    SUM(CASE WHEN TRY_CAST([Sales] AS decimal(18,4)) IS NULL AND [Sales] IS NOT NULL THEN 1 ELSE 0 END) AS [Sales],
    SUM(CASE WHEN TRY_CAST([Order_Item_Total] AS decimal(18,4)) IS NULL AND [Order_Item_Total] IS NOT NULL THEN 1 ELSE 0 END) AS [Order_Item_Total],
    SUM(CASE WHEN TRY_CAST([Order_Profit_Per_Order] AS decimal(18,4)) IS NULL AND [Order_Profit_Per_Order] IS NOT NULL THEN 1 ELSE 0 END) AS [Order_Profit_Per_Order],
    SUM(CASE WHEN TRY_CAST([Product_Card_Id] AS INT) IS NULL AND [Product_Card_Id] IS NOT NULL THEN 1 ELSE 0 END) AS [Product_Card_Id]
FROM [dbo].[DataCo_FactPrep];