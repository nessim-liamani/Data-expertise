# Define variables

# SQL Server credentials
$serverName = "localhost"
$databaseName = "Police_Test_00"
$sqlUsername = "root"
$sqlPassword = "root"

# Execution and log file information
$sqlFilePath = "G:\My Drive\DocumentsAdministratifs\Nessim Liamani\Etudes\03_FormationsEtCertificationsPro\ICT\Data Analysis\00_Divers\DA2024_Projects\python_workspace\06_BI_Labo_00\00_Police_Shootings\Police_Project\01_SQL_Scripts\06_Police_2_DWH_DML.sql"
$logDirectory = "G:\My Drive\DocumentsAdministratifs\Nessim Liamani\Etudes\03_FormationsEtCertificationsPro\ICT\Data Analysis\00_Divers\DA2024_Projects\python_workspace\06_BI_Labo_00\00_Police_Shootings\Police_Project\Log"
$logFilePath = Join-Path -Path $logDirectory -ChildPath "$(Get-Date -Format 'yyyyMMdd_HHmmss')_DWH_Police_Log.log"
$errorLogFilePath = Join-Path -Path $logDirectory -ChildPath "$(Get-Date -Format 'yyyyMMdd_HHmmss')_DWH_Police_ErrorLog.log"

# Email alert information
$emailFrom = "your_email@example.com"
$emailTo = "alert_email@example.com"
$smtpServer = "your_smtp_server"

# SQL Server command line utility path
$sqlcmdPath = "sqlcmd" # Ensure sqlcmd is in your system PATH

# Function to send email alert
function Send-EmailAlert {
    param (
        [string]$subject,
        [string]$body
    )
    Send-MailMessage -From $emailFrom -To $emailTo -Subject $subject -Body $body -SmtpServer $smtpServer
}

# Function to execute SQL script and log output
function Execute-SqlScript {
    try {
        $command = "$sqlcmdPath -S $serverName -d $databaseName -U $sqlUsername -P $sqlPassword -i `"$sqlFilePath`" -o `"$logFilePath`""
        Invoke-Expression -Command $command

        # Check if the log file contains any error messages
        if (Select-String -Path $logFilePath -Pattern "Msg \d{1,5}, Level \d{1,2}, State \d{1,2}" -Quiet) {
            throw "Errors were found in the SQL execution log."
        }

        Write-Output "SQL script executed successfully. Log file: $logFilePath"
    } catch {
        $errorMessage = "An error occurred while executing the SQL script. Error: $_"
        Write-Error $errorMessage

        # Log the error message to a separate error log file
        $errorMessage | Out-File -FilePath $errorLogFilePath -Append

        # Send an email alert if configured
        if ($emailTo) {
            Send-EmailAlert -subject "SQL Script Execution Error" -body $errorMessage
        }
    }
}

# Main script execution
try {
    Execute-SqlScript
} catch {
    Write-Error "Failed to execute the main script. Error: $_"
    if ($emailTo) {
        Send-EmailAlert -subject "Script Execution Failure" -body "Failed to execute the main script. Error: $_"
    }
}
