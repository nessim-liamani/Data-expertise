import os
import glob
import pandas as pd
import numpy as np
from sqlalchemy import create_engine, text
from sqlalchemy.exc import SQLAlchemyError
import logging
from datetime import datetime
import time
from tabulate import tabulate
from rich import print
from rich.console import Console
from rich.syntax import Syntax
from statistics import mode, StatisticsError
from csv_concatenation import concatenate_csv_files  # Import the function

# USER-DEFINED PARAMETERS
logfile_format = "Log_%Y%m%d-%H%M%S_CSV-2-OLTP.log"
conn_str = "mssql+pyodbc://root:root@localhost/ATP_0_Main?driver=ODBC+Driver+17+for+SQL+Server"

# Set mainscript_dir and base_dir to the directory of the current script and the one for the Source Data CSVs
mainscript_dir = os.path.dirname(os.path.abspath(__file__))
base_data_dir = os.path.join(mainscript_dir, '00_SourceData')

match_dtypes = {
    'tourney_id': 'str',
    'tourney_name': 'str',
    'surface': 'str',
    'draw_size': 'Int64',
    'tourney_level': 'str',
    'tourney_date': 'datetime64[ns]',
    'match_num': 'Int64',
    'winner_id': 'Int64',
    'winner_seed': 'Int64',
    'winner_entry': 'str',
    'winner_name': 'str',
    'winner_hand': 'str',
    'winner_ht': 'Int64',
    'winner_ioc': 'str',
    'winner_age': 'float',
    'winner_rank': 'Int64',
    'winner_rank_points': 'Int64',
    'loser_id': 'Int64',
    'loser_seed': 'Int64',
    'loser_entry': 'str',
    'loser_name': 'str',
    'loser_hand': 'str',
    'loser_ht': 'Int64',
    'loser_ioc': 'str',
    'loser_age': 'float',
    'loser_rank': 'Int64',
    'loser_rank_points': 'Int64',
    'score': 'str',
    'best_of': 'Int64',
    'round': 'str',
    'minutes': 'Int64',
    'w_ace': 'Int64',
    'w_df': 'Int64',
    'w_svpt': 'Int64',
    'w_1stIn': 'Int64',
    'w_1stWon': 'Int64',
    'w_2ndWon': 'Int64',
    'w_SvGms': 'Int64',
    'w_bpSaved': 'Int64',
    'w_bpFaced': 'Int64',
    'l_ace': 'Int64',
    'l_df': 'Int64',
    'l_svpt': 'Int64',
    'l_1stIn': 'Int64',
    'l_1stWon': 'Int64',
    'l_2ndWon': 'Int64',
    'l_SvGms': 'Int64',
    'l_bpSaved': 'Int64',
    'l_bpFaced': 'Int64'
}

player_dtypes = {
    'player_id': 'Int64',
    'first_name': 'str',
    'last_name': 'str',
    'hand': 'str',
    'birth_date': 'datetime64[ns]',
    'country_code': 'str'
}

# ====================================================================================================

def give_INFO(dfs):
    if isinstance(dfs, list):
        for i, df in enumerate(dfs):
            print(f"Summary for DataFrame {i + 1}:")
            _give_INFO(df)
    else:
        _give_INFO(dfs)

def _give_INFO(df):
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
    percentile_25 = df.quantile(0.25, numeric_only=True)
    percentile_75 = df.quantile(0.75, numeric_only=True)
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

    logging.info("\n\n[bold magenta]Summary of DataFrame[/bold magenta]\n" + table)
    logging.info(f"\n[bold cyan]Additional Information:[/bold cyan]\nShape: {df.shape}\nTotal Missing Values: {df.isna().sum().sum()}\nTotal Size (rows * columns): {df.size}\nMemory Usage: {df.memory_usage(deep=True).sum() / (1024 ** 2):.2f} MB")

    return summary_df

def process_dataframe(df, dtypes, date_column=None, date_format=None):
    df = df.replace('', np.nan)
    
    # Fix the birth_date column if it exists and is formatted incorrectly
    if date_column == 'birth_date' and date_column in df.columns:
        df[date_column] = df[date_column].astype(str).str.extract(r'(\d{8})')[0]
    
    for col, dtype in dtypes.items():
        if col in df.columns:
            if 'Int64' in dtype or 'float' in dtype:
                df[col] = pd.to_numeric(df[col], errors='coerce')
            elif 'str' in dtype:
                df[col] = df[col].astype(str).str[:50]

    # Truncate specific column values to required lengths
    if 'hand' in df.columns:
        df['hand'] = df['hand'].str[:1]
    
    if 'winner_hand' in df.columns:
        df['winner_hand'] = df['winner_hand'].str[:1]
    if 'loser_hand' in df.columns:
        df['loser_hand'] = df['loser_hand'].str[:1]
    if 'winner_ioc' in df.columns:
        df['winner_ioc'] = df['winner_ioc'].str[:3]
    if 'loser_ioc' in df.columns:
        df['loser_ioc'] = df['loser_ioc'].str[:3]

    if date_column and date_format and date_column in df.columns:
        df[date_column] = pd.to_datetime(df[date_column], format=date_format, errors='coerce').dt.date
    
    df = df.astype(dtypes, errors='ignore')
    
    return df


def setup_logging():
    script_path = os.path.dirname(os.path.abspath(__file__))
    log_dir = os.path.join(script_path, "01_Log")
    os.makedirs(log_dir, exist_ok=True)
    log_filename = datetime.now().strftime(logfile_format)
    log_filepath = os.path.join(log_dir, log_filename)
    
    logging.basicConfig(
        filename=log_filepath,
        level=logging.INFO,
        format="%(asctime)s - %(levelname)s - %(message)s",
        datefmt="%Y-%m-%d %H:%M:%S"
    )

def get_existing_data(conn, table_name):
    query = text(f"SELECT * FROM {table_name}")
    return pd.read_sql(query, conn)

def filter_new_data(df, existing_df, key_columns):
    # Fill NA values with appropriate placeholders for comparison
    df_filled = df.copy()
    existing_filled = existing_df.copy()

    for col in df.columns:
        if pd.api.types.is_numeric_dtype(df[col]):
            df_filled[col] = df_filled[col].fillna(-99999)  # Use a numerical placeholder
            existing_filled[col] = existing_filled[col].fillna(-99999)
        else:
            df_filled[col] = df_filled[col].fillna("MISSING")
            existing_filled[col] = existing_filled[col].fillna("MISSING")

    df['is_duplicate'] = df_filled.apply(lambda row: (existing_filled[key_columns] == row[key_columns]).all(axis=1).any(), axis=1)
    return df[~df['is_duplicate']].drop(columns=['is_duplicate'])

# ====================================================================================================

if __name__ == "__main__":
    setup_logging()
    engine = create_engine(conn_str)
    error_count = 0
    start_time = time.time()
    
    # Run the CSV concatenation process
    match_csv_files, player_csv_files = concatenate_csv_files(base_data_dir)
    
    with engine.begin() as conn:
        try:
            print("\n================================================\n")
            print("\nDATAFRAME IMPORT INITIATED...\n")

            print("Initiating DataFrame Match data import ...")
            all_match_dfs = process_dataframe(match_csv_files, match_dtypes, date_column='tourney_date', date_format='%Y%m%d')
            print("DataFrame Match data import completed successfully.\n")
            
            print("Initiating DataFrame Player data import ...")
            all_player_dfs = process_dataframe(player_csv_files, player_dtypes, date_column='birth_date', date_format='%Y%m%d')
            print("DataFrame Player data import completed successfully.\n")
            
            # Log information for match and player dataframes
            logging.info("Match DataFrame Summary:")
            give_INFO(all_match_dfs)
            
            logging.info("Player DataFrame Summary:")
            give_INFO(all_player_dfs)
            
            print("\nDATAFRAME IMPORT COMPLETED...\n")
            
            # =================================================================================

            print("\n================================================\n\n")
            print("\nDATABASE EXPORT INITIATED...\n")

            print("Initiating Database Match data export ...")
            all_match_dfs.to_sql('ATP_Matches_Raw', conn, if_exists='append', index=False, chunksize=10000)
            print("Database Match Data import completed successfully.\n")
        
            print("Initiating Database Player data export ...")
            all_player_dfs.to_sql('ATP_Players_Raw', conn, if_exists='append', index=False, chunksize=10000)
            print("Database Player Data import completed successfully.\n")
            
            print("\nDATABASE EXPORT COMPLETED...\n")
            print("\n================================================\n\n")
            
        except SQLAlchemyError as e:
            logging.error(f"An error occurred: {e}")
            error_count += 1
            
        end_time = time.time()
        elapsed_time = end_time - start_time
        elapsed_time_str = time.strftime("%H:%M:%S", time.gmtime(elapsed_time))
        
        logging.info(f"Number of errors encountered: {error_count}")
        logging.info(f"Total execution time: {elapsed_time_str}")

    print(f"Number of errors encountered: {error_count}")
    print(f"Total execution time: {elapsed_time_str}")
