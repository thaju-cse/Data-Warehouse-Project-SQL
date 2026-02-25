/*
===============================================================================
Views: Create views using silver layer
===============================================================================
Script Purpose:
    This script creates fact and dimension views for Business Intelligence or Data Analytics.
	Actions Performed:
        - Create or replace the existing view with Business rules included.
        - Creates views in Gold Layer.		
Parameters:
    This script creates views which is not stored in physically.
This script will work only with postgres databases only.
===============================================================================
*/
-- drop view if exists gold.dim_customers;
create or replace view gold.dim_customers as
    select 
        row_number() over (order by sci.cst_id) as customer_dimension_id,
        sci.cst_id as customer_id,
        sci.cst_key as customer_key,
        sci.cst_firstname as firstname,
        sci.cst_lastname as lastname,
        sci.cst_marital_status as marital_status,
        -- sci.cst_gndr,
        case when sci.cst_gndr != 'n/a' then sci.cst_gndr
            else coalesce(sec.gen, 'n/a') end as gender,
        -- sci.dwh_create_date,
        -- sec.cid,
        -- sec.gen,
        -- sec.dwh_create_date
        selo.cntry as country,   
        sec.bdate as birthdate,
        sci.cst_create_date as create_date
    
    from silver.crm_cust_info as sci
    left join silver.erp_cust_az12 as sec 
    on sci.cst_key = sec.cid
    left join silver.erp_loc_a101 as selo
    on sci.cst_key = selo.cid ;

-- drop view if exists gold.dim_products;

create or replace view gold.dim_products as
    SELECT 
        row_number() over (order by scp.prd_id) as product_dimension_id,

        scp.prd_id as product_id, 
        scp.prd_key as product_key, 
        scp.prd_nm as product_name, 
        scp.cat_id as category_id, 
        sep.cat category, 
        sep.subcat sub_category, 
        sep.maintenance as maintanance,
    
        scp.prd_cost as product_cost, 
        scp.prd_line as product_line, 
        scp.prd_start_dt as start_date, 
        scp.prd_end_dt end_date
        -- scp.dwh_create_date,
        -- sep.id category_id, 
    
        -- sep.dwh_create_date
    
    FROM silver.crm_prd_info as scp
    left join silver.erp_px_cat_g1v2 as sep 
    on scp.cat_id = sep.id ;

-- drop view if exists gold.fact_sales;

create or replace view gold.fact_sales as    
    SELECT 
        sd.sls_ord_num as order_number, 
        -- sd.sls_prd_key, 
        --    sd.sls_cust_id, 
        gp.product_dimension_id as product_key, -- surrogate key
        gc.customer_dimension_id as customer_key, -- surrogate key
        sd.sls_order_dt as order_date, 
        sd.sls_ship_dt as shipping_date, 
        sd.sls_due_dt as due_date, 
        sd.sls_sales as sales_amount, 
        sd.sls_quantity as quantity, 
        sd.sls_price as price
    FROM silver.crm_sales_details as sd
    left join gold.dim_customers as gc
    on sd.sls_cust_id = gc.customer_id
    left join gold.dim_products as gp
    on sd.sls_prd_key = gp.product_key;

    select * 
    from gold.fact_sales f
    left join  gold.dim_customers c
    on f.customer_key = c.customer_dimension_id
    left join gold.dim_products p
    on f.product_key = p.product_dimension_id;    
         
