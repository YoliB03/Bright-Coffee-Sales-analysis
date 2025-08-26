SELECT*
FROM SALE.PUBLIC.COFFEE_SALES
LIMIT 10;


SELECT MIN(transaction_time) AS opening_time
FROM SALE.PUBLIC.COFFEE_SALES;

SELECT MAX(transaction_time) AS closing_time
FROM SALE.PUBLIC.COFFEE_SALES;

SELECT
    
    --Dates
    DAYNAME(TO_DATE(transaction_date)) AS day_name,
    MONTHNAME(TO_DATE(transaction_date)) AS Month_name,
    TO_CHAR(TO_DATE(transaction_date),'YYYYMM') AS month_id,


    SUM(unit_price) AS total_units_sold,
    ROUND(
        (SUM(unit_price) * 100.0 / SUM(SUM(unit_price)) OVER ()),
        2
    ) AS pct_of_total,

CASE
    WHEN transaction_time between '06:00:00' AND '11:59:59' THEN 'Morning'
    WHEN transaction_time between '12:00:00' AND '16:59:59' THEN 'Afternoon'
    WHEN transaction_time between '17:00:00' AND '19:59:59' THEN 'Evening'
    ELSE 'Night'
    END AS time_bucket,

CASE
    WHEN day_name NOT IN ('Sat','Sun') THEN 'Weekday'
    ELSE 'Weekend'
    END AS day_category,

    ROUND (SUM(IFNULL(transaction_qty,0)*IFNULL(unit_price,0)),0) AS total_amount,
    
    --Counts
    COUNT(DISTINCT transaction_id) AS number_of_sales,
    COUNT(DISTINCT product_id) AS number_of_unique_products,
    COUNT(DISTINCT store_id) AS number_of_shops,

    ---Categories
    store_location,
    product_type,
    product_detail,
    product_category

FROM SALE.PUBLIC.COFFEE_SALES
GROUP BY ALL;
    
