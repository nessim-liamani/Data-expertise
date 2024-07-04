USE [Police_Test_00]
GO
/****** Object:  Table [dbo].[Ethnicity Data USA]    Script Date: 30-Jun-24 14:02:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ethnicity Data USA](
	[State] [nvarchar](50) NOT NULL,
	[Total_population] [int] NOT NULL,
	[White] [int] NOT NULL,
	[Black] [int] NOT NULL,
	[Hispanic] [int] NOT NULL,
	[Asian] [int] NOT NULL,
	[American_Indian] [nvarchar](50) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[fatal-police-shootings]    Script Date: 30-Jun-24 14:02:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[fatal-police-shootings](
	[id] [int] NOT NULL,
	[name] [nvarchar](50) NULL,
	[date] [date] NOT NULL,
	[manner_of_death] [nvarchar](50) NOT NULL,
	[armed] [nvarchar](50) NULL,
	[age] [tinyint] NULL,
	[gender] [char](1) NULL,
	[race] [char](1) NULL,
	[city] [nvarchar](50) NOT NULL,
	[state] [char](2) NOT NULL,
	[signs_of_mental_illness] [bit] NOT NULL,
	[threat_level] [nvarchar](50) NOT NULL,
	[flee] [nvarchar](50) NULL,
	[body_camera] [bit] NOT NULL,
	[longitude] [float] NULL,
	[latitude] [float] NULL,
	[is_geocoding_exact] [char](5) NOT NULL,
 CONSTRAINT [PK_fatal-police-shootings] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[fatal-police-shootings-agencies]    Script Date: 30-Jun-24 14:02:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[fatal-police-shootings-agencies](
	[id] [smallint] NOT NULL,
	[name] [nvarchar](max) NOT NULL,
	[type] [nvarchar](50) NULL,
	[state] [nvarchar](50) NOT NULL,
	[oricodes] [nvarchar](max) NULL,
	[total_shootings] [tinyint] NOT NULL,
 CONSTRAINT [PK_fatal-police-shootings-agencies] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[uscities]    Script Date: 30-Jun-24 14:02:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uscities](
	[city] [nvarchar](50) NOT NULL,
	[city_ascii] [nvarchar](50) NOT NULL,
	[state_id] [nvarchar](50) NOT NULL,
	[state_name] [nvarchar](50) NOT NULL,
	[county_fips] [int] NOT NULL,
	[county_name] [nvarchar](50) NOT NULL,
	[county_fips_all] [nvarchar](50) NOT NULL,
	[county_name_all] [nvarchar](50) NOT NULL,
	[lat] [int] NOT NULL,
	[lng] [int] NULL,
	[population] [int] NOT NULL,
	[density] [int] NOT NULL,
	[source] [nvarchar](50) NOT NULL,
	[military] [nvarchar](50) NOT NULL,
	[incorporated] [nvarchar](50) NOT NULL,
	[timezone] [nvarchar](50) NOT NULL,
	[ranking] [tinyint] NOT NULL,
	[zips] [varchar](max) NULL,
	[id] [int] NOT NULL,
 CONSTRAINT [PK_uscities] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
