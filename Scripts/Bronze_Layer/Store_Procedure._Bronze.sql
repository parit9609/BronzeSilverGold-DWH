/*Stored Procedure: Load Bronze Layer (Source -> Bronze)
=============================================================

Script Purpose:
  This stored procedure loads data into the 'bronze' schema from external CSV files.
  It performs the following actions:
  - Truncates the bronze tables before loading data.
  - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
  None.
  This stored procedure does not accept any parameters or return any values.

Usage Example:
  EXEC bronze.load_bronze;
=============================================================

*/


EXEC Bronze.load_bronze;


CREATE OR ALTER PROCEDURE Bronze.load_bronze AS
BEGIN
    DECLARE @Start_time Datetime, @End_time Datetime, @WholeStart_time Datetime, @WholeEnd_time Datetime
	BEGIN TRY
	    set @WholeStart_time=GETDATE();
		print'--========================================';
		print'--Inserting data from cust_info.csv file';
		print'--========================================';

		set @Start_time=GETDATE();
		print'--========================================';
		print'--Truncating tabel : Bronze.crm_cust_info';
		print'--========================================';

		Truncate table Bronze.crm_cust_info;

		print'--========================================';
		print'-Inserting the tabel Bronze.crm_cust_info';
		print'--========================================';

		BULK INSERT Bronze.crm_cust_info
		FROM 'C:\Users\parit\OneDrive\Desktop\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH(
			FIRSTROW=2,
			FIELDTERMINATOR=',',
			TABLOCK
		);

		set @End_time=GETDATE();
		PRINT '<<LOAD DURATION: ' + CAST(DATEDIFF(SECOND, @Start_time, @End_time) AS NVARCHAR) + ' SECONDS>>';


		print'--========================================';
		print'--Inserting data from prd_info.csv file';
		print'--========================================';

		print'--========================================';
		print'--Truncating tabel :ccrm_prd_info';
		print'--========================================';
		
		set @Start_time=GETDATE();

		Truncate table Bronze.crm_prd_info;

		print'--========================================';
		print'-Inserting the tabel Bronze.crm_prd_info';
		print'--========================================';

		BULK INSERT Bronze.crm_prd_info
		FROM 'C:\Users\parit\OneDrive\Desktop\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH(
			FIRSTROW=2,
			FIELDTERMINATOR=',',
			TABLOCK
		);


		set @End_time=GETDATE();
		PRINT '<<LOAD DURATION: ' + CAST(DATEDIFF(SECOND, @Start_time, @End_time) AS NVARCHAR) + ' SECONDS>>';

		print'--========================================'
		print'--Inserting data from sales_details.csv file'
		print'--========================================'

		print'--========================================';
		print'--Truncating tabel :Bronze.crm_sales_details';
		print'--========================================';


		set @Start_time=GETDATE();

		Truncate table Bronze.crm_sales_details;


		print'--========================================';
		print'-Inserting the tabel Bronze.crm_sales_details';
		print'--========================================';


		BULK INSERT Bronze.crm_sales_details
		FROM 'C:\Users\parit\OneDrive\Desktop\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH(
			FIRSTROW=2,
			FIELDTERMINATOR=',',
			TABLOCK
		);

		set @End_time=GETDATE();
		PRINT '<<LOAD DURATION: ' + CAST(DATEDIFF(SECOND, @Start_time, @End_time) AS NVARCHAR) + ' SECONDS>>';


		print'--========================================'
		print'--Inserting data from CUST_AZ12.csv file'
		print'--========================================'


		print'--========================================';
		print'--Truncating tabel :Bronze.erp_CUST_AZ12';
		print'--========================================';

		set @Start_time=GETDATE();

		Truncate table Bronze.erp_CUST_AZ12;

		print'--========================================';
		print'-Inserting the tabel Bronze.erp_CUST_AZ12';
		print'--========================================';


		BULK INSERT Bronze.erp_CUST_AZ12
		FROM 'C:\Users\parit\OneDrive\Desktop\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		WITH(
			FIRSTROW=2,
			FIELDTERMINATOR=',',
			TABLOCK
		);

		set @End_time=GETDATE();
		PRINT '<<LOAD DURATION: ' + CAST(DATEDIFF(SECOND, @Start_time, @End_time) AS NVARCHAR) + ' SECONDS>>';


		print'--========================================'
		print'--Inserting data from LOC_A101.csv file'
		print'--========================================'


		print'--========================================';
		print'--Truncating tabel :Bronze.erp_LOC_A101';
		print'--========================================';


		set @Start_time=GETDATE();

		Truncate table Bronze.erp_LOC_A101;

		print'--========================================';
		print'-Inserting the tabel Bronze.erp_LOC_A101';
		print'--========================================';

		BULK INSERT Bronze.erp_LOC_A101
		FROM 'C:\Users\parit\OneDrive\Desktop\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		WITH(
			FIRSTROW=2,
			FIELDTERMINATOR=',',
			TABLOCK
		);

		set @End_time=GETDATE();
		PRINT '<<LOAD DURATION: ' + CAST(DATEDIFF(SECOND, @Start_time, @End_time) AS NVARCHAR) + ' SECONDS>>';


		print'--========================================'
		print'--Inserting data from PX_CAT_G1V2.csv file'
		print'--========================================'


		print'--========================================';
		print'--Truncating tabel :Bronze.erp_PX_CAT_G1V2';
		print'--========================================';

		set @Start_time=GETDATE();

		Truncate table Bronze.erp_PX_CAT_G1V2;

		print'--========================================';
		print'-Inserting the tabel Bronze.erp_PX_CAT_G1V2';
		print'--========================================';


		BULK INSERT Bronze.erp_PX_CAT_G1V2
		FROM 'C:\Users\parit\OneDrive\Desktop\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH(
			FIRSTROW=2,
			FIELDTERMINATOR=',',
			TABLOCK
		);

		set @End_time=GETDATE();
		PRINT '<<LOAD DURATION: ' + CAST(DATEDIFF(SECOND, @Start_time, @End_time) AS NVARCHAR) + ' SECONDS>>';


		set @WholeEnd_time=GETDATE();
		PRINT '<< Whole LOAD DURATION: ' + CAST(DATEDIFF(SECOND, @Start_time, @End_time) AS NVARCHAR) + ' SECONDS>>';

	END TRY
	BEGIN CATCH
	PRINT'MESSAGE ERROR'+ ERROR_MESSAGE();
	PRINT'MESSAGE ERROR'+ CAST(ERROR_NUMBER() AS NVARCHAR);
	END CATCH
END
