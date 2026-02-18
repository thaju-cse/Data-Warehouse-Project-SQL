/*
=============================================================
Create Database and Schemas: Using pdadmin4 (postgresql)
=============================================================
Script Purpose:
    This script creates a new database named 'DataWarehouse' after checking if it already exists. 
    If the database exists, it is dropped and recreated. 
	Additionally, the script sets up three schemas 
    within the database: 'bronze', 'silver', and 'gold'.
	
WARNING:
    Running this script will drop the entire 'DataWarehouse' database if it exists. 
    All data in the database will be permanently deleted. Proceed with caution 
    and ensure you have proper backups before running this script.
*/
-- DROP DATABASE IF EXISTS "DataWarehouse";
-- CREATE DATABASE DataWarehouse;
DO $$
BEGIN

RAISE NOTICE 'Creating Schemas of bronze, silver and gold.';

DROP SCHEMA IF EXISTS "bronze";
CREATE SCHEMA "bronze";

DROP SCHEMA IF EXISTS "silver";
CREATE SCHEMA "silver";

DROP SCHEMA IF EXISTS "gold";
CREATE SCHEMA "gold";

RAISE NOTICE 'Completed.';

COMMIT;

END $$;
