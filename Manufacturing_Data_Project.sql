CREATE DATABASE MANUFACTURING_DB;
USE MANUFACTURING_DB;

select * FROM `manufacturing data`;
CREATE TABLE manufacturing_data (
    Buyer VARCHAR(100),
    Cust_Code VARCHAR(50),
    Cust_Name VARCHAR(100),
    Delivery_Period DATE,
    Department_Name VARCHAR(100),
    Designer VARCHAR(100),
    Doc_Date DATE,
    Doc_Num VARCHAR(50),
    EMP_Code VARCHAR(50),
    Emp_Name VARCHAR(100),
    Per_Day_Machine_Cost DECIMAL(10,2),
    Press_Qty INT,
    Processed_Qty INT,
    Produced_Qty INT,
    Rejected_Qty INT,
    `Repeat` BOOLEAN,
    Today_Manufactured_Qty INT,
    TotalQty INT,
    TotalValue DECIMAL(12,2),
    WO_Qty INT,
    Machine_Code VARCHAR(50),
    Operation_Name VARCHAR(100),
    Operation_Code VARCHAR(50),
    Item_Code VARCHAR(50),
    Item_Name VARCHAR(100)
);


/*1. Total Quantity Produced Per Customer*/

SELECT 
    Cust_Name,
    SUM(Produced_Qty) AS Total_Produced
FROM 
    manufacturing_data
GROUP BY 
    Cust_Name
ORDER BY 
    Total_Produced DESC;  
    
/*2. Daily Production Report*/

SELECT 
    Doc_Date,
    SUM(Produced_Qty) AS Total_Produced,
    SUM(Rejected_Qty) AS Total_Rejected
FROM 
    manufacturing_data
GROUP BY 
    Doc_Date
ORDER BY 
    Doc_Date DESC;
/*3. Machine-Wise Rejection Rate*/

SELECT 
    Machine_Code,
    SUM(Rejected_Qty) AS Total_Rejected,
    SUM(Produced_Qty + Rejected_Qty) AS Total_Units,
    ROUND(SUM(Rejected_Qty) * 100.0 / NULLIF(SUM(Produced_Qty + Rejected_Qty), 0), 2) AS Rejection_Percentage
FROM 
    manufacturing_data
GROUP BY 
    Machine_Code
ORDER BY 
    Rejection_Percentage DESC;
/*4. Top 5 Designers by Output*/

SELECT 
    Designer,
    SUM(Produced_Qty) AS Total_Output
FROM 
    manufacturing_data
GROUP BY 
    Designer
ORDER BY 
    Total_Output DESC
LIMIT 5;
/* 5. Customers With Most Rejections*/

SELECT 
    Cust_Name,
    SUM(Rejected_Qty) AS Total_Rejected
FROM 
    manufacturing_data
GROUP BY 
    Cust_Name
ORDER BY 
    Total_Rejected DESC;
/* 6. Operations With Highest Total Value*/

SELECT 
    Operation_Name,
    SUM(TotalValue) AS Total_Operation_Value
FROM 
    manufacturing_data
GROUP BY 
    Operation_Name
ORDER BY 
    Total_Operation_Value DESC;
/* 7. Daily Machine Cost*/

SELECT 
    Doc_Date,
    SUM(Per_Day_Machine_Cost) AS Total_Machine_Cost
FROM 
    manufacturing_data
GROUP BY 
    Doc_Date
ORDER BY 
    Doc_Date DESC;
/*8. List of Repeat Orders*/

SELECT 
    Doc_Num,
    Cust_Name,
    Item_Name,
    `Repeat`
FROM 
    manufacturing_data
WHERE 
    `Repeat` = TRUE;
/*9. Production Summary by Department*/

SELECT 
    Department_Name,
    SUM(Press_Qty) AS Total_Press_Qty,
    SUM(Processed_Qty) AS Total_Processed,
    SUM(Produced_Qty) AS Total_Produced
FROM 
    manufacturing_data
GROUP BY 
    Department_Name;
/*10. WO Qty vs Produced Qty Variance*/

SELECT 
    Doc_Num,
    WO_Qty,
    Produced_Qty,
    (WO_Qty - Produced_Qty) AS Variance
FROM 
    manufacturing_data
ORDER BY 
    Variance DESC;