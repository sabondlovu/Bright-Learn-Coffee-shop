
--To have a full view of how our data looks, this helps us determine which columns we have and which ones we need to create for our data analysis.

SELECT *
 FROM workspace.default.bright_coffee_shop;
---For better undertsanding our data we need to know when the data was collected and for how long. This helps decide if the data is enough for the analysis and better results.
SELECT MIN(transaction_date) AS Earliest_Date 
    FROM workspace.default.bright_coffee_shop;


 --- Same code as above, just a bit more detailed, gives us the start and end date of our and days of collection.
SELECT 
    MIN(transaction_date) AS start_date, 
    MAX(transaction_date) AS end_date,
    DATEDIFF(MAX(transaction_date), MIN(transaction_date)) AS total_days_of_data
FROM workspace.default.bright_coffee_shop;
------------------------------------------------------------------------------------------------------
---- This is to calculate the total revenue generated across the entire entity

SELECT SUM(transaction_qty * unit_price) AS Total_Revenue 
FROM workspace.default.bright_coffee_shop;

---Checking names of different coffee shops and counting the store numbers 
SELECT DISTINCT store_location
FROM workspace.default.bright_coffee_shop;

SELECT count(store_id) AS number_of_stores
FROM bright_coffee_shop;

--- This is to see the top most performing ning products in the bright learn coffee shop and group by product 
SELECT product_detail,SUM(transaction_qty) AS total_qty
   FROM bright_coffee_shop
   GROUP BY product_detail 
   ORDER BY total_qty DESC 
LIMIT 10;

--- This code is to show us the least expensive item and the most important item 
SELECT
     MIN(unit_price) AS lowest_price,
     MAX(unit_price) AS highest_price
FROM bright_coffee_shop;

-----Showing revenue per product sold at the coffee shop, the one that contributes most to the revenue 
SELECT product_detail,SUM(transaction_qty * unit_price) AS total_revenue
    FROM bright_coffee_shop
    GROUP BY product_detail
ORDER BY total_revenue DESC;

----We are now comparing revenue across all the stores to see which store is the most profitable 

SELECT store_location,SUM(transaction_qty * unit_price) AS total_revenue
    FROM bright_coffee_shop
    GROUP BY store_location
ORDER BY total_revenue DESC;  

--Calculates the average amount spent per transaction
SELECT AVG(transaction_qty * unit_price) AS Avg_Revenue_Per_Transaction
FROM bright_coffee_shop;

---- This code is to group the data by hour and count the number of transactions in each hour, which helps us see when we make a lot of sales 
SELECT 
    SUBSTR(transaction_time, 1, 2) AS peak_hour,
    COUNT(transaction_id) AS total_transactions
    FROM bright_coffee_shop
    GROUP BY peak_hour
     ORDER BY total_transactions DESC
LIMIT 1;
--------- DATES
SELECT transaction_date,
DAYNAME(transaction_date) AS Day_Name,
Monthname(transaction_date) AS Month_name
FROM workspace.default.bright_coffee_shop;

-----------------------------------------------------------------------------
--This code is to show us the big data table for our manipulation and getting the information we need to present. In this code, we will be able to do our data manipulation and get the information we need for our analysis and visualization.

SELECT 
   transaction_id,
   transaction_date,
   transaction_time,
   transaction_qty,
   store_id,
   store_location,
   product_id,
   unit_price,
   product_category,
   product_type,
   product_detail,
---Adding columns to enhance our table
Dayname(transaction_date) AS Day_Name,
Monthname(transaction_date) AS Month_name,
dayofmonth(transaction_date) AS Day, 

CASE 
   WHEN Dayname(transaction_date) = 'Sat' THEN 'Weekend'
   WHEN Dayname(transaction_date) = 'Sun' THEN 'Weekend'
   ELSE 'Weekday'
END AS Day_Type,

---- Time buckets 
CASE 
     WHEN Date_format(transaction_time, 'HH:MM:SS') BETWEEN '06:00:00' AND '08:59:59' THEN '01.Peak hour'
     WHEN Date_format(transaction_time, 'HH:MM:SS') BETWEEN '09:00:00' AND '11:59:59' THEN '02.Mid morning'
     WHEN Date_format(transaction_time, 'HH:MM:SS') BETWEEN '12:00:00' AND '14:59:59' THEN '03.Lunch hour'
     WHEN Date_format(transaction_time, 'HH:MM:SS') BETWEEN '15:00:00' AND '17:59:59' THEN '04.Afternoon'

     ELSE '05.Evening'
END AS Day_Classification,


---- This code is to determine the biggest spenders and at what time 
CASE 
 WHEN (transaction_qty * unit_price) > 100 THEN '01.Highest spenders'
 WHEN (transaction_qty * unit_price) BETWEEN 50 AND 100 THEN '02.Medium spenders'
   ELSE '03.Lowest spenders'
END AS Spend_buckets,

--Adding revenvue column 
transaction_qty * unit_price AS Revenue
FROM workspace.default.bright_coffee_shop;
--
