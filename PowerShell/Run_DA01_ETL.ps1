
# DA-01 Data Warehouse ETL Automation

$Server = "localhost\SQLEXPRESS"
$Database = "DA01_BI"

$LogFolder = Join-Path $PSScriptRoot "..\Logs"
$Timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$LogFile = Join-Path $LogFolder "ETL_$Timestamp.log"

$StartTime = Get-Date

"========================================" | Out-File $LogFile
"DA-01 ETL AUTOMATION" | Out-File $LogFile -Append
"Started: $StartTime" | Out-File $LogFile -Append
"========================================" | Out-File $LogFile -Append

try {

    $Output = & sqlcmd `
        -S $Server `
        -d $Database `
        -E `
        -C `
        -b `
        -Q "EXEC etl.usp_LoadWarehouse;" 2>&1

    $ExitCode = $LASTEXITCODE

    $Output | Out-File $LogFile -Append

    if ($ExitCode -ne 0) {
        throw "SQL Server ETL execution failed. Exit code: $ExitCode"
    }

    "STATUS: SUCCESS" | Out-File $LogFile -Append

}
catch {

    "STATUS: FAILED" | Out-File $LogFile -Append
    "ERROR: $_" | Out-File $LogFile -Append

    throw

}
finally {

    $EndTime = Get-Date
    "Finished: $EndTime" | Out-File $LogFile -Append
    "========================================" | Out-File $LogFile -Append

}
