/*
=============================================================
Executes procedures: using postgres (psql)
=============================================================
Script Purpose:
    This script runs two procedures ddl_bronz(), load_bronze();
	  It will load only CSV file containing data, it will handle any errors using exceptions. 
    within the database schema: 'bronze'.
	
WARNING:
    Running this script will truncate, drop all the tables available in the bronze schema. 
    All data in the bronze schema will be permanently deleted. Proceed with caution 
    and ensure you have proper backups before running this script.
*/
call bronze.ddl_bronze();
call bronze.load_bronze();
