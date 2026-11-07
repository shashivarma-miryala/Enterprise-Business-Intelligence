# DA-01 – Enterprise Business Intelligence Suite

## 1. Project Overview

DA-01 is an end-to-end Enterprise Business Intelligence project built using the AdventureWorks2022 sample database.

The project integrates SQL Server data warehousing, automated ETL, dimensional modelling, Power BI dashboards, DAX measures, and Row-Level Security (RLS).

The objective is to transform operational business data into meaningful insights for sales, finance, human resources, supply chain, and manufacturing.

## 2. Business Areas Covered

- Sales performance and revenue analysis
- Finance and estimated gross margin analysis
- Human resources and workforce analytics
- Purchasing and supplier performance
- Inventory monitoring
- Manufacturing and work order analysis

## 3. Technology Stack

| Technology | Purpose |
|---|---|
| SQL Server Express 2025 | Database platform |
| SQL Server Management Studio | SQL development and administration |
| AdventureWorks2022 | Source database |
| PowerShell | ETL automation |
| Windows Task Scheduler | Scheduled ETL execution |
| Power BI Desktop | Data modelling and dashboards |
| DAX | Measures and calculated columns |
| Power Query | Data import and transformation |

## 4. Architecture

The project follows a dimensional data warehouse architecture:

1. Source: AdventureWorks2022
2. Staging: stg schema
3. Dimensions: dim schema
4. Facts: fact schema
5. ETL logging: etl schema
6. Reporting: SQL views and Power BI dashboards

ETL execution order:

AdventureWorks2022 → Staging → Dimensions → Facts → Power BI

The warehouse uses a full-refresh approach.

## 5. Database Objects

Database: DA01_BI

Schemas:
- stg
- dim
- fact
- etl
- dbo (reporting views)

Dimension tables:
- DimDate
- DimCustomer
- DimProduct
- DimRegion
- DimEmployee
- DimDepartment
- DimVendor
- DimLocation

Fact tables:
- FactSales
- FactPurchases
- FactInventory
- FactWorkOrders
- FactEmployeePay
- FactEmployeeDepartment

Reporting views:
- vw_SalesPerformance
- vw_PurchasePerformance
- vw_InventoryPerformance
- vw_WorkOrderPerformance
- vw_EmployeeDepartmentPerformance
- vw_EmployeePayPerformance

ETL procedures:
- etl.usp_RefreshStaging
- etl.usp_RefreshDimensions
- etl.usp_RefreshFacts
- etl.usp_LoadWarehouse

## 6. Source Database Dependency

AdventureWorks2022 is a separate source database and is not included in the DA01_BI schema-only implementation export.

To rebuild the project:
1. Install SQL Server and SSMS.
2. Restore or install the AdventureWorks2022 sample database.
3. Create the DA01_BI database.
4. Execute the database implementation script.
5. Configure the SQL Server connection used by the ETL automation.
6. Execute the ETL controller procedure.
7. Connect Power BI to the warehouse and refresh the report.

The source database must be named AdventureWorks2022 unless the source references in the ETL procedures are updated.

## 7. ETL Automation

The ETL controller executes staging, dimension, and fact refreshes in sequence.

The active automation script is:

C:\DA01_Automation\Run_DA01_ETL.ps1

The archived project copy is:

PowerShell\Run_DA01_ETL.ps1

Windows Task Scheduler task:

DA01 Warehouse ETL Refresh

Schedule: Daily at 9:00 AM.

SQL Server Express does not include SQL Server Agent, so Windows Task Scheduler is used.

ETL execution details are recorded in etl.ETLRunLog and the PowerShell log files.

## 8. Power BI Report

Report file:

PowerBI\DA01_Enterprise_Business_Intelligence.pbix

Dashboard pages:

1. Executive Overview
2. Sales Performance
3. Finance & Profitability
4. HR Analytics
5. Supply Chain & Operations

Key measures include:
- Total Sales Revenue
- Total Estimated Cost
- Total Estimated Gross Margin
- Gross Margin Percentage
- Total Orders
- Average Order Value
- Total Employees
- Current Employees
- Average Recorded Pay Rate
- Total Purchase Amount
- Total Inventory Quantity
- Total Work Orders
- Production Scrap Rate
- Total Rejected Quantity

## 9. Security Demonstration

The report contains a role named Regional_Sales_Access.

The tested demonstration filters DimRegion to RegionKey = 1.

This is a static RLS demonstration, not dynamic per-user security. The regional filter applies to the sales model through its region relationship. It should not be interpreted as restricting every business area or fact table.

## 10. Validation Results

The completed warehouse was validated against the source and reporting outputs.

| Area | Validated rows |
|---|---:|
| Staging tables | 280,760 |
| Dimension tables | 24,775 |
| Fact tables | 204,434 |
| Sales fact | 121,317 |
| Purchase fact | 8,845 |
| Inventory fact | 1,069 |
| Work order fact | 72,591 |
| Employee pay fact | 316 |
| Employee department fact | 296 |

Validation checks confirmed:
- Fact-to-dimension relationship checks returned zero invalid rows.
- Date key validation returned zero invalid rows.
- Reporting views were checked against source totals.
- ETL execution completed successfully.
- Power BI refresh completed successfully.
- Key Power BI totals matched warehouse results.

## 11. Important Data Limitations

- AdventureWorks2022 is an operational sample database, not a complete accounting general ledger.
- Gross margin is estimated using sales line revenue less estimated product standard cost. It is not audited accounting profit.
- Inventory is represented as a current product-location snapshot, not a historical inventory movement fact.
- Average Recorded Pay Rate is an average of recorded pay-rate history values, not annual salary.
- The warehouse uses full refreshes rather than historical slowly changing dimension tracking.
- Regional RLS is currently a static demonstration.

## 12. Project Folder Structure

DA01_Project/
- SQL/
- PowerBI/
- PowerShell/
- Logs/
- Documentation/
- Evidence/
- Presentation/

## 13. Reproduction Notes

The database implementation script contains database object definitions and ETL logic. It does not contain the AdventureWorks2022 source data or populated warehouse data.

A new environment must have the source database available before the ETL process can populate the warehouse.

