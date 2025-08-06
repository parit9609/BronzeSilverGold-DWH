/*
===============================================================
Customer Report
===============================================================
Purpose:
 - This report consolidates key customer metrics and behaviors

Highlights:
1. Gathers essential fields such as names, ages, and transaction details.
2. Segments customers into categories (VIP, Regular, New) and age groups.
3. Aggregates customer-level metrics:
   - total orders
   - total sales
   - total quantity purchased
   - total products
   - lifespan (in months)
4. Calculates valuable KPIs:
   - recency (months since last order)
   - average order value
   - average monthly spend
===============================================================
*/

create view Gold.CUSTOMER_REPORT AS 

with customer_essential as (
SELECT
    f.order_number,
    f.product_key,
    f.order_date,
    f.sales_amount,
    f.quantity,
    c.customer_key,
    c.customer_number,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    DATEDIFF(year, CAST(c.birthdate AS DATE), GETDATE()) AS age
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_customer AS c
    ON c.customer_key = f.customer_key
where order_date is not null and  c.birthdate!='N\A')

, customer_aggregate as (
Select
customer_key,
customer_number,
customer_name,
age,
count(distinct order_number)  as total_order,
sum(sales_amount) as total_sales,
count(quantity) as total_quantity,
count(distinct product_key) as total_purchase,
max(order_date) as latest_order_date,
datediff(month,min(order_date),max(order_date)) as lifespan
from customer_essential 
group by 
customer_key,
customer_number,
customer_name,
age)

select
customer_key,
customer_number,
customer_name,
age,
total_order,
total_sales,
total_quantity,
total_purchase,
lifespan,
latest_order_date,
case when lifespan>=12 and total_sales>=5000 then 'VIP'
	 WHEN lifespan>=12 and total_sales<=5000 then 'REGULAR'
	 ELSE 'NEW'
END CATEGORIES,
case when age between 11 and 19 then 'Age 11-19'
	 when age between 20 and 29 then 'Age 20-29'
	 when age between 30 and 39 then 'Age 30-39'
	 when age between 40 and 49 then 'Age 40-49'
	 else 'Above 50'
end age_analysis,
DATEDIFF(MONTH,latest_order_date,getdate()) as recencey,
total_sales/total_order as average_order_value,
case when lifespan=0 then total_sales
	 else total_sales/lifespan
end as average_monthly_spend
from customer_aggregate


SELECT*
FROM Gold.CUSTOMER_REPORT
