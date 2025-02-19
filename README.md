# SQL Retail Sales Analysis Project

## Project Overview

This project analyzes retail sales data using MySQL. The dataset is imported from Kaggle, and various SQL queries are used to clean, explore, and analyze the data.

## Dataset Import

Instead of manually creating the table, import the dataset directly from Kaggle. Follow these steps:

1. Download the dataset from Kaggle.
2. Use MySQL Workbench or the command line to import the dataset.
3. Ensure the table name is `retail_sales` after importing.

## Database Setup

```sql
CREATE DATABASE IF NOT EXISTS sql_project_p1;
USE sql_project_p1;
```

## Table Modifications

```sql
-- Rename table
ALTER TABLE retail_sales
CHANGE `ï»¿transactions_id` `transaction_id` INT;

ALTER TABLE retail_sales
CHANGE `quantiy` `quantity` INT;

-- Modify column data types
ALTER TABLE retail_sales
MODIFY sale_date DATE,
MODIFY sale_time TIME,
MODIFY gender VARCHAR(15),
MODIFY category VARCHAR(15),
MODIFY price_per_unit FLOAT,
MODIFY cogs FLOAT,
MODIFY total_sale FLOAT;
```

## Data Cleaning

```sql
-- Check for NULL values
SELECT * FROM retail_sales WHERE transaction_id IS NULL;
SELECT * FROM retail_sales WHERE sale_date IS NULL;
SELECT * FROM retail_sales WHERE 
    sale_time IS NULL OR 
    customer_id IS NULL OR 
    gender IS NULL OR 
    age IS NULL OR 
    category IS NULL OR 
    quantity IS NULL OR 
    price_per_unit IS NULL OR 
    cogs IS NULL OR 
    total_sale IS NULL;
```

**Output:**


## Data Exploration

```sql
-- Total sales count
SELECT COUNT(*) AS total_sale FROM retail_sales;
```

**Output:**


```sql
-- Unique customers
SELECT COUNT(DISTINCT customer_id) AS total_customer FROM retail_sales;
```

**Output:**


```sql
-- Unw COUNT(DISTINCT category) AS total_category FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;
```

**Output:**


## Business Analysis Queries

```sql
-- Sales made on '2022-11-05'
SELECT * FROM retail_sales WHERE sale_date = '2022-11-05';
```

**Output:**


```sql
-- Clothing sales with quantity >= 4 in Nov 2022
SELECT * FROM retail_sales 
WHERE category = 'Clothing' AND quantity >= 4 
AND DATE_FORMAT(sale_date, "%Y-%m") = "2022-11";
```

**Output:**


```sql
-- Total sales per category
SELECT category, SUM(total_sale) AS total_sale, COUNT(*) AS total_count 
FROM retail_sales GROUP BY category;
```

**Output:**


```sql
-- Average age of customers in Beauty category
SELECT ROUND(AVG(age),2) AS average_age FROM retail_sales WHERE category = 'Beauty';
```

**Output:**


```sql
-- Transactions with total_sale > 1000
SELECT * FROM retail_sales WHERE total_sale > 1000;
```

**Output:**


```sql
-- Transactions by gender in each category
SELECT category, gender, COUNT(*) AS total_trans FROM retail_sales 
GROUP BY category, gender ORDER BY category;
```

**Output:**


```sql
-- Best selling month in each year
WITH MonthlySales AS (
    SELECT YEAR(sale_date) AS year, MONTH(sale_date) AS month, 
    ROUND(AVG(total_sale), 2) AS average_sale FROM retail_sales 
    GROUP BY YEAR(sale_date), MONTH(sale_date)
)
SELECT year, month, average_sale FROM (
    SELECT year, month, average_sale, 
    RANK() OVER (PARTITION BY year ORDER BY average_sale DESC) AS `rank`
    FROM MonthlySales
) AS RankedSales WHERE `rank` = 1 ORDER BY year;
```

**Output:**


```sql
-- Top 5 customers by total sales
SELECT customer_id, SUM(total_sale) AS total_sale FROM retail_sales 
GROUP BY customer_id ORDER BY total_sale DESC LIMIT 5;
```

**Output:**


```sql
-- Unique customers per category
SELECT category, COUNT(DISTINCT customer_id) AS customer_id FROM retail_sales 
GROUP BY category;
```

**Output:**


```sql
-- Orders by shift (Morning, Afternoon, Evening)
SELECT 
    CASE 
        WHEN HOUR(sale_time) < 12 THEN 'Morning'
        WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift,
    COUNT(*) AS number_of_orders
FROM retail_sales
GROUP BY shift
ORDER BY FIELD(shift, 'Morning', 'Afternoon', 'Evening');
```

**Output:**


## Conclusion

This project provides insights into retail sales trends, customer behavior, and sales performance across different categories and time periods. The SQL queries help in data cleaning, exploration, and business decision-making.

