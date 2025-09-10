--====================================================
--Creating first object : CUSTOMER : in the god layer
--====================================================

create view gold.dim_customers as 
--select cst_id, count(*)  --we use this subquery to check duplicates ==> there is no duplicates
--from (
select 
	row_number() over(order by cst_id)  as customer_key, --generating surregate key
	ci.cst_id as customer_id, --in gold layer we must make colmn names more user friendly
	ci.cst_key as customer_number,
	ci.cst_firstname as first_name,
	ci.cst_lastname as last_name,
	cl.cntry as country,
	ci.cst_material_status as material_status,
	--ci.cst_gndr,
	case 
		when ci.cst_gndr != 'n/a' then ci.cst_gndr --CRM is the MASTER for gender info
		else coalesce(ca.gen, 'n/a')
	end as gender,
	--ca.gen
	ca.bdate as birthdate,
	ci.cst_craete_date as create_date
from silver.crm_cust_info ci
left join silver.erp_cust_az12 ca
on ci.cst_key = ca.cid
left join silver.erp_loc_a101 cl
on ci.cst_key = cl.cid;
--)t
--group by cst_id
--having count(*) > 1;

--====================================================
--Creating second object : PRODUCT : in the god layer
--====================================================
create view gold.dim_product as
select

	row_number() over(order by pn.prd_start_dt, pn.prd_key) as product_key,
	pn.prd_id as product_id,
	pn.prd_key as product_number,
	pn.prd_nm as product_name,
	pn.cat_id as category_id,
	pc.cat as category,
	pc.subcat as subcategory,
	pc.maintenance,
	pn.prd_cost as product_cost,
	pn.prd_line as product_line,
	pn.prd_start_dt as start_date
	--pn.prd_end_dt --because they are all null

from silver.crm_prod_info pn
left join silver.erp_px_cat_g1v2 pc
on pn.cat_id = pc.id
where pn.prd_end_dt is null; --to get only the current products (have no end date)


--====================================================
--Creating last object : SALES : in the god layer
--====================================================
create view gold.fact_sales as
select
	sd.sls_ord_num as order_number,
	pr.product_key,
	cu.customer_key,
	sd.sls_order_dt as order_date,
	sd.sls_ship_dt as shipping_date,
	sd.sls_due_dt as due_date,
	sd.sls_sales as sales_amount,
	sd.sls_quantity as quantity,
	sd.sls_price as price
from silver.crm_sales_details sd
left join gold.dim_product pr
on sd.sls_prd_key = pr.product_number
left join gold.dim_customers cu
on sd.sls_cust_id = cu.customer_id;
