
-- SQL Retail Sale Analysis Project 

CREATE DATABASE IF NOT EXISTS sql_project_p1;
USE sql_project_p1;
-- RENAME THE TABLE NAME  
-- RENAME TABLE `sql - retail sales analysis_utf` TO `retail_sales`;
ALTER TABLE  retail_sales
CHANGE `ï»¿transactions_id` `transaction_id` INT;

ALTER TABLE  retail_sales
CHANGE `quantiy` `quantity`INT;


SELECT * FROM retail_sales;


DESCRIBE retail_sales;

ALTER TABLE  retail_sales
MODIFY sale_date  DATE,
MODIFY sale_time TIME,
MODIFY gender VARCHAR(15),
MODIFY category VARCHAR(15),
MODIFY price_per_unit FLOAT,
MODIFY cogs FLOAT,
MODIFY total_sale FLOAT;

SELECT COUNT(*) AS count 
FROM retail_sales;

DROP TABLE retail_sales;

SELECT * FROM retail_sales
WHERE transaction_id IS NULL;

SELECT * FROM retail_sales
WHERE sale_date IS NULL;

SELECT * FROM retail_sales
WHERE 
	sale_time IS NULL
    OR 
    customer_id  IS NULL
    OR
    gender  IS NULL
    OR
    age  IS NULL
    OR
    category  IS NULL
    OR
    quantity IS NULL
    OR
    price_per_unit  IS NULL
    OR
    cogs  IS NULL
    OR
    total_sale IS NULL ;

SELECT * FROM retail_sales;
-- Data Exploration 

-- How Many Sales we have?
SELECT COUNT(*) AS total_sale FROM retail_sales;

-- How Many Unique  Customers we have ?
SELECT COUNT(DISTINCT customer_id) AS total_customer FROM retail_sales;

-- How many unique categories ?
SELECT COUNT(DISTINCT category) AS total_category FROM retail_sales;
SELECT DISTINCT category  FROM retail_sales;

-- Data Analysis & Business key Problems and Answers 

-- 1) Write a SQL query to retrieve all the columns for sales made on '2022-11-05'

SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

/*2) Write a SQL query to retrieve all transactions where the category is "Clothing" and the quantity 
sold is more than or equal to 4   in the month of Nov-2022*/

SELECT * 
	FROM retail_sales
    WHERE 
		category = 'Clothing'
        AND 
        quantity >= 4
        AND 
        DATE_FORMAT(sale_date,"%Y-%m") = "2022-11";
        
-- Q 3) Write a SQL query to calculate the total_sales of each category .

SELECT category,
	SUM(total_sale) AS total_sale, 
    COUNT(*) AS total_count
FROM retail_sales
GROUP BY category;

--  Q 4) write a SQL query to find the average age of customers who purchased items from the 'Beauty' category 

SELECT ROUND(AVG(age),2)AS average_age 
FROM retail_sales 
WHERE category = 'Beauty';
 
 -- Q 5) Write a SQL query to find all transactions where total_sale is greater than 1000 
 
 SELECT * 
 FROM retail_sales 
 WHERE total_sale > 1000;
 
 -- Q 6) write a SQL query to find total number of transactions(transaction_id)  made by each gender in each category .
 
SELECT 
	category,
    gender,
    COUNT(*) AS total_trans
FROM retail_sales 
GROUP BY 
	category,
    gender 
ORDER BY 
	category;
   

-- Q 7) Write a SQL query to calculate the average sale for each month . Find out best selling month in each year.
WITH MonthlySales AS (
    SELECT 
        YEAR(sale_date) AS year,
        MONTH(sale_date) AS month,
        ROUND(AVG(total_sale), 2) AS average_sale
    FROM 
        retail_sales
    GROUP BY 
        YEAR(sale_date),
        MONTH(sale_date)
)
SELECT 
    year,
    month,
    average_sale
FROM (
    SELECT 
        year,
        month,
        average_sale,
        RANK() OVER (PARTITION BY year ORDER BY average_sale DESC) AS `rank`
    FROM 
        MonthlySales
) AS RankedSales
WHERE 
    `rank` = 1
ORDER BY 
    year;
    
-- Q 8) Write a SQL query to find top 5 customers based on the highest total sale  
SELECT 
	customer_id , 
    SUM(total_sale ) AS total_sale
FROM retail_sales 
GROUP BY customer_id 
ORDER BY total_sale DESC
LIMIT 5 ;


-- Q 9) Write a SQL query to find the number of unique customers  who purchased items from each category 
SELECT 
	category ,
    COUNT(DISTINCT customer_id) AS customer_id
FROM retail_sales 
GROUP BY category;


-- Q 10) Write a SQL query to create each shift and number of orders (Example Morning<12 , Afternoon between 12 & 17,Evening >17)

-- SELECT * FROM retail_sales ;

SELECT 
    CASE 
        WHEN HOUR(sale_time) < 12 THEN 'Morning'
        WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift,
    COUNT(*) AS number_of_orders
FROM 
    retail_sales
GROUP BY 
    shift
ORDER BY 
    FIELD(shift, 'Morning', 'Afternoon', 'Evening');
    
    
-- End of Project 