/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================
Script Purpose:
    This stored procedure performs the ETL (Extract, Transform, Load) process to 
    populate the 'silver' schema tables from the 'bronze' schema.
    Actions Performed:
        - Truncates Silver tables.
        - Inserts transformed and cleansed data from Bronze into Silver tables.
        
Parameters:
    None. 
      This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC Silver.load_silver;
===============================================================================
*/
create or replace procedure silver.load_silver() 
language plpgsql
as $$
begin
    begin   
        
        raise notice 'Starting the process of Transformation......';
            
        raise notice '================================';
        raise notice 'Truncating silver.crm_cust_info.';

        truncate table silver.crm_cust_info;

        raise notice 'Started loading silver.crm_cust_info.';
        insert into silver.crm_cust_info(
        	cst_id,
        	cst_key,
        	cst_firstname,
        	cst_lastname,
        	cst_marital_status,
        	cst_gndr,
        	cst_create_date
        	
        	)
        		select 
        			cst_id,
        			cst_key,
        			trim(cst_firstname) as cst_firstname, -- cleaned extra spaces
        			trim(cst_lastname) as cst_lastname, -- vleaned extra spaces
        			case when upper(cst_marital_status) = 'M' then 'Married'
        				 when upper(cst_marital_status) = 'S' then 'Single'
        				 else 'n/a' 
        				 end as cst_marital_status, -- changed abbrevations to readable formats
        			case when upper(cst_gndr) = 'M' then 'Male'
        				 when upper(cst_gndr) = 'F' then 'Female'
        				 else 'n/a'
        				 end as cst_gndr, -- changed abrevations to readable formats and filled null values with n/a
        			cst_create_date
        		from
        		
        		(select 
        			*,
        			row_number() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
        			from bronze.crm_cust_info
        			where cst_id is not null -- chosen latest updated data of persons
        		) t where flag_last = 1 ;
        
            
        raise notice '================================';
        raise notice 'Truncating silver.crm_prd_info.';
        
        truncate table silver.crm_prd_info;
        
        raise notice 'Started loading silver.crm_prd_info';
        insert into silver.crm_prd_info (
                    prd_id ,
                    cat_id ,
                    prd_key ,
                    prd_nm ,
                    prd_cost ,
                    prd_line ,
                    prd_start_dt ,
                    prd_end_dt 
                )        
                select 
                	prd_id,
                	REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id, -- Extract category ID
                	SUBSTRING(prd_key, 7, length(prd_key)) AS prd_key,        -- Extract product key
                	prd_nm,
                	case when prd_cost is null then 0
                	   else prd_cost
                	   end as prd_cost,
                	CASE 
                		WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
                		WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
                		WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
                		WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
                		ELSE 'n/a'
                	END AS prd_line, -- Map product line codes to descriptive values
                	CAST(prd_start_dt AS DATE) AS prd_start_dt,
                	CAST(
                		LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt) - 1 
                		AS DATE
                		) AS prd_end_dt -- Calculate end date as one day before the next start date
                FROM bronze.crm_prd_info;
                
            
        raise notice '================================';
        raise notice 'Truncating silver.crm_sales_details.';        
        
        truncate table silver.crm_sales_details;
        
        raise notice 'Started loading silver.crm_sales_details';
        insert into silver.crm_sales_details(
            sls_ord_num,
            sls_prd_key,
            sls_cust_id,
            sls_order_dt,
            sls_ship_dt,
            sls_due_dt,
            sls_sales,
            sls_quantity,
            sls_price    
                )
                SELECT 
                    sls_ord_num, 
                    sls_prd_key, 
                    sls_cust_id, 
                    CASE WHEN sls_order_dt = 0 OR (sls_order_dt < 10000000 or sls_order_dt > 100000000) THEN NULL
                        ELSE CAST(CAST(sls_order_dt AS VARCHAR(8)) AS DATE)
                    END AS sls_order_dt,
                    CASE 
                        WHEN sls_ship_dt = 0 OR (sls_ship_dt < 10000000 or sls_ship_dt > 100000000) THEN NULL
                        ELSE CAST(CAST(sls_ship_dt AS VARCHAR(8)) AS DATE)
                    END AS sls_ship_dt,
                    CASE 
                        WHEN sls_due_dt = 0 OR (sls_due_dt < 10000000 or sls_due_dt  > 100000000) THEN NULL
                        ELSE CAST(CAST(sls_due_dt AS VARCHAR(8)) AS DATE)
                    END AS sls_due_dt,
                    CASE 
                        WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price) 
                            THEN sls_quantity * ABS(sls_price)
                        ELSE sls_sales
                    END AS sls_sales, -- Recalculate sales if original value is missing or incorrect
                    sls_quantity,
                    CASE 
                        WHEN sls_price IS NULL OR sls_price <= 0 
                            THEN sls_sales / NULLIF(sls_quantity, 0)
                        ELSE sls_price  -- Derive price if original value is invalid
                    END AS sls_price
                FROM bronze.crm_sales_details;
            
        raise notice '================================';
        raise notice 'Truncating silver.erp_cust_az12.';                
        truncate silver.erp_cust_az12;
            
        raise notice 'Started loading silver.erp_cust_az12.';        
        insert INTO silver.erp_cust_az12 (
                    cid,
                    bdate,
                    gen
                )
                SELECT
                    CASE
                        WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, length(cid)) -- Remove 'NAS' prefix if present
                        ELSE cid
                    END AS cid, 
                    CASE
                        WHEN bdate > now() THEN NULL
                        ELSE bdate
                    END AS bdate, -- Set future birthdates to NULL
                    CASE
                        WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
                        WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
                        ELSE 'n/a'
                    END AS gen -- Normalize gender values and handle unknown cases
                FROM bronze.erp_cust_az12;
            
        raise notice '================================';
        raise notice 'Truncating silver.erp_loc_a101.';        
        truncate silver.erp_loc_a101;
        
        raise notice 'Started loading silver.erp_loc_a101.';
        INSERT INTO silver.erp_loc_a101 (
                    cid,
                    cntry
                )
                SELECT
                    REPLACE(cid, '-', '') AS cid, 
                    CASE
                        WHEN TRIM(cntry) = 'DE' THEN 'Germany'
                        WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
                        WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
                        ELSE TRIM(cntry)
                    END AS cntry -- Normalize and Handle missing or blank country codes
                FROM bronze.erp_loc_a101;
            
        raise notice '================================';
        raise notice 'Truncating silver.erp_px_cat_g1v1.';        
        truncate silver.erp_px_cat_g1v2;

        raise notice 'Started loading silver.erp_px_g1v1.';
        INSERT INTO silver.erp_px_cat_g1v2 (
                    id,
                    cat,
                    subcat,
                    maintenance
                )
                SELECT
                    id,
                    cat,
                    subcat,
                    maintenance
                FROM bronze.erp_px_cat_g1v2;
        raise notice '=========Completed=========';
    exception 
        when others then 
            raise notice 'There is an error: %,  resolve it asap.', sqlerrm;
    end;
end;
$$;

