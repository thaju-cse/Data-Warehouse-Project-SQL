/*
This is a sample script how can we analyze the given data.
*/

-- ===================Table bronze.crm_cust_info=========================
select * from silver.crm_cust_info;

SELECT 
	distinct cst_marital_status
FROM silver.crm_cust_info limit 100;

SELECT 
	cst_id, 
	count(cst_id)
	
FROM silver.crm_cust_info 
group by cst_id 
having count(cst_id)>1
limit 100;

SELECT 
	cst_firstname
FROM silver.crm_cust_info 
where trim(cst_firstname) != cst_firstname
limit 100;

-- =======================Table bronze.crm_prd_info=======================

SELECT 
	prd_id, prd_key, 
	prd_nm, prd_cost, 
	prd_line, 
	prd_start_dt, 
	prd_end_dt
FROM bronze.crm_prd_info limit 100;

select prd_key, count(prd_key)
	from bronze.crm_prd_info group by prd_key having count(prd_key) > 1;

-- =======================Table bronze.crm_sales_details==================

SELECT 
	sls_ord_num, 
	sls_prd_key, 
	sls_cust_id, 
	sls_order_dt, 
	sls_ship_dt, 
	sls_due_dt, 
	sls_sales, 
	sls_quantity, 
	sls_price
FROM bronze.crm_sales_details limit 100;

-- Table bronze.erp_cust_az12

SELECT 
	cid, 
	bdate, 
	gen
FROM bronze.erp_cust_az12 limit 100;

-- Table bronze.erp_loc_a101

SELECT 
	cid, 
	cntry
FROM bronze.erp_loc_a101 limit 100;

-- Table bronze.erp_px_cat_g1v2

SELECT 
	id, 
	cat, 
	subcat, 
	maintenance
FROM bronze.erp_px_cat_g1v2 limit 100;

