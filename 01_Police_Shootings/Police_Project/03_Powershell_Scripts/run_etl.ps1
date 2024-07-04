# Set the paths to the ETL Python scripts
$etlScriptPathFromFilesToDB = "C:\Users\nessi\OneDrive\Documents\DA2024 Projects\python_workspace\06_BI_Labo_00\00_Police_Shootings\02_Python_Scripts\ETL_00_from_files_to_DB.py"
$etlScriptPathFromDBToDWH = "C:\Users\nessi\OneDrive\Documents\DA2024 Projects\python_workspace\06_BI_Labo_00\00_Police_Shootings\02_Python_Scripts\ETL_01_from_DB_to_DWH.py"

# Execute the ETL script to load data from files to the main database
Write-Output "Running the ETL script to load data from files to the main database..."
python $etlScriptPathFromFilesToDB
Write-Output "Data loading from files to main database completed."

# Execute the ETL script to populate the Data Warehouse
Write-Output "Running the ETL script to populate the Data Warehouse..."
python $etlScriptPathFromDBToDWH
Write-Output "ETL script execution for Data Warehouse population completed."
