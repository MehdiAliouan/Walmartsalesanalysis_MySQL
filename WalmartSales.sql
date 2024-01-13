CREATE DATABASE IF NOT EXISTS salesDataWalmart;

CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(10) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    quantity INT NOT NULL,
    VAT FLOAT(6, 4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment_method VARCHAR(15) NOT NULL,
    cogs DECIMAL(10, 2) NOT NULL,
    gross_margin_pct FLOAT(11, 9),
    gross_income DECIMAL(12, 4) NOT NULL,
    rating FLOAT(2, 1)
    );
    
    ---------------------------------------------------------------------------------------------------------------------
    ----- time of day
    SELECT time,
    (CASE
    WHEN 'time' BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
	WHEN 'time' BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
    ELSE "Evening"
END
    ) AS time_of_date
    from sales;
    
    ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);
    
    UPDATE sales
    SET time_of_day = (
		CASE
             WHEN 'time' BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
	         WHEN 'time' BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
             ELSE "Evening"
       END
    );
    
    ---- Day Name
SELECT
   date,
   DAYNAME(date) AS day_name
FROM sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

UPDATE sales
SET day_name = DAYNAME(date);

------ Month_Name

SELECT date,
       monthname(date)
FROM sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);

UPDATE sales
SET month_name = monthname(date);

------ GENERIC
---- How many unique cities does the data have?

SELECT DISTINCT city 
FROM sales;

---- In which city is each branch?

SELECT 
   DISTINCT branch, city
   FROM sales;


------------- Product
---- How many unique product lines does the data have?
SELECT 
  COUNT(DISTINCT product_line)
  FROM sales;
---- What is the most common payment method?
SELECT 
     payment_method, COUNT(payment_method) AS cnt
    FROM sales
    GROUP BY payment_method
    ORDER BY cnt DESC;

---- What is the most selling product line?
SELECT product_line, SUM(quantity) AS quantity_solde
FROM sales
GROUP BY product_line
ORDER BY quantity_solde DESC;

---- What is the total revenue by month?
SELECT 
	   month_name AS month,
       SUM(total) AS revenue
From sales
GROUP BY month
ORDER BY revenue DESC;

---- What month had the largest COGS?
SELECT month_name AS month, 
       SUM(cogs) AS cogs
FROM sales
GROUP BY month
ORDER BY cogs DESC;

---- What product line had the largest revenue?
SELECT product_line,
       SUM(total) AS revenue
FROM sales
GROUP BY product_line
ORDER BY revenue DESC;

---- What is the city with the largest revenue?
SELECT city, SUM(total) AS revenue
FROM sales
GROUP BY city
ORDER BY revenue DESC;

---- What product line had the largest VAT?
SELECT product_line, AVG(VAT) AS avg_tax
FROM sales
GROUP BY product_line
ORDER BY avg_tax DESC;

---- Which branch sold more products than average product sold?
SELECT branch, SUM(quantity) AS qty
FROM sales
GROUP BY branch
HAVING qty > (select avg(quantity) from sales);

---- What is the most common product line by gender?
SELECT gender, product_line, count(gender) AS total_cnt
FROM sales
GROUP BY gender, product_line
ORDER BY total_cnt DESC;

---- What is the average rating of each product line?
SELECT product_line, ROUND(AVG(rating),2) avg_rating
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;

---------- SALES
---- Which of the customer types brings the most revenue?
SELECT customer_type, SUM(total) AS revenue
FROM sales
GROUP BY customer_type
ORDER BY revenue DESC;

---- Which city has the largest tax percent/ VAT (Value Added Tax)?
SELECT city, AVG(VAT) AS tax_percent
FROM sales
GROUP BY city
ORDER BY tax_percent DESC;

---- Which customer type pays the most in VAT?
SELECT customer_type, AVG(VAT) AS VAT
FROM sales
GROUP BY customer_type
ORDER BY VAT DESC;

------- Customers
---- How many unique customer types does the data have?
SELECT DISTINCT customer_type
FROM sales;

---- How many unique payment methods does the data have?
SELECT DISTINCT payment_method
FROM sales;

---- What is the most common customer type?
SELECT customer_type, COUNT(customer_type) num_customer
FROM sales
GROUP BY customer_type
ORDER BY num_customer DESC;

---- Which customer type buys the most?
SELECT customer_type, sum(quantity) as qty_buy
FROM sales
GROUP BY customer_type
ORDER BY qty_buy DESC;

---- What is the gender of most of the customers?
SELECT gender, COUNT(*) AS num_gender
FROM sales
GROUP BY gender
ORDER BY num_gender DESC;

---- What is the gender distribution per branch?
SELECT branch, gender, count(gender) AS num_gender
FROM sales
WHERE gender = 'male'
GROUP BY branch, gender;

---- Which day fo the week has the best avg ratings?
SELECT day_name, AVG(rating) AS avg_rating
FROM sales
GROUP BY day_name
ORDER BY avg_rating DESC;

---- Which day of the week has the best average ratings per branch?
SELECT day_name, branch, AVG(rating) AS avg_rating
FROM sales
WHERE branch = 'A'
GROUP BY day_name, branch
ORDER BY avg_rating;




