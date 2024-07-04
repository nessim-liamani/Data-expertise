import os
import pandas as pd
import shutil
from datetime import datetime

def log_message(log_file, message):
    with open(log_file, 'a') as f:
        f.write(message + '\n')

def concatenate_csv_files(base_dir):
    # Define directories
    source_dir = os.path.join(base_dir, '00_source')
    matches_dir = os.path.join(source_dir, '00_Matches')
    players_dir = os.path.join(source_dir, '01_Players')
    treated_matches_dir = os.path.join(base_dir, '01_treated', '00_Matches')
    treated_players_dir = os.path.join(base_dir, '01_treated', '01_Players')
    log_dir = os.path.join(base_dir, '03_log')
    concatenated_matches_dir = os.path.join(base_dir, '02_Concatenated', '00_Matches')
    concatenated_players_dir = os.path.join(base_dir, '02_Concatenated', '01_Players')

    # Create necessary directories if they do not exist
    for directory in [matches_dir, players_dir, treated_matches_dir, treated_players_dir, log_dir, concatenated_matches_dir, concatenated_players_dir]:
        if not os.path.exists(directory):
            os.makedirs(directory)

    # Create log file with timestamp
    timestamp = datetime.now().strftime('%Y%m%d-%H%M%S')
    log_file = os.path.join(log_dir, f'{timestamp}_CSV-Concatenated.log')

    log_message(log_file, f"Process started at {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")

    # Initialize lists to hold data
    matches_data = []
    players_data = []

    # Process files in matches directory
    for file_name in os.listdir(matches_dir):
        if file_name.endswith('.csv'):
            file_path = os.path.join(matches_dir, file_name)
            log_message(log_file, f"Reading file: {file_path}")
            try:
                data = pd.read_csv(file_path, encoding='ISO-8859-1')  # Specify encoding here
                matches_data.append(data)
                # Move file to treated directory
                shutil.move(file_path, os.path.join(treated_matches_dir, file_name))
                log_message(log_file, f"Moved file to: {os.path.join(treated_matches_dir, file_name)}")
            except Exception as e:
                log_message(log_file, f"Error reading file {file_path}: {e}")

    # Process files in players directory
    for file_name in os.listdir(players_dir):
        if file_name.endswith('.csv'):
            file_path = os.path.join(players_dir, file_name)
            log_message(log_file, f"Reading file: {file_path}")
            try:
                data = pd.read_csv(file_path, encoding='ISO-8859-1')  # Specify encoding here
                players_data.append(data)
                # Move file to treated directory
                shutil.move(file_path, os.path.join(treated_players_dir, file_name))
                log_message(log_file, f"Moved file to: {os.path.join(treated_players_dir, file_name)}")
            except Exception as e:
                log_message(log_file, f"Error reading file {file_path}: {e}")

    # Concatenate matches data
    if matches_data:
        concatenated_matches = pd.concat(matches_data, ignore_index=True)
        matches_output_file = os.path.join(concatenated_matches_dir, f'{timestamp}_Consolidated_Matches.csv')
        # Ensure the directory for the output file exists
        output_dir = os.path.dirname(matches_output_file)
        if not os.path.exists(output_dir):
            os.makedirs(output_dir)
        concatenated_matches.to_csv(matches_output_file, index=False)
        log_message(log_file, f"Concatenated matches file saved to: {matches_output_file}")
    else:
        log_message(log_file, "No matches CSV files found to concatenate.")
        concatenated_matches = pd.DataFrame()  # Return an empty DataFrame if no data is found

    # Concatenate players data
    if players_data:
        concatenated_players = pd.concat(players_data, ignore_index=True)
        players_output_file = os.path.join(concatenated_players_dir, f'{timestamp}_Consolidated_Players.csv')
        # Ensure the directory for the output file exists
        output_dir = os.path.dirname(players_output_file)
        if not os.path.exists(output_dir):
            os.makedirs(output_dir)
        concatenated_players.to_csv(players_output_file, index=False)
        log_message(log_file, f"Concatenated players file saved to: {players_output_file}")
    else:
        log_message(log_file, "No players CSV files found to concatenate.")
        concatenated_players = pd.DataFrame()  # Return an empty DataFrame if no data is found

    log_message(log_file, f"Process completed at {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")

    return concatenated_matches, concatenated_players
