USE [TrainingJournal]
GO

/****** Object:  Table [dbo].[DateDim]    Script Date: 10/21/2018 2:14:41 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[DateDim](
	[dim_d] [date] NOT NULL,
	[date_num] [int] NOT NULL,
	[date_us_name_str] [varchar](11) NULL,
	[date_eu_name_str] [varchar](11) NULL,
	[day_of_week_num] [tinyint] NULL,
	[day_of_week_name_str] [varchar](10) NULL,
	[day_of_month_num] [tinyint] NULL,
	[day_of_year_num] [smallint] NULL,
	[weekday_weekend_str] [varchar](7) NULL,
	[week_of_year_num] [tinyint] NULL,
	[month_name_str] [varchar](10) NULL,
	[month_of_year_num] [tinyint] NULL,
	[last_day_of_month_ind] [bit] NOT NULL,
	[last_business_day_of_month_ind] [bit] NOT NULL,
	[quarter_num] [tinyint] NULL,
	[year_num] [smallint] NULL,
	[year_month_str] [varchar](7) NULL,
	[year_qtr_str] [varchar](7) NULL,
	[federal_holiday_ind] [bit] NOT NULL,
	[business_holiday_ind] [bit] NOT NULL,
	[business_day_month_num] [int] NULL,
	[business_day_year_num] [int] NULL,
	[rec_create_d] [date] NOT NULL
) ON [PRIMARY]
GO

/****** Object:  Table [journal].[BodyWeight]    Script Date: 10/21/2018 2:14:42 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [journal].[BodyWeight](
	[WeightDate] [date] NOT NULL,
	[Weight] [decimal](4, 1) NULL,
	[Comment] [varchar](1024) NULL,
PRIMARY KEY CLUSTERED 
(
	[WeightDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [journal].[ExerciseFocus]    Script Date: 10/21/2018 2:14:42 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [journal].[ExerciseFocus](
	[ExerciseFocusId] [int] IDENTITY(1,1) NOT NULL,
	[FocusDesc] [varchar](64) NULL,
	[ExerciseGroupId] [int] NULL
) ON [PRIMARY]
GO

/****** Object:  Table [journal].[ExerciseGroup]    Script Date: 10/21/2018 2:14:42 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [journal].[ExerciseGroup](
	[ExerciseGroupId] [int] IDENTITY(1,1) NOT NULL,
	[GroupShortDesc] [varchar](16) NULL,
	[GroupLongDesc] [varchar](512) NULL,
PRIMARY KEY CLUSTERED 
(
	[ExerciseGroupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [journal].[ExerciseLookUp]    Script Date: 10/21/2018 2:14:42 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [journal].[ExerciseLookUp](
	[ExerciseId] [int] IDENTITY(1,1) NOT NULL,
	[ExerciseShortDesc] [varchar](32) NULL,
	[ExerciseLongDesc] [varchar](512) NULL,
	[ExerciseFocusId] [int] NOT NULL,
	[IsMachine] [bit] NOT NULL,
	[MachineBrandName] [varchar](256) NULL,
	[IsPerSide] [bit] NOT NULL,
 CONSTRAINT [PK__Exercis__62B6E49330A209E6] PRIMARY KEY CLUSTERED 
(
	[ExerciseId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [journal].[TrainingLocation]    Script Date: 10/21/2018 2:14:42 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [journal].[TrainingLocation](
	[TrainingLocationSId] [varchar](8) NOT NULL,
	[LocationShortDesc] [varchar](16) NULL,
	[LocationLongDesc] [varchar](512) NULL,
PRIMARY KEY CLUSTERED 
(
	[TrainingLocationSId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [journal].[TrainingLog]    Script Date: 10/21/2018 2:14:42 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [journal].[TrainingLog](
	[TrainingLogId] [int] IDENTITY(1,1) NOT NULL,
	[TrainingDateTime] [datetime] NOT NULL,
	[TrainingLocationSId] [varchar](8) NOT NULL,
	[ExerciseGroupId] [int] NOT NULL,
	[StartTime] [time](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[TrainingLogId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [journal].[TrainingLogDetails]    Script Date: 10/21/2018 2:14:42 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [journal].[TrainingLogDetails](
	[TrainingLogId] [int] NOT NULL,
	[ExerciseId] [int] NOT NULL,
	[ExerciseSetOrder] [int] NOT NULL,
	[WeightResistence] [decimal](5, 2) NULL,
	[Repetitions] [int] NULL,
	[Comments] [varchar](4000) NULL
) ON [PRIMARY]
GO

/****** Object:  Table [journal].[TrainingLogExerciseOrder]    Script Date: 10/21/2018 2:14:42 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [journal].[TrainingLogExerciseOrder](
	[TrainingLogId] [int] NOT NULL,
	[TrainingLogOrder] [int] NOT NULL,
	[ExerciseId] [int] NOT NULL,
	[Comments] [varchar](1024) NULL,
PRIMARY KEY CLUSTERED 
(
	[TrainingLogId] ASC,
	[TrainingLogOrder] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[DateDim] ADD  DEFAULT ((0)) FOR [last_business_day_of_month_ind]
GO

ALTER TABLE [dbo].[DateDim] ADD  DEFAULT ((0)) FOR [federal_holiday_ind]
GO

ALTER TABLE [dbo].[DateDim] ADD  DEFAULT ((0)) FOR [business_holiday_ind]
GO

ALTER TABLE [journal].[BodyWeight] ADD  DEFAULT (getdate()) FOR [WeightDate]
GO

ALTER TABLE [journal].[BodyWeight] ADD  DEFAULT (NULL) FOR [Comment]
GO

ALTER TABLE [journal].[ExerciseLookUp] ADD  CONSTRAINT [DF__Exercise__IsMac__76969D2E]  DEFAULT ((0)) FOR [IsMachine]
GO

ALTER TABLE [journal].[ExerciseLookUp] ADD  DEFAULT ((0)) FOR [IsPerSide]
GO

ALTER TABLE [journal].[TrainingLog] ADD  DEFAULT (getdate()) FOR [TrainingDateTime]
GO


