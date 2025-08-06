# RetailDataWarehouse

A structured SQL-based Data Warehouse project designed to demonstrate the full ETL (Extract, Transform, Load) pipeline using layered architecture — Bronze, Silver, and Gold. This project showcases core concepts in data warehousing, data integration, reporting, and pipeline orchestration using SQL scripts and CSV source data.

---

## 📁 Project Structure

```
DataWarehouse/
│
├── DataSets/                     # Source data for CRM and ERP systems
│   ├── source+crm/
│   └── source+erp/
│
├── Documents/                    # Architecture diagrams and data catalog
│   ├── Data Flow Diagram.jpg
│   ├── Integation model of Bronze Layer.jpg
│   └── data_catalog.md
│
├── Scripts/
│   ├── Init_database.sql         # Schema/database initialization
│   ├── Bronze_Layer/
│   │   ├── Ddl_Bronze.SQL
│   │   └── Store_Procedure._Bronze.sql
│   ├── Silver_Layer/
│   │   ├── Ddl_Silver.sql
│   │   └── Store_Procedure._Silver.sql
│   ├── Gold_layer/
│   │   └── Ddl_gold.sql
│   ├── gold.customer_report.sql
│   └── Gold.product_report.sql
│
├── Tests/                        # Placeholder for unit test scripts
├── LICENSE
└── README.md
```

---

## 🔄 ETL Process Overview

**Bronze Layer**  
- Raw ingestion from CRM and ERP CSV files  
- Cleansing, basic standardization, and staging using stored procedures  

**Silver Layer**  
- Transformation and integration of CRM and ERP systems  
- Business logic applied (e.g., joins, derived fields, cleanup)  

**Gold Layer**  
- Final dimension and fact tables ready for analytics  
- Report-ready structures and precomputed metrics  
- Includes sample reports like customer segmentation and product performance

---

## 📊 Key Reports Included

- `gold.customer_report.sql`: Segmentation of customers into VIP, Regular, and New based on spending and lifespan  
- `Gold.product_report.sql`: Categorizes products into High, Mid, and Low performers based on revenue  

---

## 📄 Diagrams & Documentation

- **Data Flow Diagram**: Visualizes the flow of data across layers  
- **Integration Model**: Depicts how CRM and ERP data converge  
- **Data Catalog**: Comprehensive metadata about each table and column in the warehouse  

---

## 🧪 Testing

A dedicated `Tests/` directory is reserved for writing validation queries and test coverage scripts to ensure data quality and pipeline integrity.

---

## 🛠️ Technologies Used

- Microsoft SQL Server / T-SQL  
- CSV flat files for raw data  
- Layered data warehouse design (Bronze, Silver, Gold)  
- Manual ETL orchestration with SQL stored procedures

---

## 📌 How to Use

1. Clone the repository  
2. Load CSV files from `DataSets/` into your database server  
3. Execute scripts in the following order:
   - `Scripts/Init_database.sql`
   - Bronze Layer: DDL + Stored Procedure
   - Silver Layer: DDL + Stored Procedure
   - Gold Layer: DDL
4. Run report scripts in `Scripts/gold.*.sql` for insights

---

## 📄 License

This project is licensed under the MIT License. See the `LICENSE` file for details.
