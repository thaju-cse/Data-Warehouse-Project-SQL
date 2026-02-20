# Data Warehouse Project
Welcome to the **Data Warehouse Project** repository !
This Project demonstrates a complex data warehousing and analytics solution. 
From Extracting the data to generating actionable insights.

---

## Data Architecture

This project follows Medallion Architecture **Bronze**, **Silver** and **Gold** layers:
!Image

1. **Bronze Layer**: Stores raw data as-is from the source systems.
2. **Silver Layer**: This layer includes data cleansing, standardization and normalization processes to prepare data for analysis.
3. **Gold Layer**: Prepares business-ready data modeled into a star schema required for reporting and analytics.

---

## Project Overview

This project involves:

1. **Data Architecture**: Designing a Modern Data Warehouse Medallion Architecture **Bronze**, **Silver** and **Gold** layers.
2. **ETL Pipelines**: Extracting, Transforming and loading data from source systems into the warehouse.
3. **Data Modelling**: Developing fact and dimension tables optimized for actionable insights.
4. **Analytics and Reporting**:

This projects involves topics like:
* Data Architecting
* Data Engineering
* ETL Pipeline Developer
* Data Modelling
* Data Analytics
* SQL Development

---

## Important Tools:

* Datasets as csv files
* Postgres
* DBeaver
* Git Repositiory
* Draw.IO for preparing arctitectures, models and flows
* Notion to plan and track the whole project

---

## Project Requirements

* Intermediate level understanding of SQL
* Basics Understanding of Data Model
* Database hosting and login via client
* Understanding of data flow architecture
* Familiar with Installation and trouble shooting
* Etc

### Building the Data Warehouse

#### Objective

#### Specifications

### BI: 

#### Objective

## Repository Structure
```
Data-Warehouse-Project-SQL

├───Datasets
│   ├───source_crm
│   │       cust_info.csv
│   │       prd_info.csv
│   │       sales_details.csv
│   │
│   └───source_erp
│           CUST_AZ12.csv
│           LOC_A101.csv
│           PX_CAT_G1V2.csv
│
├───Docs
│       Architecture.pdf
│
└───Scripts
    │   init_schemas.sql
    │
    ├───bronze
    │       bronze_ddl.sql
    │       bronze_load.sql
    │       bronze_load_check.sql
    │       bronze_main.sql
    │
    ├───gold
    └───silver
```

---

## License

This project is licensed under the [MIT License](LICENSE). You are free to use, modify and share this project with proper attribution.

---

## About Me

Hi there! I am **Shaik Thajuddhin**, I am a Data Enthusiast and passionate learner to learn and Grow.

