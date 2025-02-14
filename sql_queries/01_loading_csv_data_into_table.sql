USE incubyte_dataset;

DROP TABLE transaction_table;

CREATE TABLE transaction_table (
    TransactionID INT,
    CustomerID INT,
    TransactionDate DATETIME,
    TransactionAmount DOUBLE,
    PaymentMethod VARCHAR(255),
    Quantity INT,
    DiscountPercent DOUBLE,
    City VARCHAR(255),
    StoreType VARCHAR(255),
    CustomerAge INT,
    CustomerGender VARCHAR(255),
    LoyaltyPoints INT,
    ProductName VARCHAR(255),
    Region VARCHAR(255),
    Returned VARCHAR(255),
    FeedbackScore INT,
    ShippingCost DOUBLE,
    DeliveryTimeDays INT,
    IsPromotional VARCHAR(255)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/assessment_dataset(in).csv'
INTO TABLE transaction_table
FIELDS TERMINATED BY ','
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@TransactionID,@CustomerID,@TransactionDate,@TransactionAmount,@PaymentMethod,@Quantity,@DiscountPercent,@City,@StoreType,@CustomerAge,@CustomerGender,@LoyaltyPoints,@ProductName,@Region,@Returned,@FeedbackScore,@ShippingCost,@DeliveryTimeDays,@IsPromotional) 
SET 
TransactionID = NULLIF(@TransactionID, ''),
CustomerID = NULLIF(@CustomerID, ''),
 TransactionAmount = NULLIF(@TransactionAmount, ''),
 TransactionDate = STR_TO_DATE(@TransactionDate, '%m/%d/%Y %H:%i'),
  PaymentMethod = NULLIF(@PaymentMethod, ''),  
  Quantity = NULLIF(@Quantity, ''),  
  DiscountPercent = NULLIF(@DiscountPercent, ''), 
  City = NULLIF(@City, ''), 
  StoreType = NULLIF(@StoreType, ''), 
  CustomerAge = NULLIF(@CustomerAge, ''), 
  CustomerGender = NULLIF(@CustomerGender, ''), 
  LoyaltyPoints = NULLIF(@LoyaltyPoints, ''), 
  ProductName = NULLIF(@ProductName, ''), 
  Region = NULLIF(@Region, ''), 
  Returned = NULLIF(@Returned, ''), 
  FeedbackScore = NULLIF(@FeedbackScore, ''),  
  ShippingCost = NULLIF(@ShippingCost, ''), 
  DeliveryTimeDays = NULLIF(@DeliveryTimeDays, ''), 
  IsPromotional= NULLIF(@IsPromotional, '');
  
SELECT * from transaction_table LIMIT 50;