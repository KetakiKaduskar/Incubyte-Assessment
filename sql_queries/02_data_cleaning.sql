DESCRIBE transaction_table;

#Checking how many missing values are present in each column
SELECT 
	COUNT(*) - COUNT(TransactionID) AS Missing_TransactionID,
    COUNT(*) - COUNT(CustomerID) AS Missing_CustomerID,
    COUNT(*) - COUNT(TransactionDate) AS Missing_TransactionDate,
    COUNT(*) - COUNT(TransactionAmount) AS Missing_TransactionAmount,
    COUNT(*) - COUNT(PaymentMethod) AS Missing_PaymentMethod,
    COUNT(*) - COUNT(Quantity) AS Missing_Quantity,
    COUNT(*) - COUNT(DiscountPercent) AS Missing_DiscountPercent,
    COUNT(*) - COUNT(City) AS Missing_City,
    COUNT(*) - COUNT(StoreType) AS Missing_StoreType,
    COUNT(*) - COUNT(CustomerAge) AS Missing_CustomerAge,
    COUNT(*) - COUNT(CustomerGender) AS Missing_CustomerGender,
    COUNT(*) - COUNT(LoyaltyPoints) AS Missing_LoyaltyPoints,
    COUNT(*) - COUNT(ProductName) AS Missing_ProductName,
    COUNT(*) - COUNT(Region) AS Missing_Region,
    COUNT(*) - COUNT(Returned) AS Missing_Returned,
    COUNT(*) - COUNT(FeedbackScore) AS Missing_FeedbackScore,
    COUNT(*) - COUNT(ShippingCost) AS Missing_ShippingCost,
    COUNT(*) - COUNT(DeliveryTimeDays) AS Missing_DeliveryTimeDays,
    COUNT(*) - COUNT(IsPromotional) AS Missing_IsPromotional
FROM transaction_table;

#Checking for negative values of Transaction Amount and Quantity, this is probably faulty data and will have to be removed or corrected
SELECT * FROM transaction_table 
#SELECT count(*) FROM transaction_table 
WHERE TransactionAmount < 0 OR Quantity < 0;

#Checking for wrong values of age
SELECT * FROM transaction_table 
WHERE CustomerAge > 100;

#Checking for wrong values for payment method
SELECT DISTINCT PaymentMethod FROM transaction_table;

#Checking for duplicate rows
SELECT TransactionID, COUNT(*) 
FROM transaction_table 
GROUP BY TransactionID 
HAVING COUNT(*) > 1;

#checking faulty values of date
SELECT DISTINCT DATE_FORMAT(TransactionDate, '%Y-%m') AS CHECK_YEAR_MONTH
FROM transaction_table
ORDER BY CHECK_YEAR_MONTH;
SELECT COUNT(*) FROM transaction_table
#SELECT TransactionDate FROM transaction_table
WHERE DATE_FORMAT(TransactionDate, '%Y-%m') = '0000-00';