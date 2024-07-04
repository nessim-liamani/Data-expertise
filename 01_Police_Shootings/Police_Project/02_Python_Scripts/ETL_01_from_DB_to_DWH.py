import pyodbc

# Connect to the databases
conn_main = pyodbc.connect('DSN=PoliceMainDB;UID=user;PWD=password')
conn_dwh = pyodbc.connect('DSN=PoliceDWHDB;UID=user;PWD=password')

cursor_main = conn_main.cursor()
cursor_dwh = conn_dwh.cursor()

# Extract data from main database
cursor_main.execute("SELECT * FROM Incidents")
incidents = cursor_main.fetchall()

cursor_main.execute("SELECT * FROM EthnicityDataUSA")
ethnicity = cursor_main.fetchall()

cursor_main.execute("SELECT * FROM USCities")
cities = cursor_main.fetchall()

cursor_main.execute("SELECT * FROM FatalPoliceShootings")
agencies = cursor_main.fetchall()

# Transform and Load data into Data Warehouse
for row in incidents:
  cursor_dwh.execute("""
    INSERT INTO FactIncidents (IncidentID, Date, MannerOfDeath, Armed, Age, Gender, Race, City, State, SignsOfMentalIllness, ThreatLevel, Flee, BodyCamera, Longitude, Latitude)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
  """, row)

for row in ethnicity:
  cursor_dwh.execute("""
    INSERT INTO DimEthnicity (EthnicityID, State, TotalPopulation, White, Black, Hispanic, Asian, AmericanIndian)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?)
  """, row)

for row in cities:
  cursor_dwh.execute("""
    INSERT INTO DimCity (CityID, City, State, Population, Density)
    VALUES (?, ?, ?, ?, ?)
  """, row)

for row in agencies:
  cursor_dwh.execute("""
    INSERT INTO DimAgency (AgencyID, Name, Type, State)
    VALUES (?, ?, ?, ?)
  """, row)

# Commit and close
conn_dwh.commit()
conn_main.close()
conn_dwh.close()
