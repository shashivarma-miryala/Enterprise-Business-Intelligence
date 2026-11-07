# DA-01 – Data Dictionary

## 1. Purpose

This document describes the dimensional model used in the DA-01 Enterprise Business Intelligence Suite.

The warehouse contains eight dimension tables and six fact tables.

- Dimension tables describe business entities and provide filtering and grouping attributes.
- Fact tables store measurable business events, transactions, and snapshots.
- Primary keys identify dimension records.
- Foreign keys connect fact records to dimensions.

---

# 2. Dimension Tables

## 2.1 DimDate

**Purpose:** Provides calendar attributes for analysing business activity over time.

**Grain:** One row per calendar date.

**Important fields:**
- DateKey – Date identifier used by fact tables.
- FullDate – Actual calendar date.
- Year – Calendar year.
- Quarter – Calendar quarter.
- Month – Month number.
- MonthName – Month name.
- MonthYear – Month and year display label.
- MonthYearSort – Numeric sorting key.
- Day – Day of the month.

## 2.2 DimCustomer

**Purpose:** Stores customer information for customer-level sales analysis.

**Grain:** One row per customer.

**Important fields:**
- CustomerKey – Warehouse surrogate key.
- CustomerID – Source customer identifier.
- PersonID – Related source person identifier, where available.
- TerritoryID – Source sales territory identifier.
- RegionKey – Warehouse region relationship.
- CustomerName – Customer display name.

## 2.3 DimProduct

**Purpose:** Describes products and their categories for product performance analysis.

**Grain:** One row per product.

**Important fields:**
- ProductKey – Warehouse surrogate key.
- ProductID – Source product identifier.
- ProductName – Product name.
- ProductNumber – Product number.
- ProductSubcategory – Product subcategory.
- ProductCategory – Product category.
- StandardCost – Product standard cost.
- ListPrice – Product list price.

Products without a matching subcategory or category are retained through LEFT JOIN logic.

## 2.4 DimRegion

**Purpose:** Stores sales territory and regional information.

**Grain:** One row per sales territory.

**Important fields:**
- RegionKey – Warehouse surrogate key.
- TerritoryID – Source territory identifier.
- RegionName – Territory name.
- CountryRegionCode – Country or region code.
- Group – Source territory group.

## 2.5 DimEmployee

**Purpose:** Stores employee details for workforce analysis.

**Grain:** One row per employee.

**Important fields:**
- EmployeeKey – Warehouse surrogate key.
- EmployeeID – Source employee identifier.
- JobTitle – Employee job title.
- BirthDate – Date of birth.
- Gender – Employee gender.
- HireDate – Date hired.
- MaritalStatus – Marital status.
- Age Group – Power BI calculated age category.

## 2.6 DimDepartment

**Purpose:** Describes organisational departments.

**Grain:** One row per department.

**Important fields:**
- DepartmentKey – Warehouse surrogate key.
- DepartmentID – Source department identifier.
- DepartmentName – Department name.
- GroupName – Department group.
- ModifiedDate – Source modification date.

## 2.7 DimVendor

**Purpose:** Stores supplier information for purchasing analysis.

**Grain:** One row per vendor.

**Important fields:**
- VendorKey – Warehouse surrogate key.
- VendorID – Source vendor identifier.
- VendorName – Supplier name.
- AccountNumber – Supplier account number.
- CreditRating – Supplier credit rating.
- PreferredVendorStatus – Preferred supplier indicator.
- ActiveFlag – Supplier activity indicator.

## 2.8 DimLocation

**Purpose:** Describes physical inventory and production locations.

**Grain:** One row per location.

**Important fields:**
- LocationKey – Warehouse surrogate key.
- LocationID – Source location identifier.
- LocationName – Location name.
- CostRate – Location cost rate.
- Availability – Location availability.

---

# 3. Fact Tables

## 3.1 FactSales

**Purpose:** Supports sales revenue, order, product, customer, and regional performance analysis.

**Grain:** One row per sales order line.

**Important fields:**
- SalesOrderID – Sales order identifier.
- SalesOrderDetailID – Sales order line identifier.
- OrderDateKey – Order date dimension key.
- CustomerKey – Customer dimension key.
- ProductKey – Product dimension key.
- RegionKey – Region dimension key.
- OrderQuantity – Quantity ordered.
- SalesAmount – Sales line revenue.
- EstimatedProductCost – Estimated standard product cost.
- EstimatedGrossMargin – Estimated revenue less estimated product cost.

**Important calculation:**

Estimated Gross Margin = Sales Amount − Estimated Product Cost.

This is an operational estimate, not audited accounting profit.

## 3.2 FactPurchases

**Purpose:** Supports purchase order, supplier, received quantity, and rejected quantity analysis.

**Grain:** One row per purchase order line.

**Important fields:**
- PurchaseOrderID – Purchase order identifier.
- PurchaseOrderDetailID – Purchase order line identifier.
- OrderDateKey – Purchase order date key.
- VendorKey – Vendor dimension key.
- ProductKey – Product dimension key.
- OrderQty – Quantity ordered.
- ReceivedQty – Quantity received.
- RejectedQty – Quantity rejected.
- StockedQty – Quantity accepted into stock.
- PurchaseAmount – Purchase line amount.

## 3.3 FactInventory

**Purpose:** Provides current inventory quantity by product and location.

**Grain:** One row per product-location inventory snapshot record.

**Important fields:**
- ProductKey – Product dimension key.
- LocationKey – Location dimension key.
- Quantity – Current inventory quantity.
- Shelf – Storage shelf.
- Bin – Storage bin.

**Important limitation:** This table represents a current snapshot, not historical inventory movements.

## 3.4 FactWorkOrders

**Purpose:** Supports manufacturing and production efficiency analysis.

**Grain:** One row per work order.

**Important fields:**
- WorkOrderID – Work order identifier.
- ProductKey – Product dimension key.
- StartDateKey – Production start date key.
- EndDateKey – Production end date key, where available.
- OrderQty – Quantity ordered for production.
- StockedQty – Quantity completed and stocked.
- ScrappedQty – Quantity scrapped.
- ActualDuration – Calculated production duration, where available.

## 3.5 FactEmployeePay

**Purpose:** Supports employee pay-rate history analysis.

**Grain:** One row per employee pay-rate history record.

**Important fields:**
- EmployeeKey – Employee dimension key.
- RateChangeDateKey – Pay-rate change date key.
- PayRate – Recorded hourly pay rate.
- PayFrequency – Pay frequency indicator.
- ModifiedDate – Source modification date.

**Important limitation:** Average Recorded Pay Rate is not an annual salary measure.

## 3.6 FactEmployeeDepartment

**Purpose:** Supports employee department assignment and workforce history analysis.

**Grain:** One row per employee-department assignment period.

**Important fields:**
- EmployeeKey – Employee dimension key.
- DepartmentKey – Department dimension key.
- StartDateKey – Assignment start date key.
- EndDateKey – Assignment end date key, where available.
- ShiftID – Assigned shift identifier.

A blank EndDateKey indicates a current assignment in this model.

---

# 4. Model Relationships

The model uses one-to-many relationships from dimensions to facts.

Main relationship groups:

- DimDate → FactSales, FactPurchases, FactWorkOrders, FactEmployeePay, FactEmployeeDepartment.
- DimCustomer → FactSales.
- DimProduct → FactSales, FactPurchases, FactInventory, FactWorkOrders.
- DimRegion → FactSales.
- DimEmployee → FactEmployeePay, FactEmployeeDepartment.
- DimDepartment → FactEmployeeDepartment.
- DimVendor → FactPurchases.
- DimLocation → FactInventory.

Relationships use single-direction filtering from dimensions to facts.

FactInventory is a current snapshot and does not have a date relationship.

---

# 5. Modelling Notes

1. The warehouse uses surrogate keys for dimension relationships.
2. Source identifiers are retained for traceability.
3. The current implementation performs full refreshes.
4. Historical slowly changing dimension tracking is not implemented.
5. The date dimension covers 2005-01-01 through 2015-12-31.
6. Employee and department history is represented through assignment-period fact records.
7. Regional RLS is a static demonstration applied through DimRegion to sales.

---

# 6. Table Summary

| Table | Type | Grain |
|---|---|---|
| DimDate | Dimension | One row per date |
| DimCustomer | Dimension | One row per customer |
| DimProduct | Dimension | One row per product |
| DimRegion | Dimension | One row per sales territory |
| DimEmployee | Dimension | One row per employee |
| DimDepartment | Dimension | One row per department |
| DimVendor | Dimension | One row per vendor |
| DimLocation | Dimension | One row per location |
| FactSales | Fact | One row per sales order line |
| FactPurchases | Fact | One row per purchase order line |
| FactInventory | Fact | One row per product-location snapshot |
| FactWorkOrders | Fact | One row per work order |
| FactEmployeePay | Fact | One row per pay-rate history record |
| FactEmployeeDepartment | Fact | One row per assignment period |

