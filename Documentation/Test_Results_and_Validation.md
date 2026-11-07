# DA-01 – Test Results and Validation Report

## 1. Purpose

This document records the validation and testing performed on the DA-01 Enterprise Business Intelligence Suite.

Testing covers source extraction, staging, dimensions, facts, reporting views, ETL automation, and Power BI results.

## 2. Staging Validation

The staging process extracted data from 21 source tables.

| Validation | Result |
|---|---:|
| Total staging rows | 280,760 |
| Source tables loaded | 21 |
| Execution status | Succeeded |

Staging row counts were checked against the source database.

## 3. Dimension Validation

| Dimension | Validated rows |
|---|---:|
| DimCustomer | 19,820 |
| DimProduct | 504 |
| DimRegion | 10 |
| DimEmployee | 290 |
| DimDepartment | 16 |
| DimVendor | 104 |
| DimLocation | 14 |
| DimDate | 4,017 |
| **Total** | **24,775** |

All eight dimensions were populated successfully.

## 4. Fact Validation

| Fact | Validated rows |
|---|---:|
| FactSales | 121,317 |
| FactPurchases | 8,845 |
| FactInventory | 1,069 |
| FactWorkOrders | 72,591 |
| FactEmployeePay | 316 |
| FactEmployeeDepartment | 296 |
| **Total** | **204,434** |

Fact counts were compared with expected source-derived totals.

## 5. Referential Integrity Validation

Validation covered 13 fact-to-dimension relationships.

| Test | Result |
|---|---:|
| Invalid fact-to-dimension rows | 0 |
| Invalid date keys | 0 |

All tested fact relationships passed.

## 6. Sales Validation

| Metric | Validated result |
|---|---:|
| Sales detail rows | 121,317 |
| Distinct sales orders | 31,465 |
| Sales revenue | 109,846,381.425 |
| Estimated product cost | 100,474,477.7735 |
| Estimated gross margin | 9,371,903.6277 |
| Units sold | 274,914 |

The sales reporting view was checked against the source-derived values.

## 7. Purchasing Validation

| Metric | Validated result |
|---|---:|
| Purchase detail rows | 8,845 |
| Purchase orders | 4,012 |
| Purchase amount | 63,791,994.838 |
| Received quantity | 2,327,299 |
| Rejected quantity | 72,700 |
| Stocked quantity | 2,254,599 |

Purchase reporting totals were validated.

## 8. Inventory Validation

| Metric | Validated result |
|---|---:|
| Inventory records | 1,069 |
| Products represented | 432 |
| Locations represented | 14 |
| Total inventory quantity | 335,974 |
| Zero-stock records | 4 |

The inventory view was validated. Inventory is a current snapshot.

## 9. Manufacturing Validation

| Metric | Validated result |
|---|---:|
| Work orders | 72,591 |
| Ordered quantity | 4,507,721 |
| Stocked quantity | 4,497,070 |
| Scrapped quantity | 10,651 |
| Average duration | 13.237990 |
| Work orders with scrap | 729 |

The work order reporting view was checked against the source-derived results.

## 10. Human Resources Validation

### Employee department assignments

| Metric | Validated result |
|---|---:|
| Assignment records | 296 |
| Employees represented | 290 |
| Departments represented | 16 |
| Current assignments | 290 |
| Historical assignments | 6 |

### Employee pay history

| Metric | Validated result |
|---|---:|
| Pay history records | 316 |
| Employees represented | 290 |
| Minimum recorded pay rate | 6.50 |
| Maximum recorded pay rate | 125.50 |
| Average recorded pay rate | 17.758804 |

Average recorded pay rate is not annual salary.

## 11. ETL Execution Validation

The ETL controller completed successfully.

Procedure execution sequence:

1. Refresh Staging
2. Refresh Dimensions
3. Refresh Facts
4. Load Warehouse controller

Latest recorded successful execution:

**Date:** 7 November 2026

| ETL component | Rows | Status |
|---|---:|---|
| Refresh Staging | 280,760 | Succeeded |
| Refresh Dimensions | 24,775 | Succeeded |
| Refresh Facts | 204,434 | Succeeded |
| Load Warehouse | Controller | Succeeded |

Execution records were stored in etl.ETLRunLog.

## 12. Windows Task Scheduler Validation

| Property | Validated result |
|---|---|
| Task name | DA01 Warehouse ETL Refresh |
| Schedule | Daily, 9:00 AM |
| Last task result | 0 |
| Task state | Ready |
| Next scheduled run | 8 November 2026, 9:00 AM |

A manual scheduled-task execution completed successfully.

The PowerShell log files recorded the ETL execution.

## 13. Power BI Validation

Power BI Desktop refreshed successfully.

The following KPI values matched the warehouse results:

| Power BI KPI | Expected result |
|---|---:|
| Sales Revenue | 109,846,381.43 |
| Total Employees | 290 |
| Inventory Quantity | 335,974 |

All five dashboard pages were reviewed:

1. Executive Overview
2. Sales Performance
3. Finance & Profitability
4. HR Analytics
5. Supply Chain & Operations

## 14. Row-Level Security Validation

Role: Regional_Sales_Access

Tested expression:

    'dim DimRegion'[RegionKey] = 1

The View as role test displayed one region.

Stopping the role simulation restored the unrestricted sales result.

**Limitation:** This is static regional filtering, not dynamic user-based security. The regional filter applies to sales through DimRegion and does not secure every fact table.

## 15. Overall Test Summary

| Test area | Outcome |
|---|---|
| Source extraction and staging | Passed |
| Dimension loading | Passed |
| Fact loading | Passed |
| Referential integrity | Passed |
| Date key validation | Passed |
| Sales reporting | Passed |
| Purchasing reporting | Passed |
| Inventory reporting | Passed |
| Manufacturing reporting | Passed |
| HR reporting | Passed |
| ETL controller | Passed |
| Scheduled automation | Passed |
| Power BI refresh | Passed |
| Key KPI reconciliation | Passed |
| Static RLS demonstration | Passed |

## 16. Known Limitations

1. AdventureWorks2022 is a sample operational database.
2. Estimated gross margin is not audited accounting profit.
3. Inventory is a current snapshot, not historical movement analysis.
4. Average recorded pay rate is not annual salary.
5. ETL uses full refresh rather than incremental loading.
6. Slowly changing dimensions are not implemented.
7. RLS is static rather than dynamic.
8. Power BI requires refresh after the warehouse ETL process.

## 17. Conclusion

The DA-01 warehouse, ETL automation, reporting views, Power BI dashboards, and static RLS demonstration completed the documented validation checks.

The project produced 280,760 staging rows, 24,775 dimension rows, and 204,434 fact rows.

The successful execution and KPI reconciliation demonstrate that the main data pipeline and reporting solution are functioning as expected in the tested environment.

