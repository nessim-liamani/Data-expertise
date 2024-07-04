import os
import pandas as pd
import shutil
from datetime import datetime

# Get the directory of the current script
current_dir = os.path.dirname(os.path.abspath(__file__))

# Define the directories
source_dir = os.path.join(current_dir, '00_source')
treated_dir = os.path.join(current_dir, '01_treated')
log_dir = os.path.join(current_dir, '02_log')
output_file = os.path.join(current_dir, 'concatenated.csv')

def log_message(log_file, message):
    with open(log_file, 'a') as f:
        f.write(message + '\n')

def main():
    # Check if directories exist, if not, create them
    for directory in [source_dir, treated_dir, log_dir]:
        if not os.path.exists(directory):
            os.makedirs(directory)

    # Create log file with timestamp
    timestamp = datetime.now().strftime('%Y%m%d-%H%M%S')
    log_file = os.path.join(log_dir, f'{timestamp}_CSV-Concatenated.log')

    log_message(log_file, f"Process started at {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")

    # Read and concatenate CSV files
    all_data = []
    for file_name in os.listdir(source_dir):
        if file_name.endswith('.csv'):
            file_path = os.path.join(source_dir, file_name)
            log_message(log_file, f"Reading file: {file_path}")
            try:
                data = pd.read_csv(file_path)
                all_data.append(data)
                # Move file to treated directory
                shutil.move(file_path, os.path.join(treated_dir, file_name))
                log_message(log_file, f"Moved file to: {os.path.join(treated_dir, file_name)}")
            except Exception as e:
                log_message(log_file, f"Error reading file {file_path}: {e}")

    # Concatenate all dataframes
    if all_data:
        concatenated_data = pd.concat(all_data)
        concatenated_data.to_csv(output_file, index=False)
        log_message(log_file, f"Concatenated file saved to: {output_file}")
    else:
        log_message(log_file, "No CSV files found to concatenate.")

    log_message(log_file, f"Process completed at {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")

if __name__ == "__main__":
    main()
