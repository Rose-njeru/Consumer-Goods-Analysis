# Consumer-Goods-Analysis
Conducting Analysis in SQL  to represent to executive management in the consumer goods domain on the performance of the store.

## The Tables
1. dim_customer: contains customer-related data
2. dim_product: contains product-related data
3. fact_gross_price: contains gross price information for each product
4. fact_manufacturing_cost: contains the cost incurred in the production of each product
5. fact_pre_invoice_deductions: contains pre-invoice deductions information for each product
6. fact_sales_monthly: contains monthly sales data for each product.

**Column Description for dim_customer table**
+ customer_code: The 'customer_code' column features unique identification codes for every customer in the dataset. These codes can be used to track a customer's sales history, demographic information, and other relevant details.
+ customer: The 'customer' column lists the names of customers.
+ platform: The 'platform' column identifies the means by which a company's products or services are sold. "Brick & Mortar" represents the physical store/location, and "E-Commerce" represents online platforms.
+ channel: The 'channel' column reflects the distribution methods used to sell a product. These methods include "Retailers", "Direct", and "Distributors". Retailers 				refer to physical or online stores that sell products to consumers. Direct sales refer to sales made directly to consumers through a company's website or other direct means, and distributors refer to intermediaries or middlemen between the manufacturer and retailer or end consumers.
+  market: The 'market' column lists the countries in which the customer is located.
+ region: The 'region' column categorizes countries according to their geographic location, including "APAC" (Asia Pacific), "EU" (Europe), "NA" (North America), and  "LATAM" (Latin America).
+ sub_zone: "The 'sub_zone' column further breaks down the regions into sub-regions, such as "India", "ROA" (Rest of Asia), "ANZ" (Australia and New Zealand), "SE"  Southeast Asia), "NE" (Northeast Asia), "NA" (North America), and "LATAM" (Latin America)."

**Column Description for dim_product table**
+ product_code: The 'product_code' column features unique identification codes for each product, serving as a means to track and distinguish individual products within a database or system.
+ division: The 'division' column categorizes products into groups such as "P & A" (Peripherals and Accessories), "N & S" (Network and Storage) and "PC" (Personal Computer).
+ segment: The 'segment' column categorizes products further within the division, such as "Peripherals" (keyboard, mouse, monitor, etc.), "Accessories" (cases, cooling solutions, power supplies), "Notebook" (laptops), "Desktop" (desktops, all-in-one PCs, etc), "Storage" (hard disks, SSDs, external storage), and "Networking" (routers, switches, modems, etc.).
+ category: The 'category' column classifies products into specific subcategories within the segment.
+ product: The 'product' column lists the names of individual products, corresponding to the unique identification codes found in the 'product_code' column.
+ variant: The "variant" column classifies products according to their features, prices, and other characteristics. The column includes variants such as "Standard", "Plus", "Premium" that represent different versions of the same product.

**Column Description for fact_gross_price table**
+ product_code: The 'product_code' column features unique identification codes for each product.
+ fiscal_year: The 'fiscal_year' column contains the fiscal period in which the product sale was recorded. A fiscal year is a 12-month period that is used for accounting purposes and often differs from the calendar year. For Atliq Hardware, the fiscal year starts in September. The data available in this column covers the 	fiscal years 2020 and 2021.
+ gross_price: The 'gross_price' column holds the initial price of a product, prior to any reductions or taxes. It is the original selling price of the product.

**Column Description for fact_manufacturing_cost**
+ product_code: The 'product_code' column features unique identification codes for each product
+ cost_year: The "cost_year" column contains the fiscal year in which the product was manufactured.
+ manufacturing_cost: The "manufacturing_cost" column contains the total cost incurred for the production of a product. This cost includes direct costs like raw materials, labor, and overhead expenses that are directly associated with the production process.

**Column Description for fact_pre_invoice_deductions**
+ customer_code: The 'customer_code' column features unique identification codes for every customer in the dataset. These codes can be used to track a customer's sales history, demographic information, and other relevant details. For example, the codes could look like '70002017', '90005160', and '80007195' respectively.
+ fiscal_year: The "fiscal_year" column holds the fiscal period when the sale of a product occurred.
+ pre_invoice_discount_pct: The "pre_invoice_discount_pct" column contains the percentage of pre-invoice deductions for each product. Pre-invoice deductions are discounts that are applied to the gross price of a product before the invoice is generated, and typically applied to large orders or long-term contracts.

**Column Description for fact_sales_monthly**
+ date: The "date" column contains the date when the sale of a product was made, in a monthly format for 2020 and 2021 fiscal years. This information can be used to understand the sales performance of products over time.
+ product_code: The "product_code" column contains a unique identification code for each product. This code is used to track and differentiate individual products within a database or system.
+ customer_code: The 'customer_code' column features unique identification codes for every customer in the dataset. These codes can be used to track a customer's sales history, demographic information, and other relevant details. For example, the codes could look like '70002017', '90005160', and '80007195' respectively.
+ sold_quantity: The "sold_quantity" column contains the number of units of a product that were sold. This information can be used to understand the sales volume ofproducts and to compare the sales volume of different products or variants.
+ fiscal_year: The "fiscal_year" column holds the fiscal period when the sale of a product occurred.

## Data Cleaning 
There  were no inconsistencies in the data.
## Data Analysis
The analysis was based on the questions provided,and observations noted

**Question One**

Provide the list of markets in which customer "Atliq Exclusive" operates its business in the APAC region.
```sql
SELECT market
FROM `dim_customer`
WHERE customer='Atliq Exclusive' 
AND region ='APAC'
GROUP BY market;
```

![image](https://github.com/Rose-njeru/Consumer-Goods-Analysis/assets/92436079/73e7192c-a7c9-438e-bb64-7ecb2d97d377)

~ Customer Atliq Exclusive operates in 7 countries in the  Asia Pacific.

**Question Two**

What is the percentage of unique product increase in 2021 vs. 2020? The final output contains these fields, unique_products_2020 unique_products_2021 percentage_chg*/
```sql
SELECT
COUNT(DISTINCT CASE WHEN fiscal_year = 2020 THEN product_code END) AS unique_products_2020,
COUNT(DISTINCT CASE WHEN fiscal_year = 2021 THEN product_code END) AS unique_products_2021,
(COUNT(DISTINCT CASE WHEN fiscal_year = 2021 THEN product_code END) - COUNT(DISTINCT CASE WHEN fiscal_year = 2020 THEN product_code END)) / COUNT(DISTINCT CASE WHEN fiscal_year = 2020 THEN product_code END) * 100 AS percentage_chg
FROM `fact_sales_monthly`;
```
![image](https://github.com/Rose-njeru/Consumer-Goods-Analysis/assets/92436079/ec1cc8e7-8c6c-4b14-97c1-f79283aacecf)

~ The total percentage change in the sales of products between 20121 and 2020 is 36.33%.

**Question Three**

Provide a report with all the unique product counts for each segment and sort them in descending order of product counts.
The final output contains 2 fields, segment product_count*/
``` sql
SELECT 
DISTINCT COUNT(product_code) AS product_count,
segment
FROM `dim_product`
GROUP BY segment
ORDER BY product_count DESC;
```

![image](https://github.com/Rose-njeru/Consumer-Goods-Analysis/assets/92436079/5a585b4e-6f82-46fe-aa72-e6e4d7c2bdc9)

~ The Notebook segment had a high unique product count  of 129 followed by Accessories with a count of 116.Networking had the least count of only 9 products.

**Question Four**

Follow-up from Question 3:Which segment had the most increase in unique products in 2021 vs 2020? 
The final output contains these fields, segment product_count_2020 product_count_2021 difference*/
``` sql
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
```

![image](https://github.com/Rose-njeru/Consumer-Goods-Analysis/assets/92436079/892d25bc-86f5-4ab4-9778-728768dcef8e)

~ The Accessories segment had the highest increase between 2021 and 2020  fiscal years by registering a product sale diffrece of 34.

**Question Five**

Get the products that have the highest and lowest manufacturing costs. 
The final output should contain these fields, product_code product manufacturing_cost*/
```sql
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
```

![image](https://github.com/Rose-njeru/Consumer-Goods-Analysis/assets/92436079/cae386f2-6ba7-4ab4-ae67-85a4d6b4ea8f)

~ AQ HOME Allin1 Gen 2 had the highest manufacturing cost of 240.5364 while AQ Master wired x1 Ms had the least manufacturing cost of 0.892.

**Question Six**

Generate a report which contains the top 5 customers who received an average high pre_invoice_discount_pct for the fiscal year 2021 and in the Indian market.
The final output contains these fields, customer_code customer average_discount_percentage*/
``` sql
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
```

![image](https://github.com/Rose-njeru/Consumer-Goods-Analysis/assets/92436079/09ab3263-713e-48ee-9d83-45d003c39bb5)

~ Flipkart customer received has the highest average discount of 31%,Viveks,Croma,Ezone received an average discount of 30% while Amazon received 29% discount.

**Question Seven**

Get the complete report of the Gross sales amount for the customer “Atliq Exclusive” for each month. 
This analysis helps to get an idea of low and high-performing months and take strategic decisions.
The final report contains these columns: Month Year Gross sales Amount*/
-- Gross sales Amount = gross_price * sold_quantity
``` sql
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
```

![image](https://github.com/Rose-njeru/Consumer-Goods-Analysis/assets/92436079/76e5fe50-82e1-4d24-9b01-92208a0c0671)

![image](https://github.com/Rose-njeru/Consumer-Goods-Analysis/assets/92436079/c550bede-f9bc-4223-9c0f-4ec7f5b83415)

~ 
