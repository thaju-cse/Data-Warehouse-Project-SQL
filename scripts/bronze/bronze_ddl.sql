/*
=============================================================
Create Tables: Using pdadmin4 (postgresql)
=============================================================
Script Purpose:
    This script creates a new tables in bronze schema after droping existing tables. 
    If the table exists, it is dropped and recreated. 
	  Additionally, it handles raised error if any error occur.
    within the database: 'bronze'.
	
WARNING:
    Running this script will drop the entire tables in bronze schema if it exists. 
    All data in the tables will be permanently deleted. Proceed with caution 
    and ensure you have proper backups before running this script.
*/


create or replace procedure bronze.ddl_bronze() 
language plpgsql
as $$
begin
	begin		
		drop table if exists bronze.crm_cust_info;
		
		create table bronze.crm_cust_info (
			cst_id int,
			cst_key varchar(20),
			cst_firstname varchar(50),
			cst_lastname varchar(50),
			cst_marital_status varchar(6),
			cst_gndr varchar(20),
			cst_create_date date 
		);
		
		drop table if exists bronze.crm_prd_info;
		
		create table bronze.crm_prd_info (
			prd_id int,
			prd_key varchar(20),
			prd_nm varchar(50),
			prd_cost int,
			prd_line varchar(50),
			prd_start_dt date,
			prd_end_dt date
		);
		
		drop table if exists bronze.crm_sales_details;
		
		create table bronze.crm_sales_details(
			sls_ord_num varchar(20),
			sls_prd_key varchar(20),
			sls_cust_id int,
			sls_order_dt int,
			sls_ship_dt int,
			sls_due_dt int,
			sls_sales int,
			sls_quantity int,
			sls_price int
		);
		
		drop table if exists bronze.erp_cust_az12;
		
		create table bronze.erp_cust_az12(
			cid varchar(20),
			bdate date,
			gen varchar(10)
		);
		
		drop table if exists bronze.erp_loc_a101;
		
		create table bronze.erp_loc_a101(
			cid varchar(20),
			cntry varchar(50)
		);
		
		drop table if exists bronze.erp_px_cat_g1v2;
		
		create table bronze.erp_px_cat_g1v2(
			id varchar(20),
			cat varchar(50),
			subcat varchar(50),
			maintenance varchar(10)
		);
		raise notice 'Created all the schemas successfully';
	exception 
		when others then 
			raise notice 'There is an error: %,  resolve it asap', sqlerrm;
	end;
end;
$$;

