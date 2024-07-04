Data Lab - Police Project : 
***************************

01. Thème
	Le Département de la Justice Américaine vous demande de les aider à comprendre les problèmes qu'il rencontre actuellement avec les services de police du pays.

02. Contexte
	Suite aux récents évènements, la police américaine se trouve accusée de réaliser des discriminations lors de ses différentes interventions.
	En effet, la tendance des fusillades mortelles par la police aux États-Unis semble ne faire qu'augmenter, avec en moyenne 1 000 fusillades mortelles par la police. De plus, ce taux semble beaucoup plus élevé pour les Noirs américains que celui de toute autre ethnie.
	Le FBI a annoncé son intention de revoir la façon dont il suit les affrontements mortels avec la police.
	
	Source: https://www.kaggle.com/mrmorj/data-police-shootings

03. Objectifs du projet

	Appliquer les différents concepts sur une seule étude de cas : "Projet Police"	
		Project name : "Projet Police"
		Main DB name : 'Police_0_Main'
		DWH DB name : 'Police_1_DWH'

	Objectifs administratifs : 
		1. Analyse business et analyse fonctionnelle
			● Modéliser le diagramme de cas d'utilisation
			● Modéliser le schéma de base de données
		2. Intelligence informationnelle pour aide a la prise de decision
		3. Gestion de projet
			● Identifier les livrables et les tâches assignées à chacun d'entre eux (avec une granularité fine)
			● Estimer les tâches précédentes en terme de temps (en jours et heures sachant que le projet prend 4 jours maximum et il y a 6,5 ​​heures par jour).
			● Identifier le chemin critique
			● Analysez vos ressources
			● Affectez-les à vos tâches
			● Gérer les risques
			●…

	Objectifs techniques : Mise en place d’une solution d’analyse de données
		1. Construction d'une base de donnnée OLTP "Police_0_Main".
		2. Traiter/nettoyer les données autant que possible au plus près de la source, en 'T/SQL' / 'Python'.
		3. Construction d'un Data Warehouse OLAP "Police_1_DWH" suivant un modèle multi-dimensionnel en étoile.
		4. Mise en place d'un ETL qui permettra d'ajouter à l'avenir les nouvelles données au fur et mesure.
		5. utilisation des Outils suivants : 
			SQL Server 2022 avec SSMS,
			Scripts Python, 
			Scripts T/SQL, 
			Scripts powershell, 
			Windows Task Scheduller, 
			PowerBI pour visualisation lier les tables.
		6. Exploiter le nouveau modèle et ses données afin d’élaborer des rapports permettant de répondre aux questions qui sont posées dans le point suivant. Ces rapports doivent être réalisés à l’aide de Power BI

04. Requirements : 
	Créer autant de requetes, metriques et visualisations (T/SQL, PowerBI) qui aident à répondre aux questions suivantes : 
		1. Aider à comprendre la situation globale des fusillades mortelles réalisées par la police aux États-Unis.
		2. Aider à comprendre s'il y a une discrimination d'une certaine ethnie parmi d'autres.
		3. Aider à comprendre s'il y a des différences suivant les différentes régions des États-Unis.
		4. Aider à comprendre s'il y a une évolution dans le temps.
		5. Aider à comprendre si la police américaine réalise des bavures policières.

05. Sources de données
	Une base de donnée de staging comprenant ("fatal-police-shootings.csv") :
		● FatalShooting
		● La liste de toutes les fusillades mortelles par la police aux États-Unis entre 2015 et 2022 avec entre autres la date, le nom, le genre de la victime, son ethnie, son âge, la ville, si la victime était armé, si la victime a essayé de s'enfuir, etc...
		● Nombre de lignes : 7505.

	Mise à disposition d’une base de staging contenant déjà d'autres données
		● USCities ("uscities.csv") : 
			○ Des informations sur les villes aux États-Unis.
		● Ethnicity ("Ethnicity Data USA.xlsx") : 
			○ Des informations sur la répartition ethniques aux États-Unis.
		● Departements impliqués dans les fusillades ("fatal-police-shootings-agencies.xlsx") : 
			○ Des informations sur differents departements de securité aux États-Unis.
			
	Ces sources des données peuvent être consolidées afin, par exemple, de comparer la vitesse de propagation des différentes épidémies.

06. Sources de données supplémentaires
	Il s’agit d’un projet pour lequel une partie des données est fournie, toutefois seule une des sources de données doit être obligatoirement utilisée.
	Vous êtes absolument libres de rajouter d’autres sources de données et de les explorer au gré de vos besoins.

07. Délivrables
	1. Backup de votre Data Warehouse.
	2. Fichiers codes sources de Python, T/SQL, powershell, procedure de planification de taches (tous les soir a 1AM) et reporting Power BI.
	3. Project plan expliquant votre démarche et vos résultats.
		○ Comment vous avez choisi de traiter le problème.
		○ Quelles sont les données que vous avez choisies ?
		○ Quels sont les constats que vous avez pu mettre en évidence.
		○ Quelles sont les conclusions que vous pouvez apporter au sujet.
		
08. Annexes

	08.01. Set de données

		File name 01 : "fatal-police-shootings.csv"
			Filetype : Excel XSLX
			Data structure (<column-name> -> <data-type>) : 
				id -> int
				name -> text
				date -> date (dd-MM-YY)
				manner_of_death -> text
				armed -> text
				age -> int
				gender -> text
				race -> text
				city -> text
				state -> text
				signs_of_mental_illness -> Boolean
				threat_level -> text
				flee -> text
				body_camera -> Boolean
				longitude -> DECIMAL(6,3)
				latitude -> DECIMAL(6,3)
				is_geocoding_exact -> Boolean
			Data samples as CSV (séparator : ",") : 
				id,name,date,manner_of_death,armed,age,gender,race,city,state,signs_of_mental_illness,threat_level,flee,body_camera,longitude,latitude,is_geocoding_exact
				3,Tim Elliot,02-01-15,shot,gun,53,M,A,Shelton,WA,TRUE,attack,Not fleeing,FALSE,-123.122,47.247,TRUE
				4,Lewis Lee Lembke,02-01-15,shot,gun,47,M,W,Aloha,OR,FALSE,attack,Not fleeing,FALSE,-122.892,45.487,TRUE
				5,John Paul Quintero,03-01-15,shot and Tasered,unarmed,23,M,H,Wichita,KS,FALSE,other,Not fleeing,FALSE,-97.281,37.695,TRUE
			T/SQL mapping : 
				CREATE TABLE Incidents (
					id INT PRIMARY KEY,
					name NVARCHAR(255) NOT NULL,
					date DATE NOT NULL,
					manner_of_death NVARCHAR(255) NOT NULL,
					armed NVARCHAR(255),
					age INT,
					gender NVARCHAR(1),
					race NVARCHAR(50),
					city NVARCHAR(255),
					state CHAR(2),
					signs_of_mental_illness BIT NOT NULL,
					threat_level NVARCHAR(50),
					flee NVARCHAR(50),
					body_camera BIT NOT NULL,
					longitude DECIMAL(9,6) CHECK (longitude >= -180 AND longitude <= 180),
					latitude DECIMAL(9,6) CHECK (latitude >= -90 AND latitude <= 90),
					is_geocoding_exact BIT NOT NULL,
					CHECK (gender IN ('M', 'F')),
					CHECK (signs_of_mental_illness IN (0, 1)),
					CHECK (body_camera IN (0, 1)),
					CHECK (is_geocoding_exact IN (0, 1))
				);

		File name 02 : "Ethnicity Data USA.xlsx"
			Filetype : Excel XSLX
			Data structure (<column-name> -> <data-type>) : 
				State -> text
				Total population -> int
				White -> int
				Black -> int
				Hispanic -> int
				Asian -> int
				American Indian -> int
			Data samples as CSV (séparator : ",") : 
				State,Total population,White,Black,Hispanic,Asian,American Indian
				Alabama,"4,874,747","3,191,450","1,302,295","201,970","65,494","22,209"
				Alaska,"739,795","448,081","21,192","51,712","48,569","105,146"
				Arizona,"7,016,270","3,836,639","290,379","2,202,173","225,810","274,496"
				Arkansas,"3,004,279","2,173,307","455,500","223,764","46,583","16,901"
				California,"39,536,653","14,616,636","2,164,239","15,477,306","5,679,986","147,880"
				Colorado,"5,607,154","3,822,055","219,500","1,206,724","176,176","32,102"
				Connecticut,"3,588,184","2,393,694","354,320","578,833","162,564","7,486"
			T/SQL mapping : 
				CREATE TABLE EthnicityDataUSA (
					State NVARCHAR(100) NOT NULL,
					TotalPopulation INT NOT NULL,
					White INT NOT NULL,
					Black INT NOT NULL,
					Hispanic INT NOT NULL,
					Asian INT NOT NULL,
					AmericanIndian INT NOT NULL,
					CONSTRAINT CHK_Population CHECK (
						TotalPopulation >= (White + Black + Hispanic + Asian + AmericanIndian)
					)
				);

		File name 03 : "uscities.csv"
			Filetype : CSV (séparator : ";")
			Data structure : 
				city -> text
				city_ascii -> text
				state_id -> text
				state_name -> text
				county_fips -> int
				county_name -> text
				county_fips_all -> text
				county_name_all -> text
				lat -> int
				lng -> int
				population -> int
				density -> int
				source -> text
				military -> Boolean
				incorporated -> Boolean
				timezone -> text
				ranking -> int
				zips -> text
				id -> int
			Data samples as CSV (séparator : ";") : 
				city;city_ascii;state_id;state_name;county_fips;county_name;county_fips_all;county_name_all;lat;lng;population;density;source;military;incorporated;timezone;ranking;zips;id
				North Fort Lewis;North Fort Lewis;WA;Washington;53053;Pierce;53053;Pierce;471221;-1225966;5009;328;polygon;VRAI;VRAI;America/Los_Angeles;3;98433;1840042007
				Bangor Base;Bangor Base;WA;Washington;53035;Kitsap;53035;Kitsap;477227;-1227146;6358;221;polygon;VRAI;VRAI;America/Los_Angeles;3;98315;1840036750
				Fairchild AFB;Fairchild AFB;WA;Washington;53063;Spokane;53063;Spokane;476187;-1176485;2960;172;polygon;VRAI;VRAI;America/Los_Angeles;3;99011;1840073916
			T/SQL mapping : 
				CREATE TABLE USCities (
					city NVARCHAR(255) NOT NULL,
					city_ascii NVARCHAR(255) NOT NULL,
					state_id CHAR(2) NOT NULL,
					state_name NVARCHAR(100) NOT NULL,
					county_fips INT NOT NULL,
					county_name NVARCHAR(255) NOT NULL,
					county_fips_all NVARCHAR(255) NOT NULL,
					county_name_all NVARCHAR(255) NOT NULL,
					lat INT NOT NULL,
					lng INT NOT NULL,
					population INT,
					density INT,
					source NVARCHAR(50),
					military BIT NOT NULL,
					incorporated BIT NOT NULL,
					timezone NVARCHAR(100),
					ranking INT,
					zips NVARCHAR(255),
					id INT PRIMARY KEY
				);

		File name 04 : "fatal-police-shootings-agencies.xlsx"
			Filetype : CSV (séparator : ",")
			Data structure (<column-name> -> <data-type>) : 
				id -> int
				name -> text
				type -> text
				state -> text
				oricodes -> text
				total_shootings -> int
			Data samples as CSV (séparator : ",") : 
				id,name,type,state,oricodes,total_shootings
				2546,Burke County Sheriff's Department,sheriff,GA,GA01700,1
				3070,Candler County Sheriff's Office,sheriff,GA,GA02100,1
				2017,Edgewater Police Department,local_police,FL,FL06406,2
				11673,Georgia Department of Public Safety,state_police,GA,GA01604;GA02206;GA02510;GA03108;GA03312;GA03405;GA04703;GA04710;GA06019;GA06303;GA08503;GA09205;GA11103;GA12105;GA15505,1
				2062,U.S. Marshals Service,federal,FL,FLUSM0100;FLUSM0200;FLUSM0300,3
			T/SQL mapping : 
				CREATE TABLE FatalPoliceShootings (
					id INT PRIMARY KEY,
					name NVARCHAR(255) NOT NULL,
					type NVARCHAR(50) NOT NULL,
					state CHAR(2) NOT NULL,
					oricodes NVARCHAR(MAX) NOT NULL,
					total_shootings INT NOT NULL
				);

	08.02. Python/Pandas Dataframe summary for each set.
		"fatal-police-shootings.csv" : 
			+-------------------------+---------+----------------+---------------+-------------------------+------------+------------+-------------+--------------------+--------------------+----------------------+-----------------+-----------------+-----------+-----------------+--------------------+------------------------+
			|         Column          |  Dtype  | Missing Values | Unique Values |      Sample Value       | Min Length | Max Length | Span Length |        Mean        |       Median       |       Std Dev        | 25th Percentile | 75th Percentile | Num Zeros |      Mode       | Top Frequent Value | Frequency of Top Value |
			+-------------------------+---------+----------------+---------------+-------------------------+------------+------------+-------------+--------------------+--------------------+----------------------+-----------------+-----------------+-----------+-----------------+--------------------+------------------------+
			|           id            |  int32  |       0        |     7504      |          7293           |     1      |     4      |      3      | 4146.931636460555  |       4167.5       |  2344.3438764054217  |     2106.75     |     6183.25     |    0.0    |        3        |         3          |           1            |
			|          name           | object  |      386       |     7086      | Nathan Thomas Honeycutt |     6      |     33     |     27      |        nan         |        nan         |         nan          |       nan       |       nan       |    nan    | Michael Johnson |  Michael Johnson   |           3            |
			|          date           | object  |       0        |     2546      |       2021-09-27        |     10     |     10     |      0      |        nan         |        nan         |         nan          |       nan       |       nan       |    nan    |   2018-01-06    |     2021-11-28     |           9            |
			|     manner_of_death     | object  |       0        |       2       |          shot           |     4      |     16     |     12      |        nan         |        nan         |         nan          |       nan       |       nan       |    nan    |      shot       |        shot        |          7165          |
			|          armed          | object  |      209       |      102      |           gun           |     2      |     32     |     30      |        nan         |        nan         |         nan          |       nan       |       nan       |    nan    |       gun       |        gun         |          4276          |
			|           age           | float64 |      447       |      81       |          26.0           |     3      |     4      |      1      | 37.150063766473004 |        35.0        |  12.939102100301746  |      27.0       |      45.0       |    0.0    |      31.0       |        31.0        |          245           |
			|         gender          | object  |       19       |       2       |            M            |     1      |     1      |      0      |        nan         |        nan         |         nan          |       nan       |       nan       |    nan    |        M        |         M          |          7146          |
			|          race           | object  |      1382      |       6       |           nan           |     1      |     1      |      0      |        nan         |        nan         |         nan          |       nan       |       nan       |    nan    |        W        |         W          |          3124          |
			|          city           | object  |       0        |     3103      |      Happy Valley       |     3      |     30     |     27      |        nan         |        nan         |         nan          |       nan       |       nan       |    nan    |   Los Angeles   |    Los Angeles     |          117           |
			|          state          | object  |       0        |      51       |           OR            |     2      |     2      |      0      |        nan         |        nan         |         nan          |       nan       |       nan       |    nan    |       CA        |         CA         |          1087          |
			| signs_of_mental_illness |  bool   |       0        |       2       |          False          |     4      |     5      |      1      | 0.2138859275053305 |        0.0         | 0.41007456279930027  |       nan       |       nan       |  5899.0   |      False      |       False        |          5899          |
			|      threat_level       | object  |       0        |       3       |          other          |     5      |     12     |      7      |        nan         |        nan         |         nan          |       nan       |       nan       |    nan    |     attack      |       attack       |          4763          |
			|          flee           | object  |      763       |       4       |           Car           |     3      |     11     |      8      |        nan         |        nan         |         nan          |       nan       |       nan       |    nan    |   Not fleeing   |    Not fleeing     |          4283          |
			|       body_camera       |  bool   |       0        |       2       |          False          |     4      |     5      |      1      | 0.1421908315565032 |        0.0         |  0.3492690302451194  |       nan       |       nan       |  6437.0   |      False      |       False        |          6437          |
			|        longitude        | float64 |      712       |     5949      |        -122.514         |     5      |     8      |      3      | -97.04685482921084 | -94.21199999999999 |  16.606625392955717  |   -112.04225    |    -83.07325    |    0.0    |    -112.152     |      -112.134      |           6            |
			|        latitude         | float64 |      712       |     5273      |         45.454          |     4      |     6      |      2      |  36.6673624852768  |       36.093       |  5.3964537074211485  |      33.48      |    40.02525     |    0.0    |     33.495      |       33.495       |           11           |
			|   is_geocoding_exact    |  bool   |       0        |       2       |          True           |     4      |     5      |      1      | 0.9976012793176973 |        1.0         | 0.048921219895461006 |       nan       |       nan       |   18.0    |      True       |        True        |          7486          |
			+-------------------------+---------+----------------+---------------+-------------------------+------------+------------+-------------+--------------------+--------------------+----------------------+-----------------+-----------------+-----------+-----------------+--------------------+------------------------+
			Additional Information:
				Shape: (7504, 17)
				Total Missing Values: 4630
				Total Size (rows * columns): 127568
				Memory Usage: 4.12 MB

		"fatal-police-shootings-agencies.xlsx" : 
			Summary of DataFrame
			+-----------------+--------+----------------+---------------+----------------------------+------------+------------+-------------+-------------------+--------+--------------------+-----------------+-----------------+-----------+-----------------------+-----------------------+------------------------+
			|     Column      | Dtype  | Missing Values | Unique Values |        Sample Value        | Min Length | Max Length | Span Length |       Mean        | Median |      Std Dev       | 25th Percentile | 75th Percentile | Num Zeros |         Mode          |  Top Frequent Value   | Frequency of Top Value |
			+-----------------+--------+----------------+---------------+----------------------------+------------+------------+-------------+-------------------+--------+--------------------+-----------------+-----------------+-----------+-----------------------+-----------------------+------------------------+
			|       id        | int32  |       0        |     3256      |            2775            |     1      |     5      |      4      | 2647.382371007371 | 2059.5 | 3697.2094221449743 |     1184.75     |     2938.25     |    0.0    |         3145          |         3145          |           1            |
			|      name       | object |       0        |     2787      | Caldwell Police Department |     13     |     87     |     74      |        nan        |  nan   |        nan         |       nan       |       nan       |    nan    | U.S. Marshals Service | U.S. Marshals Service |           36           |
			|      type       | object |       12       |       7       |        local_police        |     5      |     12     |      7      |        nan        |  nan   |        nan         |       nan       |       nan       |    nan    |     local_police      |     local_police      |          1948          |
			|      state      | object |       0        |      52       |             ID             |     2      |     2      |      0      |        nan        |  nan   |        nan         |       nan       |       nan       |    nan    |          CA           |          CA           |          253           |
			|    oricodes     | object |      100       |     3122      |          ID01401           |     5      |    1207    |    1202     |        nan        |  nan   |        nan         |       nan       |       nan       |    nan    |        KY00500        |        UT01800        |           2            |
			| total_shootings | int32  |       0        |      49       |             3              |     1      |     3      |      2      | 2.812960687960688 |  1.0   | 5.935006229385722  |       1.0       |       2.0       |    0.0    |           1           |           1           |          1931          |
			+-----------------+--------+----------------+---------------+----------------------------+------------+------------+-------------+-------------------+--------+--------------------+-----------------+-----------------+-----------+-----------------------+-----------------------+------------------------+
			Additional Information:
				Shape: (3256, 6)
				Total Missing Values: 112
				Total Size (rows * columns): 19536
				Memory Usage: 0.80 MB

		"Ethnicity Data USA.xlsx" : 
			Summary of DataFrame
			+------------------+--------+----------------+---------------+--------------+------------+------------+-------------+--------------------+-----------+--------------------+-----------------+-----------------+-----------+---------+--------------------+------------------------+
			|      Column      | Dtype  | Missing Values | Unique Values | Sample Value | Min Length | Max Length | Span Length |        Mean        |  Median   |      Std Dev       | 25th Percentile | 75th Percentile | Num Zeros |  Mode   | Top Frequent Value | Frequency of Top Value |
			+------------------+--------+----------------+---------------+--------------+------------+------------+-------------+--------------------+-----------+--------------------+-----------------+-----------------+-----------+---------+--------------------+------------------------+
			|      State       | object |       0        |      51       |  New Mexico  |     4      |     20     |     16      |        nan         |    nan    |        nan         |       nan       |       nan       |    nan    | Alabama |      Alabama       |           1            |
			| Total population | int32  |       0        |      51       |   2088070    |     6      |     8      |      2      | 6386650.549019608  | 4454189.0 | 7316763.251285247  |    1766400.0    |    7211006.5    |    0.0    | 4874747 |      4874747       |           1            |
			|      White       | int32  |       0        |      51       |    780688    |     6      |     8      |      2      | 3868337.294117647  | 3066146.0 | 3383810.7857579645 |    1327196.0    |    5019664.5    |    0.0    | 3191450 |      3191450       |           1            |
			|      Black       | int32  |       0        |      51       |    38022     |     4      |     7      |      3      | 786854.7647058824  | 354320.0  | 944264.6448873237  |     64277.0     |    1352002.5    |    0.0    | 1302295 |      1302295       |           1            |
			|     Hispanic     | int32  |       0        |      51       |   1018344    |     5      |     8      |      3      | 1153845.7647058824 | 361203.0  | 2697837.6451701657 |    152644.0     |    901545.5     |    0.0    | 201970  |       201970       |           1            |
			|      Asian       | int32  |       0        |      51       |    27514     |     4      |     7      |      3      | 352938.1568627451  | 118312.0  | 831929.0677685296  |     38101.0     |    347836.5     |    0.0    |  65494  |       65494        |           1            |
			| American Indian  | int32  |       0        |      51       |    182991    |     4      |     6      |      2      |      42062.0       |  18335.0  |  61518.1506796165  |     9566.5      |     43659.0     |    0.0    |  22209  |       22209        |           1            |
			+------------------+--------+----------------+---------------+--------------+------------+------------+-------------+--------------------+-----------+--------------------+-----------------+-----------------+-----------+---------+--------------------+------------------------+
			Additional Information:
				Shape: (51, 7)
				Total Missing Values: 0
				Total Size (rows * columns): 357
				Memory Usage: 0.00 MB
		
		"uscities.csv" : 
			+-----------------+--------+----------------+---------------+---------------------+------------+------------+-------------+----------------------+--------------+---------------------+-----------------+-----------------+-----------+-----------------+--------------------+------------------------+
			|     Column      | Dtype  | Missing Values | Unique Values |    Sample Value     | Min Length | Max Length | Span Length |         Mean         |    Median    |       Std Dev       | 25th Percentile | 75th Percentile | Num Zeros |      Mode       | Top Frequent Value | Frequency of Top Value |
			+-----------------+--------+----------------+---------------+---------------------+------------+------------+-------------+----------------------+--------------+---------------------+-----------------+-----------------+-----------+-----------------+--------------------+------------------------+
			|      city       | object |       0        |     19387     |     Tygh Valley     |     3      |     35     |     32      |         nan          |     nan      |         nan         |       nan       |       nan       |    nan    |    Franklin     |      Franklin      |           28           |
			|   city_ascii    | object |       0        |     19382     |     Tygh Valley     |     3      |     35     |     32      |         nan          |     nan      |         nan         |       nan       |       nan       |    nan    |    Franklin     |      Franklin      |           28           |
			|    state_id     | object |       0        |      52       |         OR          |     2      |     2      |      0      |         nan          |     nan      |         nan         |       nan       |       nan       |    nan    |       PA        |         PA         |          1728          |
			|   state_name    | object |       0        |      52       |       Oregon        |     4      |     20     |     16      |         nan          |     nan      |         nan         |       nan       |       nan       |    nan    |  Pennsylvania   |    Pennsylvania    |          1728          |
			|   county_fips   | int32  |       0        |     3209      |        41065        |     4      |     5      |      1      |  29898.015334556407  |   30017.0    | 15826.827986923741  |     17187.0     |     42043.0     |    0.0    |      36103      |       36103        |          146           |
			|   county_name   | object |       0        |     1906      |        Wasco        |     3      |     21     |     18      |         nan          |     nan      |         nan         |       nan       |       nan       |    nan    |    Jefferson    |     Jefferson      |          400           |
			| county_fips_all | object |       0        |     4031      |        41065        |     5      |     29     |     24      |         nan          |     nan      |         nan         |       nan       |       nan       |    nan    |      36103      |       36103        |          146           |
			| county_name_all | object |       0        |     2728      |        Wasco        |     3      |     40     |     37      |         nan          |     nan      |         nan         |       nan       |       nan       |    nan    |    Jefferson    |     Jefferson      |          386           |
			|       lat       | int32  |       0        |     26585     |       452418        |     6      |     6      |      0      |  386617.6703243449   |   393828.0   |  58911.16151911419  |    351660.0     |    418071.0     |    0.0    |     405903      |       310755       |           4            |
			|       lng       | int32  |       0        |     27843     |      -1211693       |     7      |     8      |      1      |  -929293.3022603759  |  -901984.0   | 156976.34552766194  |    -983031.0    |    -817708.0    |    0.0    |     -881291     |      -947182       |           3            |
			|   population    | int32  |       0        |     10792     |         201         |     1      |     9      |      8      |  95043.86306206515   |    1065.0    | 1875546.3575524732  |      323.0      |     6022.0      |   216.0   |        0        |         0          |          216           |
			|     density     | int32  |       0        |     2758      |         20          |     1      |     5      |      4      |  515.8769427809893   |    297.0     |  827.5679470952143  |      115.0      |      600.0      |   317.0   |        0        |         0          |          317           |
			|     source      | object |       0        |       2       |       polygon       |     5      |     7      |      2      |         nan          |     nan      |         nan         |       nan       |       nan       |    nan    |     polygon     |      polygon       |         28886          |
			|    military     |  bool  |       0        |       2       |        False        |     4      |     5      |      1      | 0.003011526878742774 |     0.0      | 0.05479563412374609 |       nan       |       nan       |  28802.0  |      False      |       False        |         28802          |
			|  incorporated   |  bool  |       0        |       2       |        False        |     4      |     5      |      1      |  0.7130395652324414  |     1.0      | 0.4523507783355648  |       nan       |       nan       |  8290.0   |      True       |        True        |         20599          |
			|    timezone     | object |       0        |      38       | America/Los_Angeles |     12     |     30     |     18      |         nan          |     nan      |         nan         |       nan       |       nan       |    nan    | America/Chicago |  America/Chicago   |         11925          |
			|     ranking     | int32  |       0        |       3       |          3          |     1      |     1      |      0      |  2.946554051715186   |     3.0      | 0.23249274203423254 |       3.0       |       3.0       |    0.0    |        3        |         3          |         27395          |
			|      zips       | object |       1        |     24287     |        97063        |     5      |    1853    |    1848     |         nan          |     nan      |         nan         |       nan       |       nan       |    nan    |      78582      |       78582        |           72           |
			|       id        | int32  |       0        |     28889     |     1840018564      |     10     |     10     |      0      |   1838257676.54834   | 1840014817.0 |  19138769.82994292  |  1840007493.0   |  1840022264.0   |    0.0    |   1840042007    |     1840042007     |           1            |
			+-----------------+--------+----------------+---------------+---------------------+------------+------------+-------------+----------------------+--------------+---------------------+-----------------+-----------------+-----------+-----------------+--------------------+------------------------+
			Additional Information:
				Shape: (28889, 19)
				Total Missing Values: 1
				Total Size (rows * columns): 548891
				Memory Usage: 16.53 MB		
	
	08.03. Organization du code
		Voici une description textuelle de la structure du projet et des scripts de code requis :
		
		- **C:\Users\nessi\OneDrive\Documents\DA2024 Projects\python_workspace\06_BI_Labo_00\00_Police_Shootings\**
		  - **00_SourceData**
			- "fatal-police-shootings-agencies.xlsx"
			- "Ethnicity Data USA.xlsx"
			- "uscities.csv"
			- "fatal-police-shootings.csv"
			
		  - **02_Python_Scripts**
			- ETL_00_from_files_to_DB.py
			- ETL_01_from_DB_to_DWH.py
			
		  - **01_SQL_Scripts**
			- 00_Police_Main_DDL.sql
			- 01_Police_DWH_DDL.sql
			- 02_Police_DWH_DQL.sql
			
		  - **03_Powershell_Scripts**
			- run_etl.ps1
			- populate_dwh.ps1
		  
		  - Log (Folder)
		  - Extra (Folder)