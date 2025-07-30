# 📘 DATA CATALOG – GOLD LAYER STAR SCHEMA

## Overview
This catalog documents the structure and business logic behind the Gold Layer of the Data Warehouse, built using a Star Schema. It includes three main tables:

- `dim_customer`: Describes customers
- `dim_product`: Describes products
- `fact_sales`: Captures sales transactions and links dimensions

---

## 🟫 Table: `gold.dim_customer`
**Type**: Dimension Table  
**Purpose**: Enriched customer profile combining CRM and ERP systems

### Columns

| Column Name       | Data Type | Description |
|-------------------|-----------|-------------|
| `customer_key`    | INT       | Surrogate key; unique identifier for customer in warehouse |
| `customer_id`     | INT       | CRM customer ID (`cst_id`) |
| `customer_number` | VARCHAR   | CRM/ERP customer reference key (`cst_key`) |
| `first_name`      | VARCHAR   | Customer's first name |
| `last_name`       | VARCHAR   | Customer's last name |
| `birthdate`       | VARCHAR   | Birth date from ERP; 'N/A' if unavailable |
| `marital_status`  | VARCHAR   | Normalized marital status (Single, Married, N/A) |
| `gender`          | VARCHAR   | Gender (from CRM or fallback to ERP) |
| `country`         | VARCHAR   | Country from ERP |
| `creation_date`   | DATE      | CRM record creation date |

---

## 🟧 Table: `gold.dim_product`
**Type**: Dimension Table  
**Purpose**: Provides product details and category enrichment

### Columns

| Column Name     | Data Type | Description |
|-----------------|-----------|-------------|
| `product_key`   | INT       | Surrogate key for product |
| `product_id`    | INT       | CRM product ID |
| `product_number`| VARCHAR   | Product reference key |
| `product_name`  | VARCHAR   | Product name |
| `product_cost`  | DECIMAL   | Product cost (default 0 if missing) |
| `start_dt`      | DATE      | Product start date |
| `product_line`  | VARCHAR   | Normalized product line (e.g., Road, Mountain) |
| `category_id`   | VARCHAR   | ERP category ID |
| `category`      | VARCHAR   | High-level product category |
| `subcategory`   | VARCHAR   | Mid-level category |
| `maintenance`   | VARCHAR   | Maintenance level or notes |

---

## 🟪 Table: `gold.fact_sales`
**Type**: Fact Table  
**Purpose**: Stores transactions, linking customer and product dimensions

### Columns

| Column Name     | Data Type | Description |
|-----------------|-----------|-------------|
| `order_number`  | VARCHAR   | Primary key; unique sales transaction |
| `customer_key`  | INT       | Foreign key to `dim_customer` |
| `product_key`   | INT       | Foreign key to `dim_product` |
| `order_date`    | DATE      | Sales order date |
| `ship_date`     | DATE      | Shipment date |
| `due_date`      | DATE      | Expected delivery date |
| `sales_amount`  | DECIMAL   | Total sale value; recalculated if invalid |
| `quantity`      | INT       | Number of units sold |
| `price`         | DECIMAL   | Price per unit; recalculated if null/invalid |

---

## 🌐 Relationships

| From Table     | Column         | To Table        | Column         | Type        | Description |
|----------------|----------------|------------------|----------------|-------------|-------------|
| `fact_sales`   | `customer_key` | `dim_customer`   | `customer_key` | Many-to-One | Maps sale to customer |
| `fact_sales`   | `product_key`  | `dim_product`    | `product_key`  | Many-to-One | Maps sale to product  |

---

## 📌 Business Context
- The Gold Layer is modeled as a **Star Schema** for efficient analytical querying.
- Dimension tables describe the **who** (`dim_customer`) and **what** (`dim_product`) of each sale.
- The central fact table (`fact_sales`) captures **how much**, **when**, and **what** was sold.
- Surrogate keys (`*_key`) are used for integrity and performance.
- Data originates from CRM and ERP systems via the Silver Layer (cleaned/transformed).




