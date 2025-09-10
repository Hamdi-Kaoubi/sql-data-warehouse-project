--general review about gold.dim_customers view:
select *
from gold.dim_customers;

--check data standarization and consistency:
select distinct gender from gold.dim_customers;


--foreign key integrity (dimentions)
select *
from gold.fact_sales f
left join gold.dim_customers c
on c.customer_key = f.customer_key
where c.customer_key is null;

--foreign key integrity (dimentions)
select *
from gold.fact_sales f
left join gold.dim_customers c
on c.customer_key = f.customer_key
left join gold.dim_product p 
on p.product_key = f.product_key
where p.product_key is null;
