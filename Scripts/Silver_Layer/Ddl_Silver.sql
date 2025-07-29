IF OBJECT_ID('Silver.crm_cust_info', 'U') IS NOT NULL
DROP TABLE Silver.crm_cust_info

CREATE TABLE Silver.crm_cust_info(
    cst_id INT ,
    cst_key NVARCHAR(50),
    cst_firstname NVARCHAR(50),
    cst_lastname NVARCHAR(50),
    cst_marital_status NVARCHAR(20),
    cst_gndr NVARCHAR(10),
    cst_create_date DATE,
	dwh_create_date Datetime2 Default GetDate()
);

IF OBJECT_ID('Silver.crm_prd_info', 'U') IS NOT NULL
DROP TABLE Silver.crm_prd_info


CREATE TABLE Silver.crm_prd_info(
    prd_id INT ,
    prd_key VARCHAR(50),
    prd_nm VARCHAR(100),
    prd_cost DECIMAL(10, 2),
    prd_line VARCHAR(50),
    prd_start_dt DATE,
    prd_end_dt DATE,
	dwh_create_date Datetime2 Default GetDate()
);


IF OBJECT_ID('Silver.crm_sales_details', 'U') IS NOT NULL
DROP TABLE Silver.crm_sales_details

CREATE TABLE Silver.crm_sales_details(
    sls_ord_num NVARCHAR(50) ,
    sls_prd_key NVARCHAR(50),
    sls_cust_id INT,
    sls_order_dt INT,
    sls_ship_dt INT,
    sls_due_dt INT,
    sls_sales INT,
    sls_quantity INT,
    sls_price INT,
	dwh_create_date Datetime2 Default GetDate()
);


--==================================
--Silver layer table for erp
--==================================

IF OBJECT_ID('Silver.erp_CUST_AZ12', 'U') IS NOT NULL
DROP TABLE Silver.erp_CUST_AZ12


CREATE TABLE Silver.erp_CUST_AZ12(
    CID NVARCHAR(50) ,
    BDATE DATE,
    GEN NVARCHAR(10),
	dwh_create_date Datetime2 Default GetDate()
);


IF OBJECT_ID('Silver.erp_LOC_A101', 'U') IS NOT NULL
DROP TABLE Silver.erp_LOC_A101



CREATE TABLE Silver.erp_LOC_A101(
    CID NVARCHAR(50) ,
    CNTRY VARCHAR(50),
	dwh_create_date Datetime2 Default GetDate()
);


IF OBJECT_ID('Silver.erp_PX_CAT_G1V2', 'U') IS NOT NULL
DROP TABLE Silver.erp_PX_CAT_G1V2


CREATE TABLE Silver.erp_PX_CAT_G1V2(
    ID NVARCHAR(50),
    CAT NVARCHAR(50),
    SUBCAT NVARCHAR(50),
    MAINTENANCE NVARCHAR(100),
	dwh_create_date Datetime2 Default GetDate()
);
