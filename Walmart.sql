-- create database
CREATE DATABASE walmartSales;

-- using database
USE walmartSales;

-- Create table
CREATE TABLE  sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);

-- data cleaning
SELECT * 
FROM sales;

-- add time_of_day column
SELECT time,
CASE
	WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
    WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon' 
    ELSE 'Evening'
    END AS time_of_day
    FROM sales;
    
ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

UPDATE sales
SET time_of_day = (
	CASE
		WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
		WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon' 
		ELSE 'Evening'
    END
);

-- ADD day_name column
SELECT 
	date,
	DAYNAME(date)
FROM sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

UPDATE sales
SET day_name = DAYNAME(date);

-- ADD MONTH_NAME column
SELECT 
	date,
    monthname(date)
FROM sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(20);

UPDATE sales
SET month_name = MONTHNAME(date);


-- --------------------------------------------------------------------
-- ---------------------------- Generic ------------------------------
-- --------------------------------------------------------------------
-- How many unique cities does the data have?
SELECT DISTINCT city
FROM sales;

-- in which city is each branch

SELECT 
	DISTINCT city,
    branch
FROM sales;

-- --------------------------------------------------------------------
-- ---------------------------- Product -------------------------------
-- --------------------------------------------------------------------
-- How many unique product lines does the data have?
SELECT 
	DISTINCT product_line
FROM sales;

-- What is the most common payment method?
SELECT 
	payment,
    count(payment)  
from sales 
group by payment 
ORDER BY count(payment) DESC;
-- IF WE WANT ONE RESULT WITH MOST COMMON PAYMENT METHOD
SELECT 
	payment,
    count(payment)  
from sales 
group by payment 
ORDER BY count(payment) DESC
LIMIT 1;


-- What is the most selling product line?
SELECT 
	product_line,
    sum(quantity) AS qty
FROM sales
GROUP BY product_line
ORDER BY qty DESC;

-- What is the total revenue by month?
SELECT 
	month_name AS Month,
	sum(total) AS Total_revenue
FROM sales 
GROUP BY month_name
ORDER BY Total_revenue DESC;

-- What month had the largest COGS?
SELECT 
	month_name AS Month,
    SUM(cogs) AS cogs
FROM sales 
GROUP BY month_name
ORDER BY cogs DESC;

-- What product line had the largest revenue?
SELECT 
	product_line AS product,
    sum(total) AS Revenue
FROM sales
GROUP BY product_line
ORDER BY Revenue DESC;

-- What is the city with the largest revenue?
SELECT 
	city,
    sum(total) AS Revenue
FROM sales
GROUP BY city
ORDER BY Revenue DESC;    

-- What product line had the largest VAT?
SELECT 
	product_line AS product,
    avg(tax_pct) AS VAT
FROM sales
GROUP BY product
ORDER BY VAT DESC;

-- Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its average sales greater than 5
SELECT 
	product_line AS product,
    CASE
		WHEN avg(quantity) > 5 THEN 'Good'
        ELSE 'Bad'
	END AS REMARK
FROM sales
GROUP BY product;

-- Which branch sold more products than average product sold?
SELECT 
	branch,
    SUM(quantity) AS qty
FROM sales
GROUP BY branch 
HAVING sum(quantity) > (SELECT avg(quantity) FROM sales);

-- What is the most common product line by gender?
SELECT 
	product_line AS product,
	gender,
    count(gender) AS people
FROM sales
GROUP BY gender,product
ORDER BY people DESC;

-- What is the average rating of each product line?

SELECT 
	product_line AS product,
    ROUND(avg(rating),2) AS Average_Rating
FROM sales
GROUP BY product;
-- --------------------------------------------------------------------
-- --------------------------------------------------------------------

-- --------------------------------------------------------------------
-- -------------------------- Customers -------------------------------
-- --------------------------------------------------------------------

-- How many unique customer types does the data have?

SELECT DISTINCT customer_type FROM sales;

-- How many unique payment methods does the data have?
 SELECT DISTINCT payment FROM sales;
 
 -- What is the most common customer type?
SELECT 
	customer_type,
    count(customer_type) AS people
FROM sales 
GROUP BY customer_type
ORDER BY people DESC;

-- Which customer type buys the most?
SELECT 
	customer_type,
    sum(quantity) AS qnty
FROM sales 
GROUP BY customer_type
ORDER BY qnty DESC;

--  What is the gender of most of the customers?
SELECT 
	gender,
    count(gender) AS gender_count
FROM sales
GROUP BY gender
ORDER BY gender_count DESC;

-- Which time of the day do customers give most ratings?
SELECT 
    time_of_day, 
    ROUND(AVG(rating), 2) AS average_rating
FROM
    sales
GROUP BY time_of_day
ORDER BY AVG(rating) DESC;

-- Which time of the day do customers give most ratings per branch?
SELECT 
	branch,
    time_of_day, 
    ROUND(AVG(rating), 2) AS average_rating
FROM
    sales
WHERE branch = 'A'
GROUP BY branch,time_of_day
ORDER BY AVG(rating) DESC;

-- Which day fo the week has the best avg ratings?
SELECT 
    day_name AS day, 
    ROUND(AVG(rating), 2) AS average_rating
FROM
    sales
GROUP BY day_name
ORDER BY AVG(rating) DESC;

-- Which day of the week has the best average ratings per branch?
SELECT 
	branch,
    day_name AS day, 
    ROUND(AVG(rating), 2) AS average_rating
FROM
    sales
WHERE branch = 'B'
GROUP BY day_name
ORDER BY AVG(rating) DESC;

-- --------------------------------------------------------------------
-- --------------------------------------------------------------------

-- --------------------------------------------------------------------
-- ---------------------------- Sales ---------------------------------
-- --------------------------------------------------------------------

-- Number of sales made in each time of the day per weekday
SELECT 
	time_of_day,
    count(*) AS total_sale
FROM sales
WHERE day_name = 'sunday'
GROUP BY time_of_day
ORDER BY total_sale DESC;

SELECT 
	time_of_day,
    count(*) AS total_sale
FROM sales
WHERE day_name = 'tuesday'
GROUP BY time_of_day
ORDER BY total_sale DESC;

-- Which of the customer types brings the most revenue?
SELECT 
	customer_type,
    SUM(total) AS Revenue
FROM sales
GROUP BY customer_type
ORDER BY Revenue DESC;

-- Which city has the largest tax percent/ VAT (Value Added Tax)?
SELECT 
	city,
    ROUND(AVG(tax_pct),2) AS VAT
FROM sales
GROUP BY city
ORDER BY VAT DESC;

-- Which customer type pays the most in VAT?
SELECT 
	customer_type,
    ROUND(avg(tax_pct),2) AS VAT
FROM sales
GROUP BY customer_type
ORDER BY VAT DESC;






    




