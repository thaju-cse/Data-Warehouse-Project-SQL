/*
=============================================================
Create procedure to load into bronze schema: Using pdadmin4 (postgresql)
=============================================================
Script Purpose:
    This script loads data (csv files) into tables in bronze schema. 
    If any data available in the tables, it will truncate it and load the data.
	  It will load only CSV file containing data, it will handle any errors using exceptions. 
    within the database schema: 'bronze'.
	
WARNING:
    Running this script will truncate all the tables available in the bronze schema. 
    All data in the bronze schema will be permanently deleted. Proceed with caution 
    and ensure you have proper backups before running this script.
*/


create or replace procedure bronze.load_bronze ()
language plpgsql
as $$
declare
	start_time timestamp;
	end_time timestamp;

begin
	start_time := clock_timestamp();
	raise notice 'Started Loading Bronze layer.';

	raise notice '================================';
	raise notice 'Truncating bronze.crm_cust_info.';
	truncate table bronze.crm_cust_info;

	raise notice 'Started Loading bronze.crm_cust_info.';
	copy bronze.crm_cust_info(cst_id,cst_key,cst_firstname, cst_lastname, cst_marital_status, cst_gndr, cst_create_date)
	from 'E:\projects\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
	delimiter ','
	csv header;

	raise notice '================================';
	raise notice 'Truncating bronze.crm_prd_info.';
	truncate table bronze.crm_prd_info;

	raise notice 'Started Loading bronze.crm_prd_info.';	
	copy bronze.crm_prd_info(prd_id, prd_key, prd_nm, prd_cost, prd_line, prd_start_dt, prd_end_dt)
	from 'E:\projects\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
	delimiter ','
	csv header;
	
	raise notice '================================';
	raise notice 'Truncating bronze.crm_sales_details.';
	truncate table bronze.crm_sales_details;
	
	raise notice 'Started Loading bronze.crm_sales_details.';
	copy bronze.crm_sales_details(sls_ord_num, sls_prd_key, sls_cust_id, sls_order_dt, sls_ship_dt, sls_due_dt, sls_sales, sls_quantity, sls_price)
	from 'E:\projects\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
	delimiter ','
	csv header;
	
	raise notice '================================';
	raise notice 'Truncating bronze.erp_cust_az12.';
	truncate table bronze.erp_cust_az12;
	
	raise notice 'Started Loading bronze.erp_cust_az12.';
	copy bronze.erp_cust_az12(cid, bdate, gen)
	from 'E:\projects\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
	delimiter ','
	csv header;
	
	raise notice '================================';
	raise notice 'Truncating bronze.erp_loc_a101.';
	truncate table bronze.erp_loc_a101;
	
	raise notice 'Started Loading bronze.erp_loc_a101.';
	copy bronze.erp_loc_a101(cid, cntry)
	from 'E:\projects\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
	delimiter ','
	csv header;
	
	raise notice '================================';
	raise notice 'Truncating bronze.erp_px_cat_g1v2.';
	truncate table bronze.erp_px_cat_g1v2;
	
	raise notice 'Started Loading bronze.erp_px_cat_g1v2.';
	copy bronze.erp_px_cat_g1v2(id, cat, subcat, maintenance)
	from 'E:\projects\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
	delimiter ','
	csv header;
	
	raise notice 'Completed.';
	end_time := clock_timestamp();
	
	raise notice 'Time taken to complete: % ', end_time-start_time;
	
exception
	when others then
		raise notice 'There is an error: %, try to resolve it asap.', sqlerrm;
commit;	

end $$;

