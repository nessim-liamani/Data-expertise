import os
import pandas as pd
import numpy as np
import logging
from datetime import datetime
import time
from tabulate import tabulate
from rich import print
from rich.console import Console
from rich.syntax import Syntax
from statistics import mode, StatisticsError

# USER-DEFINED PARAMETERS
logfile_format = "Log_%Y%m%d-%H%M%S_CSV-2-OLTP.log"

file_00_XLSX_fatal_police_shootings_agencies = r'C:\Users\nessi\OneDrive\DA2024_Projects\python_workspace\06_BI_Labo_00\00_Police_Shootings\Police_Project\00_SourceData\fatal-police-shootings-agencies.xlsx'
file_01_XLSX_Ethnicity_Data_USA = r'C:\Users\nessi\OneDrive\DA2024_Projects\python_workspace\06_BI_Labo_00\00_Police_Shootings\Police_Project\00_SourceData\Ethnicity Data USA.xlsx'
file_02_CSV_uscities = r'C:\Users\nessi\OneDrive\DA2024_Projects\python_workspace\06_BI_Labo_00\00_Police_Shootings\Police_Project\00_SourceData\uscities.csv'
file_03_CSV_fatal_police_shootings = r'C:\Users\nessi\OneDrive\DA2024_Projects\python_workspace\06_BI_Labo_00\00_Police_Shootings\Police_Project\00_SourceData\fatal-police-shootings.csv'

file_00_XLSX_fatal_police_shootings_agencies_Types = {
    'id': 'int',
    'name': 'str',
    'type': 'str',
    'state': 'str',
    'oricodes': 'str',
    'total_shootings': 'int'
}

file_01_XLSX_Ethnicity_Data_USA_Types = {
    'State': 'str',
    'Total population': 'int',
    'White': 'int',
    'Black': 'int',
    'Hispanic': 'int',
    'Asian': 'int',
    'American Indian': 'int'
}

file_02_CSV_uscities_Types = {
    'city': 'str',
    'city_ascii': 'str',
    'state_id': 'str',
    'state_name': 'str',
    'county_fips': 'int',
    'county_name': 'str',
    'county_fips_all': 'str',
    'county_name_all': 'str',
    'lat': 'int',
    'lng': 'int',
    'population': 'int',
    'density': 'int',
    'source': 'str',
    'military': 'str',  # Temporary type to handle conversion
    'incorporated': 'str',  # Temporary type to handle conversion
    'timezone': 'str',
    'ranking': 'int',
    'zips': 'str',
    'id': 'int'
}

file_03_CSV_fatal_police_shootings_Types = {
    'id': 'int',
    'name': 'str',
    'type': 'str',
    'state': 'str',
    'oricodes': 'str',
    'total_shootings': 'int'
}

def give_INFO(df):
    dtypes = df.dtypes
    isnull = df.isna().sum()
    nunique = df.nunique()
    sample = df.sample(n=1).T.iloc[:, 0]
    min_len = df.apply(lambda x: x.dropna().astype(str).map(len).min())
    max_len = df.apply(lambda x: x.dropna().astype(str).map(len).max())
    span_len = max_len - min_len
    mean = df.mean(numeric_only=True)
    median = df.median(numeric_only=True)
    stddev = df.std(numeric_only=True)
    
    # Exclude boolean columns for quantile calculations
    numeric_df = df.select_dtypes(include=[np.number])
    percentile_25 = numeric_df.quantile(0.25, numeric_only=True)
    percentile_75 = numeric_df.quantile(0.75, numeric_only=True)
    num_zeros = df.apply(lambda x: (x == 0).sum() if pd.api.types.is_numeric_dtype(x) else np.nan)

    try:
        mode_values = df.apply(lambda x: mode(x.dropna()) if x.dropna().size > 0 else None)
    except StatisticsError:
        mode_values = df.apply(lambda x: None)
        
    top_freq_val = df.apply(lambda x: x.value_counts().idxmax() if x.value_counts().size > 0 else None)
    top_freq = df.apply(lambda x: x.value_counts().max() if x.value_counts().size > 0 else None)

    summary_df = pd.concat([dtypes, isnull, nunique, sample, min_len, max_len, span_len, mean, median, stddev, percentile_25, percentile_75, num_zeros, mode_values, top_freq_val, top_freq], axis=1)
    summary_df = summary_df.reset_index()
    summary_df.columns = ['Column', 'Dtype', 'Missing Values', 'Unique Values', 'Sample Value', 'Min Length', 'Max Length', 'Span Length', 'Mean', 'Median', 'Std Dev', '25th Percentile', '75th Percentile', 'Num Zeros', 'Mode', 'Top Frequent Value', 'Frequency of Top Value']

    table = tabulate(summary_df, headers='keys', tablefmt='pretty', showindex=False)
    console = Console()
    console.print("[bold magenta]Summary of DataFrame[/bold magenta]")
    console.print(Syntax(table, "markdown", theme="monokai"))

    console.print("\n[bold cyan]Additional Information:[/bold cyan]")
    console.print(f"[bold yellow]Shape:[/bold yellow] {df.shape}")
    console.print(f"[bold yellow]Total Missing Values:[/bold yellow] {df.isna().sum().sum()}")
    console.print(f"[bold yellow]Total Size (rows * columns):[/bold yellow] {df.size}")
    console.print(f"[bold yellow]Memory Usage:[/bold yellow] {df.memory_usage(deep=True).sum() / (1024 ** 2):.2f} MB")

    logging.info("\n[bold magenta]Summary of DataFrame[/bold magenta]\n" + table)
    logging.info(f"\n[bold cyan]Additional Information:[/bold cyan]\nShape: {df.shape}\nTotal Missing Values: {df.isna().sum().sum()}\nTotal Size (rows * columns): {df.size}\nMemory Usage: {df.memory_usage(deep=True).sum() / (1024 ** 2):.2f} MB\n\n")

    return summary_df

def process_file(file_path, dtypes, date_column=None, date_format=None, separator=','):
    file_extension = os.path.splitext(file_path)[1].lower()
    
    if file_extension == '.xlsx':
        df = pd.read_excel(file_path, dtype=dtypes)
        print(f"Columns in Excel file {file_path}: {df.columns.tolist()}")  # Debugging step
        if date_column and date_format:
            if date_column in df.columns:
                df[date_column] = pd.to_datetime(df[date_column], format=date_format)
            else:
                print(f"Column '{date_column}' not found in the file {file_path}. Available columns: {df.columns.tolist()}")
    elif file_extension == '.csv':
        df = pd.read_csv(file_path, dtype=dtypes, sep=separator)
        if date_column and date_format:
            df[date_column] = pd.to_datetime(df[date_column], format=date_format)
        
        # Convert military and incorporated columns to boolean for uscities.csv
        if 'military' in df.columns:
            df['military'] = df['military'].apply(lambda x: True if x.lower() in ['true', 'vrai'] else False)
        if 'incorporated' in df.columns:
            df['incorporated'] = df['incorporated'].apply(lambda x: True if x.lower() in ['true', 'vrai'] else False)
    else:
        raise ValueError("Unsupported file type")
    
    return df

def setup_logging():
    script_path = os.path.dirname(os.path.abspath(__file__))
    log_dir = os.path.join(script_path, "Log")
    os.makedirs(log_dir, exist_ok=True)
    log_filename = datetime.now().strftime(logfile_format)
    log_filepath = os.path.join(log_dir, log_filename)
    
    logging.basicConfig(
        filename=log_filepath,
        level=logging.INFO,
        format="%(asctime)s - %(levelname)s - %(message)s",  # Corrected format string
        datefmt="%Y-%m-%d %H:%M:%S"
    )

# ====================================================================================================

if __name__ == "__main__":
    setup_logging()
    error_count = 0
    start_time = time.time()

    print("\n================================================\n")
    print("\n'fatal_police_shootings.csv' DATAFRAME IMPORT INITIATED...\n")  
    file_03_CSV_fatal_police_shootings_df = process_file(file_03_CSV_fatal_police_shootings, file_03_CSV_fatal_police_shootings_Types)
    logging.info("'fatal-police-shootings.csv' DataFrame Summary:")
    give_INFO(file_03_CSV_fatal_police_shootings_df)
    print("\nDATAFRAME IMPORT COMPLETED...\n\n")
    
    print("\n================================================\n")
    print("\n'fatal_police_shootings_agencies.xlsx' DATAFRAME IMPORT INITIATED...\n")  
    file_00_XLSX_fatal_police_shootings_agencies_df = process_file(file_00_XLSX_fatal_police_shootings_agencies, file_00_XLSX_fatal_police_shootings_agencies_Types)
    logging.info("'fatal-police-shootings-agencies.xlsx' DataFrame Summary:")
    give_INFO(file_00_XLSX_fatal_police_shootings_agencies_df)
    print("\nDATAFRAME IMPORT COMPLETED...\n\n")

    print("\n================================================\n")
    print("\n'Ethnicity_Data_USA.xlsx' DATAFRAME IMPORT INITIATED...\n")  
    file_01_XLSX_Ethnicity_Data_USA_df = process_file(file_01_XLSX_Ethnicity_Data_USA, file_01_XLSX_Ethnicity_Data_USA_Types)
    logging.info("'Ethnicity Data USA.xlsx' DataFrame Summary:")
    give_INFO(file_01_XLSX_Ethnicity_Data_USA_df)
    print("\nDATAFRAME IMPORT COMPLETED...\n\n")
    
    print("\n================================================\n")
    print("\n'uscities.csv' DATAFRAME IMPORT INITIATED...\n")  
    file_02_CSV_uscities_df = process_file(file_02_CSV_uscities, file_02_CSV_uscities_Types, separator=';')
    logging.info("'uscities.csv' DataFrame Summary:")
    give_INFO(file_02_CSV_uscities_df)
    print("\nDATAFRAME IMPORT COMPLETED...\n\n")
    

