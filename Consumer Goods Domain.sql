SELECT *
FROM  `dim_customer`;
DESCRIBE `dim_customer`;
SELECT *
FROM `dim_product`;

SELECT *
FROM `fact_gross_price`;

SELECT * 
FROM `fact_manufacturing_cost`;

SELECT * 
FROM `fact_pre_invoice_deductions`;

SELECT *
FROM `fact_sales_monthly`;

/*Question One
Provide the list of markets in which customer "Atliq Exclusive" operates its business in the APAC region.*/

SELECT market
FROM `dim_customer`
WHERE customer='Atliq Exclusive' 
AND region ='APAC'
GROUP BY market;

/*Question Two
. What is the percentage of unique product increase in 2021 vs. 2020?
 The final output contains these fields, unique_products_2020 unique_products_2021 percentage_chg*/
SELECT
COUNT(DISTINCT CASE WHEN fiscal_year = 2020 THEN product_code END) AS unique_products_2020,
COUNT(DISTINCT CASE WHEN fiscal_year = 2021 THEN product_code END) AS unique_products_2021,
(COUNT(DISTINCT CASE WHEN fiscal_year = 2021 THEN product_code END) - COUNT(DISTINCT CASE WHEN fiscal_year = 2020 THEN product_code END)) / COUNT(DISTINCT CASE WHEN fiscal_year = 2020 THEN product_code END) * 100 AS percentage_chg
FROM `fact_sales_monthly`;

/* Question 3
Provide a report with all the unique product counts for each segment and sort them in descending order of product counts.
 The final output contains 2 fields, segment product_count*/
 
SELECT 
DISTINCT COUNT(product_code) AS product_count,
segment
FROM `dim_product`
GROUP BY segment
ORDER BY product_count DESC;

/* Question 4
Follow-up: Which segment had the most increase in unique products in 2021 vs 2020? 
The final output contains these fields, segment product_count_2020 product_count_2021 difference*/

SELECT 
segment,
COUNT(DISTINCT CASE WHEN fiscal_year = 2020 THEN dim_product.product_code END) AS product_count_2020,
COUNT(DISTINCT CASE WHEN fiscal_year = 2021 THEN dim_product.product_code END) AS product_count_2021,
(COUNT(DISTINCT CASE WHEN fiscal_year = 2021 THEN dim_product.product_code END) - COUNT(DISTINCT CASE WHEN fiscal_year = 2020 THEN dim_product.product_code END))  AS difference
FROM `dim_product` AS dim_product
INNER JOIN `fact_sales_monthly` AS fact_sales
ON dim_product.product_code=fact_sales.product_code
GROUP BY segment
ORDER BY difference DESC;

/* Question 5
Get the products that have the highest and lowest manufacturing costs. 
The final output should contain these fields, product_code product manufacturing_cost*/
SELECT
dim_product.product_code,
dim_product.product,
fact_manufacture.manufacturing_cost
FROM `dim_product` AS dim_product
INNER JOIN `fact_manufacturing_cost` AS fact_manufacture
ON dim_product.product_code = fact_manufacture.product_code
WHERE
fact_manufacture.manufacturing_cost = (
SELECT MAX(manufacturing_cost) FROM `fact_manufacturing_cost`
)
OR fact_manufacture.manufacturing_cost = (
SELECT MIN(manufacturing_cost) FROM `fact_manufacturing_cost`
)
GROUP BY
dim_product.product_code,
dim_product.product,
fact_manufacture.manufacturing_cost
ORDER BY
fact_manufacture.manufacturing_cost DESC;

/* Question 6
Generate a report which contains the top 5 customers who received an average high pre_invoice_discount_pct for the fiscal year 2021 and in the Indian market.
The final output contains these fields, customer_code customer average_discount_percentage*/

SELECT
dim_customer.customer_code,
dim_customer.customer,
round(AVG(fact_pre_invoice.pre_invoice_discount_pct),2) AS average_discount_percentage
FROM `dim_customer` AS dim_customer
INNER JOIN `fact_pre_invoice_deductions` AS fact_pre_invoice
ON dim_customer.customer_code=fact_pre_invoice.customer_code
WHERE 
fact_pre_invoice.fiscal_year=2021
AND dim_customer.market='India'
GROUP BY 
dim_customer.customer_code,
dim_customer.customer
ORDER BY average_discount_percentage DESC
LIMIT 5;

/*Question 7
Get the complete report of the Gross sales amount for the customer “Atliq Exclusive” for each month. 
This analysis helps to get an idea of low and high-performing months and take strategic decisions.
The final report contains these columns: Month Year Gross sales Amount*/
-- Gross sales Amount = gross_price * sold_quantity

SELECT 
extract( month from fact_sales.date) AS month,
extract( year from fact_sales.date) AS year,
round(SUM(fact_gross.gross_price * fact_sales.sold_quantity),2) AS Gross_sales_amount
FROM `fact_sales_monthly` AS fact_sales
INNER JOIN `fact_gross_price` AS fact_gross
ON fact_sales.fiscal_year=fact_gross.fiscal_year
AND fact_sales.product_code=fact_gross.product_code
INNER JOIN `dim_customer` AS dim_customer
ON fact_sales.customer_code=dim_customer.customer_code
WHERE dim_customer.customer='Atliq Exclusive'
GROUP BY
month,
year;

/* Question 8
In which quarter of 2020, got the maximum total_sold_quantity? 
The final output contains these fields sorted by the total_sold_quantity, Quarter total_sold_quantity*/
SELECT
QUARTER(DATE_SUB(date, INTERVAL 9 MONTH)) AS quarter,
SUM(sold_quantity) AS total_sold_quantity
FROM `fact_sales_monthly`
WHERE fiscal_year = 2020
GROUP BY quarter
ORDER BY total_sold_quantity DESC;
/*the QUARTER() function is used to derive the quarter from the date column. Since the fiscal year for Atliq Hardware starts from September, 
we need to subtract 9 months from the date to align it with the calendar year*/

/* Question 9
Which channel helped to bring more gross sales in the fiscal year 2021 and the percentage of contribution? 
The final output contains these fields, channel gross_sales_mln percentage*/
-- gross_sales_mln = gross_price * sold_quantity

WITH channel_sales AS(
SELECT 
dim_customer.channel,
round(SUM(fact_gross.gross_price * fact_sales.sold_quantity),2) AS gross_sales_mln
FROM `fact_sales_monthly` AS fact_sales
INNER JOIN `fact_gross_price` AS fact_gross
ON fact_sales.fiscal_year=fact_gross.fiscal_year
AND fact_sales.product_code=fact_gross.product_code
INNER JOIN `dim_customer` AS dim_customer
ON fact_sales.customer_code=dim_customer.customer_code
WHERE fact_sales.fiscal_year=2021
GROUP BY
dim_customer.channel
)
SELECT 
channel,
gross_sales_mln,
gross_sales_mln / (SELECT SUM(gross_sales_mln) FROM channel_sales) *100 AS percentage
FROM channel_sales
WHERE gross_sales_mln = (SELECT MAX(gross_sales_mln) FROM channel_sales)
;

/* Question 10
Get the Top 3 products in each division that have a high total_sold_quantity in the fiscal_year 2021?
The final output contains these fields, division product_code product total_sold_quantity rank_order*/

WITH division_sales AS(
SELECT
dim_product.division,
dim_product.product_code,
dim_product.product,
SUM(fact_sales.sold_quantity) AS total_sold_quantity,
RANK() OVER( PARTITION BY division ORDER BY SUM(fact_sales.sold_quantity) DESC) AS rank_order
FROM `dim_product` AS dim_product
INNER JOIN `fact_sales_monthly` AS fact_sales
ON dim_product.product_code=fact_sales.product_code
WHERE
fact_sales.fiscal_year=2021
GROUP BY 
dim_product.division,
dim_product.product_code,
dim_product.product
)
SELECT 
division,
product_code,
product,
total_sold_quantity,
rank_order
FROM division_sales
WHERE rank_order <=3 
GROUP BY 
division,
product_code,
product ;