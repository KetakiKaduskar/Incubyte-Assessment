#Total number of transactions, total and avg amount, and total quantity sold ignoring faulty data with negative amount and quantity values 
SELECT 
    COUNT(DISTINCT TransactionID) AS Total_Transactions,
    ROUND(SUM(TransactionAmount),2) AS Total_TransactionAmount,
    ROUND(AVG(TransactionAmount),2) AS Avg_TransactionAmount,
    SUM(Quantity) AS Total_Quantity_Sold
FROM transaction_table
WHERE TransactionAmount > 0 AND Quantity > 0;

#total sales over time
-- SELECT 
--     DATE_FORMAT(TransactionDate, '%Y-%m') AS Transaction_Month,
--     SUM(TransactionAmount) AS Total_Sales,
--     COUNT(TransactionID) AS Total_Transactions
-- FROM transaction_table
-- WHERE TransactionAmount > 0 AND Quantity > 0 
-- GROUP BY Transaction_Month
-- HAVING Transaction_Month != '0000-00'
-- ORDER BY Transaction_Month;
WITH MonthlySales AS (
    SELECT 
        DATE_FORMAT(TransactionDate, '%Y-%m') AS Transaction_Month,
        SUM(TransactionAmount) AS Total_Sales,
        COUNT(TransactionID) AS Total_Transactions
    FROM transaction_table
    WHERE TransactionAmount > 0 AND Quantity > 0 
    GROUP BY Transaction_Month
    HAVING Transaction_Month != '0000-00'
)
SELECT 
    Transaction_Month,
    Total_Sales,
    Total_Transactions,
    LAG(Total_Sales) OVER (ORDER BY Transaction_Month) AS Previous_Month_Sales,
    ROUND(
        (Total_Sales - LAG(Total_Sales) OVER (ORDER BY Transaction_Month)) / 
        LAG(Total_Sales) OVER (ORDER BY Transaction_Month) * 100, 2
    ) AS Percent_Change_Sales,
    LAG(Total_Transactions) OVER (ORDER BY Transaction_Month) AS Previous_Month_Transactions,
    ROUND(
        (Total_Transactions - LAG(Total_Transactions) OVER (ORDER BY Transaction_Month)) / 
        LAG(Total_Transactions) OVER (ORDER BY Transaction_Month) * 100, 2
    ) AS Percent_Change_Transactions
FROM MonthlySales
ORDER BY Transaction_Month;

#which age+gender combo spends the most
SELECT 
    CustomerAge, 
    CustomerGender, 
    COUNT(TransactionID) AS Transactions, 
    ROUND(SUM(TransactionAmount),2) AS Total_Spent
FROM transaction_table
WHERE TransactionAmount > 0 AND Quantity > 0
GROUP BY CustomerAge, CustomerGender
ORDER BY Total_Spent DESC;

#top 10 most loyal customers
SELECT CustomerID, SUM(LoyaltyPoints) AS Total_Loyalty_Points
FROM transaction_table
WHERE CustomerID IS NOT NULL
GROUP BY CustomerID
ORDER BY Total_Loyalty_Points DESC
LIMIT 10;

#city regions with sales
SELECT City, Region, ROUND(SUM(TransactionAmount),2) AS Total_Sales
FROM transaction_table
WHERE TransactionAmount > 0 AND Quantity > 0 AND Region IS NOT NULL
GROUP BY City, Region
ORDER BY Total_Sales DESC;

#top 10 most sold products
SELECT ProductName, 
       ROUND(SUM(TransactionAmount),2) AS Total_Amount, 
       SUM(Quantity) AS Total_Quantity_Sold
FROM transaction_table
WHERE TransactionAmount > 0 AND Quantity > 0 AND ProductName IS NOT NULL
GROUP BY ProductName
ORDER BY Total_Quantity_Sold DESC
LIMIT 10;

#most returned products
SELECT ProductName, COUNT(*) AS Return_Count
FROM transaction_table
WHERE Returned = 'Yes' AND ProductName IS NOT NULL
GROUP BY ProductName
ORDER BY Return_Count DESC
LIMIT 10;

#does more discount result in more products sold?
SELECT MAX(DiscountPercent), MIN(DiscountPercent), AVG(DiscountPercent) FROM transaction_table;
-- SELECT 
--     CASE 
--         WHEN DiscountPercent < 10 THEN 'Low Discount (<10%)'
--         WHEN DiscountPercent BETWEEN 10 AND 30 THEN 'Medium Discount (10-30%)'
--         ELSE 'High Discount (>30%)'
--     END AS Discount_Category,
--     SUM(TransactionAmount) AS Total_Amount,
--     SUM(Quantity) AS Total_Quantity_Sold
-- FROM transaction_table
-- WHERE TransactionAmount > 0 AND Quantity > 0
-- GROUP BY Discount_Category
-- ORDER BY Total_Quantity_Sold DESC;
-- #ORDER BY Total_Amount DESC;
WITH DiscountSales AS (
    SELECT 
        CASE 
            WHEN DiscountPercent < 10 THEN 'Low Discount (<10%)'
            WHEN DiscountPercent BETWEEN 10 AND 30 THEN 'Medium Discount (10-30%)'
            ELSE 'High Discount (>30%)'
        END AS Discount_Category,
        SUM(TransactionAmount) AS Total_Amount,
        SUM(Quantity) AS Total_Quantity_Sold
    FROM transaction_table
    WHERE TransactionAmount > 0 AND Quantity > 0
    GROUP BY Discount_Category
)
SELECT 
    Discount_Category,
    Total_Quantity_Sold,
    ROUND((Total_Quantity_Sold / SUM(Total_Quantity_Sold) OVER ()) * 100, 2) AS Percentage_of_Total_Quantity,
    ROUND(Total_Amount, 2) AS Total_Amount,
    ROUND((Total_Amount / SUM(Total_Amount) OVER ()) * 100, 2) AS Percentage_of_Total_Amount
FROM DiscountSales
ORDER BY Total_Quantity_Sold DESC;

#store type and it's effect on transactions
SELECT StoreType, SUM(TransactionAmount) AS Total_Amount, COUNT(TransactionID) AS Total_Transactions
FROM transaction_table
GROUP BY StoreType;

#does high shipping cost reduce the number of transactions?
SELECT MAX(ShippingCost), MIN(ShippingCost), AVG(ShippingCost) FROM transaction_table;
-- SELECT 
--     CASE 
--         WHEN ShippingCost < 200 THEN 'Low Shipping (<200)'
--         WHEN ShippingCost BETWEEN 200 AND 1400 THEN 'Medium Shipping (200-1400)'
--         ELSE 'High Shipping (>1400)'
--     END AS Shipping_Category,
--     COUNT(TransactionID) AS Transaction_Count,
--     ROUND((COUNT(TransactionID) / SUM(COUNT(TransactionID)) OVER ()) * 100, 2) AS Percentage_of_Total_Transaction_Count
-- FROM transaction_table
-- GROUP BY Shipping_Category
-- ORDER BY Transaction_Count DESC;
WITH ShippingStats AS (
    SELECT 
        CASE 
            WHEN ShippingCost < 200 THEN 'Low Shipping (<200)'
            WHEN ShippingCost BETWEEN 200 AND 1400 THEN 'Medium Shipping (200-1400)'
            ELSE 'High Shipping (>1400)'
        END AS Shipping_Category,
        COUNT(TransactionID) AS Transaction_Count
    FROM transaction_table
    GROUP BY Shipping_Category
)
SELECT 
    Shipping_Category,
    Transaction_Count,
    ROUND((Transaction_Count / SUM(Transaction_Count) OVER ()) * 100, 2) AS Percentage_of_Total_Transaction_Count
FROM ShippingStats
ORDER BY Transaction_Count DESC;