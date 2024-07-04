import pandas as pd
from sqlalchemy import create_engine, text
import pyodbc

# Database connection details
conn_str = (
    "DRIVER={ODBC Driver 17 for SQL Server};"
    "SERVER=localhost;"
    "DATABASE=ATP_0_Main;"
    "UID=root;"
    "PWD=root"
)

# Create the connection engine
engine = create_engine("mssql+pyodbc:///?odbc_connect={}".format(conn_str))

def create_player():
    player_id = input("Enter player ID: ")
    first_name = input("Enter first name: ")
    last_name = input("Enter last name: ")
    hand = input("Enter hand (L/R): ")
    birth_date = input("Enter birth date (YYYY-MM-DD): ")
    country_code = input("Enter country code: ")
    
    query = text(f"""
    INSERT INTO atp_players (player_id, first_name, last_name, hand, birth_date, country_code)
    VALUES ({player_id}, '{first_name}', '{last_name}', '{hand}', '{birth_date}', '{country_code}')
    """)
    
    with engine.begin() as conn:
        conn.execute(query)
    print("Player created successfully.")

def read_players():
    df = pd.read_sql("SELECT * FROM atp_players", engine)
    print(df)

def update_player():
    db_player_id = input("Enter db_player_id of the player to update: ")
    column = input("Enter the column to update: ")
    new_value = input("Enter the new value: ")
    
    query = text(f"UPDATE atp_players SET {column} = '{new_value}' WHERE db_player_id = {db_player_id}")
    
    with engine.begin() as conn:
        conn.execute(query)
    print("Player updated successfully.")

def delete_player():
    db_player_id = input("Enter db_player_id of the player to delete: ")
    
    query = text(f"DELETE FROM atp_players WHERE db_player_id = {db_player_id}")
    
    with engine.begin() as conn:
        conn.execute(query)
    print("Player deleted successfully.")

def create_match():
    # Simplified for brevity; in practice, you would collect all relevant fields
    tourney_id = input("Enter tournament ID: ")
    tourney_name = input("Enter tournament name: ")
    surface = input("Enter surface: ")
    draw_size = input("Enter draw size: ")
    tourney_level = input("Enter tournament level: ")
    tourney_date = input("Enter tournament date (YYYY-MM-DD): ")
    match_num = input("Enter match number: ")
    winner_id = input("Enter winner ID: ")
    winner_seed = input("Enter winner seed: ")
    winner_entry = input("Enter winner entry: ")
    winner_name = input("Enter winner name: ")
    winner_hand = input("Enter winner hand: ")
    winner_ht = input("Enter winner height: ")
    winner_ioc = input("Enter winner IOC: ")
    winner_age = input("Enter winner age: ")
    winner_rank = input("Enter winner rank: ")
    winner_rank_points = input("Enter winner rank points: ")
    loser_id = input("Enter loser ID: ")
    loser_seed = input("Enter loser seed: ")
    loser_entry = input("Enter loser entry: ")
    loser_name = input("Enter loser name: ")
    loser_hand = input("Enter loser hand: ")
    loser_ht = input("Enter loser height: ")
    loser_ioc = input("Enter loser IOC: ")
    loser_age = input("Enter loser age: ")
    loser_rank = input("Enter loser rank: ")
    loser_rank_points = input("Enter loser rank points: ")
    score = input("Enter score: ")
    best_of = input("Enter best of: ")
    round = input("Enter round: ")
    minutes = input("Enter minutes: ")
    w_ace = input("Enter winner ace: ")
    w_df = input("Enter winner double faults: ")
    w_svpt = input("Enter winner service points: ")
    w_1stIn = input("Enter winner first in: ")
    w_1stWon = input("Enter winner first won: ")
    w_2ndWon = input("Enter winner second won: ")
    w_SvGms = input("Enter winner service games: ")
    w_bpSaved = input("Enter winner break points saved: ")
    w_bpFaced = input("Enter winner break points faced: ")
    l_ace = input("Enter loser ace: ")
    l_df = input("Enter loser double faults: ")
    l_svpt = input("Enter loser service points: ")
    l_1stIn = input("Enter loser first in: ")
    l_1stWon = input("Enter loser first won: ")
    l_2ndWon = input("Enter loser second won: ")
    l_SvGms = input("Enter loser service games: ")
    l_bpSaved = input("Enter loser break points saved: ")
    l_bpFaced = input("Enter loser break points faced: ")

    query = text(f"""
    INSERT INTO atp_matches (
        tourney_id, tourney_name, surface, draw_size, tourney_level, tourney_date, match_num, winner_id, winner_seed, winner_entry, winner_name, winner_hand, winner_ht, winner_ioc, winner_age, winner_rank, winner_rank_points, loser_id, loser_seed, loser_entry, loser_name, loser_hand, loser_ht, loser_ioc, loser_age, loser_rank, loser_rank_points, score, best_of, round, minutes, w_ace, w_df, w_svpt, w_1stIn, w_1stWon, w_2ndWon, w_SvGms, w_bpSaved, w_bpFaced, l_ace, l_df, l_svpt, l_1stIn, l_1stWon, l_2ndWon, l_SvGms, l_bpSaved, l_bpFaced
    ) VALUES (
        '{tourney_id}', '{tourney_name}', '{surface}', {draw_size}, '{tourney_level}', '{tourney_date}', {match_num}, {winner_id}, {winner_seed}, '{winner_entry}', '{winner_name}', '{winner_hand}', {winner_ht}, '{winner_ioc}', {winner_age}, {winner_rank}, {winner_rank_points}, {loser_id}, {loser_seed}, '{loser_entry}', '{loser_name}', '{loser_hand}', {loser_ht}, '{loser_ioc}', {loser_age}, {loser_rank}, {loser_rank_points}, '{score}', {best_of}, '{round}', {minutes}, {w_ace}, {w_df}, {w_svpt}, {w_1stIn}, {w_1stWon}, {w_2ndWon}, {w_SvGms}, {w_bpSaved}, {w_bpFaced}, {l_ace}, {l_df}, {l_svpt}, {l_1stIn}, {l_1stWon}, {l_2ndWon}, {l_SvGms}, {l_bpSaved}, {l_bpFaced}
    )
    """)
    
    with engine.begin() as conn:
        conn.execute(query)
    print("Match created successfully.")

def read_matches():
    df = pd.read_sql("SELECT * FROM atp_matches", engine)
    print(df)

def update_match():
    match_id = input("Enter match_id of the match to update: ")
    column = input("Enter the column to update: ")
    new_value = input("Enter the new value: ")
    
    query = text(f"UPDATE atp_matches SET {column} = '{new_value}' WHERE match_id = {match_id}")
    
    with engine.begin() as conn:
        conn.execute(query)
    print("Match updated successfully.")

def delete_match():
    match_id = input("Enter match_id of the match to delete: ")
    
    query = text(f"DELETE FROM atp_matches WHERE match_id = {match_id}")
    
    with engine.begin() as conn:
        conn.execute(query)
    print("Match deleted successfully.")

def main():
    while True:
        print("\nMenu:")
        print("1. Create player")
        print("2. Read players")
        print("3. Update player")
        print("4. Delete player")
        print("5. Create match")
        print("6. Read matches")
        print("7. Update match")
        print("8. Delete match")
        print("9. Exit")
        
        choice = input("Enter your choice: ")
        
        if choice == '1':
            create_player()
        elif choice == '2':
            read_players()
        elif choice == '3':
            update_player()
        elif choice == '4':
            delete_player()
        elif choice == '5':
            create_match()
        elif choice == '6':
            read_matches()
        elif choice == '7':
            update_match()
        elif choice == '8':
            delete_match()
        elif choice == '9':
            break
        else:
            print("Invalid choice. Please try again.")

if __name__ == "__main__":
    main()
