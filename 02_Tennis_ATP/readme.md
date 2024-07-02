# ATP Project

## Business Requirements

### 1. Objectives of the Project
The objective of this project is to apply various concepts to a single case study, "ATP Project," which includes:

- Business Analysis & Functional Analysis
- Business Intelligence
- Project Management

---

### 2. Business Analysis and Functional Analysis

#### 2.1. Case Study
The ATP and WTA want an app that will enable them to store information about their business. The specific requirements include:

- Create, read, update, and delete players' profiles and their coaches'
- Create, read, update, and delete tournaments with detailed information such as dates, level, type of court, draws, organizers, tournament director, referees, umpires, linesmen, ball boys, prize money, sponsors, etc.
- Manage anti-doping testings ([Anti-Doping Rules](https://www.itftennis.com/antidoping/rules/tadp-overview.aspx))
- Manage rankings
- Manage broadcasting rights

#### 2.2. Your Tasks
**Business Analysis:**

- Understand the rules of the game
- Model the process of tournament organization
- Model the process of anti-doping testing

**Functional Analysis:**

- Model the Use Case Diagram
- Model the DB Schema
- Model the State Chart for the player

---

### 3. Business Intelligence

#### 3.1. Case Study
The ATP and WTA want to collect and store data to:

- Increase traffic by improving fan experience and engagement (e.g., [Wimbledon using real-time sports statistics](http://www.ibmbigdatahub.com/blog/wimbledon-using-real-time-sports-statistics-fan-engagem))
- Propose data-based strategies for players and coaches through self-service descriptive statistics and correlations
- Promote factual analysis over intuition with descriptive stats and causal relationships for journalists and commentators ([Infosys Tennis Experience](https://www.infosys.com/stories/immersed-game/Documents/tennis-experience-digital-age.pdf))

#### 3.2. Case Study
Here are some articles explaining/showing how data can be used in tennis:

- [Using real-time sports statistics for fan engagement](http://www.ibmbigdatahub.com/blog/wimbledon-using-real-time-sports-statistics-fan-engagement)
- [How tennis joined the data revolution](https://nest.latrobe/how-tennis-joined-the-data-revolution/)
- [How data analytics is changing tennis](https://www.silicon.co.uk/data-storage/how-data-analytics-changing-tennis-175134?inf_by=5af992a8671db8190d8b4771)
- [Big Data will guide tennis players to the No. 1 spot](https://www.bbva.com/en/wta-ranking-big-data-will-guide-tennis-players-to-the-no-1-spot/)
- [Infosys Tennis Experience in the Digital Age](https://www.infosys.com/stories/immersed-game/Documents/tennis-experience-digital-age.pdf)

#### 3.3. Case Study
Key questions the organizations want to answer include:

- Who won the most matches between 2010 and 2017?
- What is the average duration of a best of 3-set match?
- Who hit the most aces in 2010, 2011, etc.?
- When is any player more likely to beat Roger Federer, and on which surface?
- Who won the most matches on grass/clay/hard court?
- Who won the most Davis Cup/Fed Cup matches?

#### 3.4. Case Study
Additional questions include:

- How many matches has a player won after losing the first two sets?
- How unlikely was Stan Wawrinka’s Australian Open victory? And Marin Cilic’s US Open victory? ([Wawrinka’s unlikely victory](http://www.ibmbigdatahub.com/blog/how-unlikely-was-wawrinkas-australian-open-victory))
- Is there a correlation between the number of aces and the winner of the match?

---

### 4. Project Management

#### 4.1. Project Management Activities
Manage the project with standard project management practices:

- Identify tasks
- Estimate them
- Identify the critical path
- Analyze resources
- Assign resources to tasks
- Manage risks

Use 'OpenProj' or 'ProjectLibre' and provide a filled file to import into either tool.

#### 4.2. Your Tasks: Planning
The planning timeline spans seven days, divided into key milestones and deliverables:

**Day 1:**
- Introduction to the case study, including expected deliverables and practical details

**End of Day 2:**
- Deliver planning documentation and business analysis

**End of Day 4:**
- Deliver functional analysis and multi-dimensional model

**End of Day 6:**
- 80% of dimension tables loaded

**Day 7:**
- Final review and completion of any outstanding tasks

---

## Appendices

### Appendix 00 - GitHub Sources Organization

**00_SourceData:**
- `atp_matches_qual_chall_1999.csv` to `atp_matches_qual_chall_2017.csv`
- `atp_players.csv`

**01_SQL_Scripts:**
- `00_ATP_Main_DDL.sql`
- `01_ATP_DWH_DDL.sql`
- `02_ATP_DWH_DQL.sql`

**02_Python_Scripts:**
- `ETL_01_from_DB_to_DWH.py`
- `ETL_00_from_CVS_to_DB.py`

**03_Powershell_Scripts:**
- `populate_dwh.ps1`

**Log:**
- `20240701_213722_DWH_ATP_Log.log`
- `20240701_213932_DWH_ATP_Log.log`
- ...

### Appendix 01 - "00_SourceData" Notes

**ATP Tennis Rankings, Results, and Stats:**
- Master ATP player file and historical rankings
- Player file columns: `player_id, first_name, last_name, hand, birth_date, country_code`
- Ranking file columns: `ranking_date, ranking, player_id, ranking_points`

**Match Results Database:**
- Up to three files per season: tour-level main draw matches, tour-level qualifying and challenger main-draw matches, futures matches
- Includes biographical information, ranking data, and match statistics

**MatchStats:**
- Included from 1991-present for tour-level matches, 2008-present for challengers, and 2011-present for tour-level qualifying

### Appendix 02 - Project Sources

**Description:**
- ATP results and players information
- Additional relevant information such as countries, continents, and tournament information

**ATP Results Files:**
- `atp_matches_qual_chall_1999.csv` to `atp_matches_qual_chall_2017.csv`
- Common columns: `
tourney_id, 
tourney_name, 
surface, draw_size, tourney_level, tourney_date, match_num, winner_id, winner_seed, winner_entry, winner_name, winner_hand, winner_ht, winner_ioc, winner_age, winner_rank, winner_rank_points, loser_id, loser_seed, loser_entry, loser_name, loser_hand, loser_ht, loser_ioc, loser_age, loser_rank, loser_rank_points, score, best_of, round, minutes, w_ace, w_df, w_svpt, w_1stIn, w_1stWon, w_2ndWon, w_SvGms, w_bpSaved, w_bpFaced, l_ace, l_df, l_svpt, l_1stIn, l_1stWon, l_2ndWon, l_SvGms, l_bpSaved, l_bpFaced`

**Players Information:**
- File: `atp_players.csv`
- Columns: `player_id, first_name, last_name, hand, birth_date, country_code`

---

## SQL Server Database Specifications

**dbo.atp_matches:**

```sql
CREATE TABLE dbo.atp_matches (
    match_id INT IDENTITY(1,1) PRIMARY KEY,
    tourney_id VARCHAR(50),
    tourney_name VARCHAR(100),
    surface VARCHAR(50),
    draw_size INT,
    tourney_level CHAR(1),
    tourney_date DATE,
    match_num INT,
    winner_id INT,
    winner_seed INT,
    winner_entry VARCHAR(50),
    winner_name VARCHAR(100),
    winner_hand CHAR(1),
    winner_ht INT,
    winner_ioc VARCHAR(3),
    winner_age FLOAT,
    winner_rank INT,
    winner_rank_points INT,
    loser_id INT,
    loser_seed INT,
    loser_entry VARCHAR(50),
    loser_name VARCHAR(100),
    loser_hand CHAR(1),
    loser_ht INT,
    loser_ioc VARCHAR(3),
    loser_age FLOAT,
    loser_rank INT,
    loser_rank_points INT,
    score VARCHAR(50),
    best_of INT,
    round VARCHAR(10),
    minutes INT,
    w_ace INT,
    w_df INT,
    w_svpt INT,
    w_1stIn INT,
    w_1stWon INT,
    w_2ndWon INT,
    w_SvGms INT,
    w_bpSaved INT,
    w_bpFaced INT,
    l_ace INT,
    l_df INT,
    l_svpt INT,
    l_1stIn INT,
    l_1stWon INT,
    l_2ndWon INT,
    l_SvGms INT,
    l_bpSaved INT,
    l_bpFaced INT
);
```

**dbo.atp_players:**

```sql
CREATE TABLE dbo.atp_players (
    db_player_id INT IDENTITY(1,1) PRIMARY KEY,
    player_id INT,
    first_name VARCHAR

(50),
    last_name VARCHAR(50),
    hand CHAR(1),
    birth_date DATE,
    country_code VARCHAR(3)
);
```
