import pandas as pd
from sqlalchemy import create_engine

# Load data
df_shootings = pd.read_csv('00_SourceData/fatal-police-shootings.csv')
df_ethnicity = pd.read_excel('00_SourceData/Ethnicity Data USA.xlsx')
df_cities = pd.read_csv('00_SourceData/uscities.csv', delimiter=';')
df_agencies = pd.read_excel('00_SourceData/fatal-police-shootings-agencies.xlsx')

# Clean data
df_shootings.dropna(inplace=True)
df_ethnicity.fillna(0, inplace=True)
df_cities.drop_duplicates(inplace=True)
df_agencies.dropna(inplace=True)

# Save cleaned data to SQL
engine = create_engine('mssql+pyodbc://username:password@server/dbname')
df_shootings.to_sql('Incidents', engine, if_exists='replace', index=False)
df_ethnicity.to_sql('EthnicityDataUSA', engine, if_exists='replace', index=False)
df_cities.to_sql('USCities', engine, if_exists='replace', index=False)
df_agencies.to_sql('FatalPoliceShootings', engine, if_exists='replace', index=False)
