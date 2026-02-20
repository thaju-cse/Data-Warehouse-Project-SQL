/*
================================================
Check loaded tables: Using pdadmin4 (postgresql)
================================================
Script Purpose:
    Check the loaded tables meta data like top 10 rows and count or rows.
    This script is used to conform that the correct data is loaded.
*/

select * from bronze.crm_cust_info limit 10;
select count(*) from bronze.crm_cust_info;

select * from bronze.crm_prd_info limit 10;
select count(*) from bronze.crm_prd_info;

select * from bronze.crm_sales_details limit 10;
select count(*) from bronze.crm_sales_details;


select * from bronze.erp_cust_az12 limit 10;
select count(*) from bronze.erp_cust_az12;

select * from bronze.erp_loc_a101 limit 10;
select count(*) from bronze.erp_loc_a101;

select * from  bronze.erp_px_cat_g1v2 limit 10;
select count(*) from bronze.erp_px_cat_g1v2;
