/*
===============================================================================
Quality Checks
===============================================================================
Script Purpose:
    This script performs various quality checks for data consistency, accuracy, 
    and standardization across the 'silver' layer. It includes checks for:
    - Null or duplicate primary keys.
    - Unwanted spaces in string fields.
    - Data standardization and consistency.
    - Invalid date ranges and orders.
    - Data consistency between related fields.

Usage Notes:
    - Run these checks after data loading Silver Layer.
    - Investigate and resolve any discrepancies found during the checks.
===============================================================================
*/



--==============================
--check quality for silver layer:
--==============================

--************************************
--check for silver.crm_cust_info Table
--************************************

--check for nulls or duplicates in Primary Key
--Expectation: no result

select 
	cst_id,
	count(*) as pk_counter
from silver.crm_cust_info
group by cst_id
having count(*) > 1 or cst_id is null;

--Result: we removed duplicates and null ids.

--check the white spaces (unwanted spaces) in strings (names, last names, etc ...):

select 
	cst_firstname,
	cst_lastname
from silver.crm_cust_info
where cst_firstname != trim(cst_firstname) or cst_lastname != trim(cst_lastname);

--Result: good: there is no unwanted spaces

--check for gender field: we want them to be full Female/Male not just F or M and remove NULL values
select distinct cst_gndr
from silver.crm_cust_info;
--result: good, just as we need


--general check
select *
from silver.crm_cust_info;



--************************************
--check for silver.crm_prod_info Table
--************************************

--check for primary key
--expectation: no duplicates, no nulls
select 
	prd_id,
	count(*) 
from silver.crm_prod_info
group by prd_id
having count(*) > 1 or prd_id is null;
--result: everything is good


--check for unwanted spaces in prd_nm:
--expectation: no result
select
	prd_nm
from silver.crm_prod_info
where prd_nm != trim(prd_nm);
--result: every thing is good


--check for nulls or negative values in prd_cost
select 
	prd_cost
from silver.crm_prod_info
where prd_cost < 0 or prd_cost is null;
--result: no nulls and no negatives ==> good


--Data standarization & consistency:
select distinct
	prd_line
from silver.crm_prod_info
--everything is good and reading friendly


--check invalide date Order:
select *
from silver.crm_prod_info
where prd_end_dt < prd_start_dt;
--result: good



--check all the table:
select * from silver.crm_prod_info;



--****************************************
--check for silver.crm_sales_details Table
--****************************************
--chek for invalid Dates Ordering:
select *
from silver.crm_sales_details
where sls_order_dt > sls_ship_dt or sls_order_dt > sls_due_dt;
--everything is good

--check data consistency between: Sales, Quantity and Price
-- Sales = Quantity x Price
-- Values must not be null, zero or negatives
select distinct
	sls_sales,
	sls_quantity,
	sls_price
from silver.crm_sales_details
where sls_sales != sls_quantity * sls_price
or sls_sales is null or sls_quantity is null or sls_price is null
or sls_sales <= 0 or sls_quantity <= 0 or sls_price <= 0
order by sls_sales, sls_quantity, sls_price;




--****************************************
--check for silver.erp_cust_az12 Table
--****************************************
--Identify out of range Dates:
select 
	bdate
from silver.erp_cust_az12
where bdate > getdate();

--data standarization and consistency:
select distinct 
	gen
from silver.erp_cust_az12;



--****************************************
--check for silver.erp_loc_a101 Table
--****************************************
--data standarization and consistency:
select distinct
	cntry
from silver.erp_loc_a101
order by cntry;
