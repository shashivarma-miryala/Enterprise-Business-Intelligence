# DA-01 – Architecture and Data Lineage

## 1. Architecture Overview

DA-01 follows a layered data warehouse architecture that transforms operational data into business intelligence reports.

The architecture consists of:

1. Source database
2. Staging layer
3. Dimension layer
4. Fact layer
5. Reporting layer
6. Power BI presentation layer
7. Automation and monitoring layer

## 2. End-to-End Data Flow

AdventureWorks2022
        |
        v
SQL Server – DA01_BI
        |
        v
Staging Schema (stg)
        |
        v
Dimension Schema (dim)
        |
        v
Fact Schema (fact)
        |
        v
Reporting Views (dbo)
        |
        v
Power BI Dataset and Dashboards

PowerShell and Windows Task Scheduler automate the ETL process.

## 3. Source Layer

**Database:** AdventureWorks2022

The source database contains operational business data from areas such as:

- Sales
- Purchasing
- Human Resources
- Production
- Inventory
- Product management

The warehouse extracts data from the required source tables.

The source database is maintained separately from DA01_BI.

## 4. Staging Layer

**Schema:** stg

Purpose:
- Hold extracted source records.
- Preserve source identifiers.
- Provide an intermediate layer for warehouse transformations.
- Separate source extraction from dimensional loading.

The staging refresh procedure is:

etl.usp_RefreshStaging

It refreshes 21 staging tables using dynamic SQL and explicit column handling.

## 5. Dimension Layer

**Schema:** dim

Dimensions provide descriptive business context.

The eight dimensions are:

- DimDate
- DimCustomer
- DimProduct
- DimRegion
- DimEmployee
- DimDepartment
- DimVendor
- DimLocation

The dimension refresh procedure is:

etl.usp_RefreshDimensions

The dimension load produced 24,775 rows in the validated execution.

## 6. Fact Layer

**Schema:** fact

Facts contain measurable business activity.

The six facts are:

- FactSales
- FactPurchases
- FactInventory
- FactWorkOrders
- FactEmployeePay
- FactEmployeeDepartment

The fact refresh procedure is:

etl.usp_RefreshFacts

The fact load produced 204,434 rows in the validated execution.

## 7. Reporting Layer

**Schema:** dbo

Six reporting views provide business-friendly query outputs:

- vw_SalesPerformance
- vw_PurchasePerformance
- vw_InventoryPerformance
- vw_WorkOrderPerformance
- vw_EmployeeDepartmentPerformance
- vw_EmployeePayPerformance

These views combine warehouse facts with descriptive dimension attributes.

They support reporting and validation.

## 8. ETL Orchestration

The main controller procedure is:

etl.usp_LoadWarehouse

Execution sequence:

1. Refresh staging.
2. Refresh dimensions.
3. Refresh facts.

The controller records execution information in:

etl.ETLRunLog

The logging process tracks procedure execution status and row counts.

The ETL implementation uses transactions and TRY/CATCH error handling.

Each child procedure manages its own transaction. If a later stage fails after an earlier stage commits, rerun the full controller to restore a consistent full-refresh result.

## 9. Automation Layer

**PowerShell script:**

C:\DA01_Automation\Run_DA01_ETL.ps1

**Scheduler:**

Windows Task Scheduler

**Task name:**

DA01 Warehouse ETL Refresh

**Schedule:**

Daily at 9:00 AM.

PowerShell starts the SQL warehouse refresh and records execution details in log files.

SQL Server Express does not provide SQL Server Agent, so Windows Task Scheduler is used.

## 10. Power BI Layer

Power BI Desktop imports the warehouse dimensions and facts.

The report contains five pages:

1. Executive Overview
2. Sales Performance
3. Finance & Profitability
4. HR Analytics
5. Supply Chain & Operations

DAX measures calculate business KPIs, while dimension attributes provide slicers and grouping.

## 11. Security and Filtering

The report includes the Regional_Sales_Access role.

The tested role restricts DimRegion to RegionKey = 1.

This is a static demonstration. It is not dynamic user-based security.

The region relationship filters sales data. It does not automatically restrict unrelated business areas.

## 12. Refresh Strategy

The warehouse uses full refreshes.

The ETL process refreshes staging first, followed by dimensions and facts.

Power BI must refresh after the warehouse refresh to display the latest loaded data.

The current inventory fact represents a snapshot and does not provide historical inventory trends.

## 13. Monitoring and Validation

Monitoring components:

- etl.ETLRunLog
- PowerShell execution logs
- Windows Task Scheduler execution history

Validation includes:

- Source-to-staging row counts.
- Dimension and fact row counts.
- Fact-to-dimension key checks.
- Date key validation.
- Reporting view totals.
- Power BI KPI comparisons.

The completed validation returned zero invalid fact-to-dimension rows and zero invalid date keys.

## 14. Architecture Limitations

- Full refresh is used instead of incremental ETL.
- Slowly changing dimensions are not implemented.
- Source data must be available in AdventureWorks2022.
- Power BI uses imported data and requires refresh after ETL.
- Regional RLS is static and applies to sales through DimRegion.
- Inventory is a current snapshot rather than historical movement data.

## 15. Reproduction Sequence

To reproduce the solution in another environment:

1. Install SQL Server and SSMS.
2. Restore AdventureWorks2022.
3. Create DA01_BI.
4. Execute the database implementation SQL script.
5. Configure and run the ETL process.
6. Validate warehouse counts and relationships.
7. Configure Power BI connection.
8. Refresh the Power BI report.
9. Configure PowerShell automation and Task Scheduler.
10. Verify logs and scheduled execution.

