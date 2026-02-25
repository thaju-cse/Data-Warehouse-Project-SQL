/*
===============================================================================
Calling Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================
Script Purpose:
    Calling ddl_silver() and load_silver procedures for batch processing.		
Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.
Usage Example:
  call silver.ddl_silvr();  
  call silver.load_silver();
    
===============================================================================
*/
call silver.ddl_silver();
call silver.load_silver();
