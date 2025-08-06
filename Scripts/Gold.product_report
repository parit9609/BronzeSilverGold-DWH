/*===============================================================
Product Report
===============================================================

Purpose:
 - This report consolidates key product metrics and behaviors.

Highlights:
1. Gathers essential fields such as product name, category, subcategory, and cost.
2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
3. Aggregates product-level metrics:
   - total orders
   - total sales
   - total quantity sold
   - total customers (unique)
   - lifespan (in months)
4. Calculates valuable KPIs:
   - recency (months since last sale)
   - average order revenue (AOR)
   - average monthly revenue
===============================================================*/


CREATE VIEW GOLD.PRODUCT_REPORT AS 

with base_query as (

--Gathers essential fields such as product name, category, subcategory, and cost.
SELECT
f.order_number ,
f.customer_key,
f.order_date,
f.sales_amount,
f.quantity,
p.product_key,
p.product_name,
p.category,
p.subcategory,
p.product_cost
FROM GOLD.fact_sales AS f
LEFT JOIN GOLD.dim_product AS p
ON f.product_key=p.product_key
where order_date is not null
)

, Aggregates_product_level as (
select
/*Aggregates product-level metrics:
   - total orders
   - total sales
   - total quantity sold
   - total customers (unique)
   - lifespan (in months)*/
product_key,
product_name,
category,
subcategory,
product_cost,
count(order_number) as total_order,
sum(sales_amount) aS total_sales,
count(quantity) as total_quantity,
count(distinct customer_key) as total_customer,
datediff(month,min(order_date),max(order_date) ) as lifespan,
max(order_date) as last_order_date
from base_query
group by product_key,
product_name,
category,
subcategory,
product_cost
)

--Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
select
product_key,
product_name,
category,
subcategory,
product_cost,
DATEDIFF(MONTH,last_order_date,GETDATE()) AS RECENCY_MONTH,--RECENCY IN MONTHS
case when total_sales >50000 then 'HIGH-PERFORMER'
	 when total_sales >=1000 then 'MID RANGE-PERFORMER'
	 ELSE 'Low-Performer'
END AS PERFOMANCE,
total_customer,
total_order,
total_quantity,
total_sales,
lifespan,
last_order_date,
--AVERAGE ORDER REVENUE
CASE WHEN total_sales= 0 then 0
else total_sales/total_order
end AOR,

--AVERGAE MONTHLY REVENUE
CASE WHEN lifespan=0 then total_sales
	 else total_sales/lifespan
end MOR


from Aggregates_product_level



SELECT*
FROM GOLD.PRODUCT_REPORT
