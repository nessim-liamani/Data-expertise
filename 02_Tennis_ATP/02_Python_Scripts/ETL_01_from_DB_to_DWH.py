import pandas as pd
from sqlalchemy import create_engine

# Source and destination database connection strings
source_engine = create_engine('mssql+pyodbc://root:root@server/ATP_0_Main?driver=SQL+Server')
dest_engine = create_engine('mssql+pyodbc://root:root@server/ATP_1_DWH?driver=SQL+Server')

# Load data from main database
players = pd.read_sql('SELECT * FROM atp_players', source_engine)
matches = pd.read_sql('SELECT * FROM atp_matches', source_engine)

# Insert data into data warehouse
players.to_sql('dim_players', con=dest_engine, if_exists='replace', index=False)
matches.to_sql('fact_matches', con=dest_engine, if_exists='replace', index=False)
