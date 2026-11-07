USE DA01_BI;
GO

SELECT TOP 6
    ETLRunID,
    ProcessName,
    StartTime,
    EndTime,
    Status,
    RowsInserted,
    ErrorMessage
FROM etl.ETLRunLog
ORDER BY ETLRunID DESC;
GO