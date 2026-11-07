SELECT
    s.name AS SchemaName,
    t.name AS TableName,
    SUM(p.rows) AS TotalRows
FROM sys.tables AS t
INNER JOIN sys.schemas AS s
    ON t.schema_id = s.schema_id
LEFT JOIN sys.partitions AS p
    ON t.object_id = p.object_id
    AND p.index_id IN (0, 1)
WHERE t.name IN (
    'SalesOrderHeader',
    'SalesOrderDetail',
    'Customer',
    'Product',
    'ProductSubcategory',
    'ProductCategory',
    'SalesTerritory',
    'SalesPerson',
    'Employee',
    'Department',
    'EmployeeDepartmentHistory',
    'PurchaseOrderHeader',
    'PurchaseOrderDetail',
    'Vendor',
    'WorkOrder'
)
GROUP BY s.name, t.name
ORDER BY s.name, t.name;