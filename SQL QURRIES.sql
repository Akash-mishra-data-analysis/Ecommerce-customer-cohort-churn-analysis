--CREATE A TABLE 
DROP TABLE IF EXISTS customer_churn_data;
CREATE TABLE customer_churn_data (
    CustomerID VARCHAR,
    SignupDate DATE,
    LastPurchaseDate DATE,
    TotalSpend NUMERIC(10, 2),
    AccountAgeMonths INT,
    ChurnStatus VARCHAR(10),
    DeviceType VARCHAR(50),
    SupportTickets INT,
	AvgSpendPerMonth VARCHAR (50)
);
--IMPORT DATA INTO TABLE 
COPY customer_churn_data
FROM 'D:\extrra file\customer_churn_data.csv' 
WITH (FORMAT CSV, HEADER)
SELECT * FROM  customer_churn_data;

-- 1. REMOVE COMMA FROM AVERAGESPENDPER MONTH COLUMN 
UPDATE customer_churn_data 
SET AvgSpendPerMonth = REPLACE(AvgSpendPerMonth, ',', '');

-- 2. CHANGE DATA CARCHAR TO NUMERIC
ALTER TABLE customer_churn_data 
ALTER COLUMN AvgSpendPerMonth TYPE NUMERIC(10,2) USING AvgSpendPerMonth::NUMERIC;

SELECT 
    DeviceType,
    COUNT(CustomerID) AS Total_Customers,
    SUM(CASE WHEN ChurnStatus = 'Churned' THEN 1 ELSE 0 END) AS Churned_Count,
    ROUND(SUM(CASE WHEN ChurnStatus = 'Churned' THEN 1 ELSE 0 END) * 100.0 / COUNT(CustomerID), 2) AS Churn_Rate_Percentage,
    ROUND (AVG(SupportTickets),2) AS Avg_Support_Tickets
FROM customer_churn_data
GROUP BY DeviceType
ORDER BY Churn_Rate_Percentage DESC;



