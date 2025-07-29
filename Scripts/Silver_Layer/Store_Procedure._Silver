EXEC Silver.load_silver;

CREATE OR ALTER PROCEDURE Silver.load_silver AS
BEGIN
    DECLARE @Start_time DATETIME, @End_time DATETIME, @WholeStart_time DATETIME, @WholeEnd_time DATETIME;

    BEGIN TRY
        SET @WholeStart_time = GETDATE();

        print '>>Truncating the table Silver.crm_cust_info'
        SET @Start_time = GETDATE();

        TRUNCATE TABLE Silver.crm_cust_info;

        print '==========================================================='
        print 'Load cleaned customer data into Silver layer:'
        print 'Trim names, standardize marital status & gender'
        print 'Remove null IDs, keep most recent record per customer'
        print '==========================================================='

        INSERT INTO Silver.crm_cust_info (
            cst_id,
            cst_key,
            cst_firstname,
            cst_lastname,
            cst_marital_status,
            cst_gndr,
            cst_create_date
        )
        SELECT
            cst_id,
            cst_key,
            TRIM(cst_firstname),
            TRIM(cst_lastname),
            CASE
                WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
                WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
                ELSE 'N/A'
            END,
            CASE
                WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
                WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
                ELSE 'N/A'
            END,
            cst_create_date
        FROM (
            SELECT *, ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_date
            FROM Bronze.crm_cust_info
            WHERE cst_id IS NOT NULL
        ) t
        WHERE flag_date = 1;

        SET @End_time = GETDATE();
        PRINT '<<LOAD DURATION: ' + CAST(DATEDIFF(SECOND, @Start_time, @End_time) AS NVARCHAR) + ' SECONDS>>';

        ------------------------------------------------------

        print '>>Truncating the table Silver.crm_prd_info'
        SET @Start_time = GETDATE();

        TRUNCATE TABLE Silver.crm_prd_info;

        print '==================================================================='
        print 'Load cleaned Product Information data into Silver layer'
        print 'Transform product data:'
        print 'Split prd_key into cat_id & prd_key, replace - with _'
        print 'Normalize prd_line values (R → Road, etc.)'
        print 'Default prd_cost to 0 if null'
        print 'Calculate prd_end_dt as 1 day before next prd_start_dt per prd_key'
        print '==================================================================='

        INSERT INTO Silver.crm_prd_info (
            prd_id,
            cat_id,
            prd_key,
            prd_nm,
            prd_cost,
            prd_line,
            prd_start_dt,
            prd_end_dt
        )
        SELECT
            prd_id,
            REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_'),
            SUBSTRING(prd_key, 7, LEN(prd_key)),
            prd_nm,
            ISNULL(prd_cost, 0),
            CASE
                WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
                WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
                WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
                WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
            END,
            CAST(prd_start_dt AS DATE),
            CAST(DATEADD(DAY, -1, LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)) AS DATE)
        FROM Bronze.crm_prd_info;

        SET @End_time = GETDATE();
        PRINT '<<LOAD DURATION: ' + CAST(DATEDIFF(SECOND, @Start_time, @End_time) AS NVARCHAR) + ' SECONDS>>';

        ------------------------------------------------------

        print '>>Truncating the table Silver.crm_sales_details'
        SET @Start_time = GETDATE();

        TRUNCATE TABLE Silver.crm_sales_details;

        print '=============================================================='
        print 'Load Cleaned Sales Data from Bronze to Silver Layer'
        print '---------------------------------------------------------------'
        print '- Converts INT to DATE for order, ship, and due dates'
        print '- Fixes invalid/null sales and price values'
        print '- Ensures consistency before loading into Silver'
        print '=============================================================='

        INSERT INTO Silver.crm_sales_details (
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
            CASE
                WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL
                ELSE CAST(CAST(sls_order_dt AS VARCHAR(8)) AS DATE)
            END,
            CASE
                WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL
                ELSE CAST(CAST(sls_ship_dt AS VARCHAR(8)) AS DATE)
            END,
            CASE
                WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL
                ELSE CAST(CAST(sls_due_dt AS VARCHAR(8)) AS DATE)
            END,
            CASE
                WHEN sls_sales <= 0 OR sls_sales IS NULL OR sls_sales != sls_quantity * ABS(sls_price)
                    THEN sls_quantity * ABS(sls_price)
                ELSE sls_sales
            END,
            sls_quantity,
            CASE
                WHEN sls_price IS NULL OR sls_price <= 0
                    THEN sls_sales / NULLIF(sls_quantity, 0)
                ELSE sls_price
            END
        FROM Bronze.crm_sales_details;

        SET @End_time = GETDATE();
        PRINT '<<LOAD DURATION: ' + CAST(DATEDIFF(SECOND, @Start_time, @End_time) AS NVARCHAR) + ' SECONDS>>';

        ------------------------------------------------------

        print '>>Truncating the table Silver.erp_CUST_AZ12'
        SET @Start_time = GETDATE();

        TRUNCATE TABLE Silver.erp_CUST_AZ12;

        print '=============================================================='
        print 'Load Cleaned ERP Customer Data from Bronze to Silver Layer'
        print '---------------------------------------------------------------'
        print '- Normalize CID by removing NAS prefix'
        print '- Nullify future birthdates'
        print '- Standardize gender values to Male or Female'
        print '=============================================================='

        INSERT INTO Silver.erp_CUST_AZ12 (
            CID,
            BDATE,
            GEN
        )
        SELECT
            CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid)) ELSE cid END,
            CASE WHEN BDATE > GETDATE() THEN NULL ELSE BDATE END,
            CASE 
                WHEN UPPER(TRIM(GEN)) IN ('F', 'FEMALE') THEN 'Female'
                WHEN UPPER(TRIM(GEN)) IN ('M', 'MALE') THEN 'Male'
                ELSE 'N/A'
            END
        FROM Bronze.erp_CUST_AZ12;

        SET @End_time = GETDATE();
        PRINT '<<LOAD DURATION: ' + CAST(DATEDIFF(SECOND, @Start_time, @End_time) AS NVARCHAR) + ' SECONDS>>';

        ------------------------------------------------------

        print '>>Truncating the table Silver.erp_LOC_A101'
        SET @Start_time = GETDATE();

        TRUNCATE TABLE Silver.erp_LOC_A101;

        print '=============================================================='
        print 'Load Cleaned ERP Location Data from Bronze to Silver Layer'
        print '---------------------------------------------------------------'
        print '- Remove dashes from CID'
        print '- Normalize country codes (e.g., DE → Germany, US/USA → United States)'
        print '- Set blanks/nulls to N/A'
        print '=============================================================='

        INSERT INTO Silver.erp_LOC_A101 (
            CID,
            CNTRY
        )
        SELECT
            REPLACE(CID, '-', ''),
            CASE
                WHEN TRIM(CNTRY) = 'DE' THEN 'Germany'
                WHEN TRIM(CNTRY) IN ('US', 'USA') THEN 'United States'
                WHEN TRIM(CNTRY) = '' OR CNTRY IS NULL THEN 'N/A'
                ELSE CNTRY
            END
        FROM Bronze.erp_LOC_A101;

        SET @End_time = GETDATE();
        PRINT '<<LOAD DURATION: ' + CAST(DATEDIFF(SECOND, @Start_time, @End_time) AS NVARCHAR) + ' SECONDS>>';

        ------------------------------------------------------

        print '>>Truncating the table Silver.erp_PX_CAT_G1V2'
        SET @Start_time = GETDATE();

        TRUNCATE TABLE Silver.erp_PX_CAT_G1V2;

        print '=============================================================='
        print 'Load ERP Product Category Data from Bronze to Silver Layer'
        print '---------------------------------------------------------------'
        print '- Direct load without transformation (clean data structure)'
        print '=============================================================='

        INSERT INTO Silver.erp_PX_CAT_G1V2 (
            ID,
            CAT,
            SUBCAT,
            MAINTENANCE
        )
        SELECT
            ID,
            CAT,
            SUBCAT,
            MAINTENANCE
        FROM Bronze.erp_PX_CAT_G1V2;

        SET @End_time = GETDATE();
        PRINT '<<LOAD DURATION: ' + CAST(DATEDIFF(SECOND, @Start_time, @End_time) AS NVARCHAR) + ' SECONDS>>';

        ------------------------------------------------------

        SET @WholeEnd_time = GETDATE();
        PRINT '<< WHOLE SILVER LOAD DURATION: ' + CAST(DATEDIFF(SECOND, @WholeStart_time, @WholeEnd_time) AS NVARCHAR) + ' SECONDS>>';

    END TRY
    BEGIN CATCH
        PRINT 'MESSAGE ERROR: ' + ERROR_MESSAGE();
        PRINT 'ERROR CODE: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
    END CATCH
END
