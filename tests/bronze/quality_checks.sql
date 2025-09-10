--check quality for bronze layer:
--check for nulls or duplicates in Primary Key
--Expectation: no result

select 
	cst_id,
	count(*) as pk_counter
from bronze.crm_cust_info
group by cst_id
having count(*) > 1 or cst_id is null;

--Result: we get duplicates and nulls in some primary keys.

--Solution to Remove Duplicates: 
--select
--*
--from (
--select 
--	*,
--	row_number() over (partition by cst_id order by cst_craete_date desc) as flag_last
--from bronze.crm_cust_info
--)t where flag_last = 1;


--check the white spaces (unwanted spaces) in strings (names, last names, etc ...):

select 
	cst_firstname,
	cst_lastname
from bronze.crm_cust_info
where cst_firstname != trim(cst_firstname) or cst_lastname != trim(cst_lastname);

--Result: we have some unwated spaces in these two fields so we must correct this issue in the tables
--solution:

--select
--	cst_id,
--	cst_key,
--	trim(cst_firstname) as cst_firstname,
--	trim(cst_lastname) as cst_lastname,
--	cst_material_status,
--	cst_gndr,
--	cst_craete_date
--from (
--select 
--	*,
--	row_number() over (partition by cst_id order by cst_craete_date desc) as flag_last
--from bronze.crm_cust_info
--)t where flag_last = 1;

--check for gender field: we want them to be full Female/Male not just F or M and remove NULL values
select distinct cst_gndr
from bronze.crm_cust_info;

--Now solution to Make gender field Female/Male and n/a for null values:
--we did the same for cst_material_status field: changing S/M/NULL by Single/Married/n/a
--select
--	cst_id,
--	cst_key,
--	trim(cst_firstname) as cst_firstname,
--	trim(cst_lastname) as cst_lastname,
--	case
--		when upper(trim(cst_material_status)) = 'S' then 'Single'
--		when upper(trim(cst_material_status)) = 'M' then 'Married'
--		else 'n/a'
--	end cst_material_status,
--	case
--		when upper(trim(cst_gndr)) = 'M' then 'Male'
--		when upper(trim(cst_gndr)) = 'F' then 'Female'
--		else 'n/a'
--	end cst_gndr,
--	cst_craete_date
--from (
--select 
--	*,
--	row_number() over (partition by cst_id order by cst_craete_date desc) as flag_last
--from bronze.crm_cust_info
--)t where flag_last = 1;



--===================================================
--Now Cheking quality for bronze.crm_prod_info Table:
--===================================================
--check for nulls or duplicate keys in primary key
--Expectation: No Result
select
	prd_id,
	count(*) as prd_count
from bronze.crm_prod_info
group by prd_id
having count(*) > 1 or prd_id is null;
--result: good, there is no duplicates or nulls

--check unwanted spaces in prd_nm:
select
	prd_nm
from bronze.crm_prod_info
where prd_nm != trim(prd_nm);
--result: good, there is no unwanted spaces

--check nulls or negative numbers in prd_cost:
--expectation: no result
select
	prd_cost
from bronze.crm_prod_info
where prd_cost < 0 or prd_cost is null;
--result: we have to nulls, so we fix that using ISNULL(oldValue, newValue) function

--Data standarization & consistency:
select distinct
	prd_line
from bronze.crm_prod_info;
--result: we get null,M,R,S and T and we must change them with full words and change nulls with n/a

--check for Invalid Date Orders:
select 
	*
from bronze.crm_prod_info
where prd_end_dt < prd_start_dt;
--expectation: No result
--result: we have rows where end date is less than start date which makes no sense.




--======================================================
--Now Cheking quality for bronze.crm_sales_details Table:
--======================================================

--check for unwanted spaces in sls_ord_num:
select
	sls_ord_num
from bronze.crm_sales_details
where sls_ord_num != trim(sls_ord_num);
--result: there is no unwanted spaces ==> good


--check the existance of the customer id in bronze.crm_cust_info Table:
select *
from bronze.crm_sales_details
where sls_cust_id not in (select cst_id from silver.crm_cust_info);
--No Result ==> everything is good



--check the existance of the product key in bronze.crm_prod_info Table:
select *
from bronze.crm_sales_details
where sls_prd_key not in (select prd_key from bronze.crm_prod_info);
--No Result ==> everything is good (in the silver layer)
--actually in bronze layer here we have values where sls_prd_key is not exist in the bronze.crm_prod_info table


--check for invalid dates:
select
	sls_order_dt
from bronze.crm_sales_details
where sls_order_dt <= 0 or len(sls_order_dt) != 8;
--we have results so we must fix this issue.


--chek for invalid Dates Ordering:
select *
from bronze.crm_sales_details
where sls_order_dt > sls_ship_dt or sls_order_dt > sls_due_dt;
--everything is good

--check data consistency between: Sales, Quantity and Price
-- Sales = Quantity x Price
-- Values must not be null, zero or negatives
select distinct
	sls_sales,
	sls_quantity,
	sls_price
from bronze.crm_sales_details
where sls_sales != sls_quantity * sls_price
or sls_sales is null or sls_quantity is null or sls_price is null
or sls_sales <= 0 or sls_quantity <= 0 or sls_price <= 0
order by sls_sales, sls_quantity, sls_price;



--======================================================
--Now Cheking quality for bronze.erp_cust_az12 Table:
--======================================================
--Identify out of range Dates:
select 
	bdate
from bronze.erp_cust_az12
where bdate < '1924-01-01' or bdate > getdate();

--data standarization and consistency:
select distinct 
	gen
from bronze.erp_cust_az12;


--======================================================
--Now Cheking quality for bronze.erp_loc_a101 Table:
--======================================================
--data standarization and consistency:
select distinct
	cntry
from bronze.erp_loc_a101
order by cntry;



--======================================================
--Now Cheking quality for bronze.erp_px_cat_g1v2 Table:
--======================================================
--checking for unwanted spaces
select *
from bronze.erp_px_cat_g1v2
where cat != trim(cat) or subcat != trim(subcat) or maintenance != trim(maintenance);
--result: there is no unwanted spaces

--data standarization and consistency:
select distinct
	--cat
	--subcat
	maintenance
from bronze.erp_px_cat_g1v2;
--result: good
