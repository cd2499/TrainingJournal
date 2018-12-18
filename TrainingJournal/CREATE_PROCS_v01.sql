USE [TrainingJournal]
GO

/****** Object:  StoredProcedure [journal].[GetCalendarMonth]    Script Date: 10/21/2018 2:16:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO














-- =============================================
-- Author:		Greg Olkowski
-- Create date: 03/30/2018
-- Description:	<Description,,>

-- Example: [journal].[GetCalendarMonth] '2018-02'
-- =============================================
CREATE PROCEDURE [journal].[GetCalendarMonth]
	 @YearMonth VARCHAR(16) = NULL 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF @YearMonth IS NULL
	BEGIN
		SET @YearMonth = (SELECT CAST(FORMAT(GETDATE(), 'yyyy-MM') AS varchar(7)));
	END

	IF OBJECT_ID('tempdb..#currmonth') IS NOT NULL DROP TABLE #currmonth
	IF OBJECT_ID('tempdb..#prevmonth') IS NOT NULL DROP TABLE #prevmonth
	IF OBJECT_ID('tempdb..#calendar') IS NOT NULL DROP TABLE #calendar

	/* get focus month */
	SELECT *
	INTO #currmonth
	FROM dbo.DateDim dt WITH (NOLOCK)
	WHERE @YearMonth = year_month_str;

	/* get any days from previous month that spill into calendar view */
	SELECT *
	     ,ROW_NUMBER() OVER (ORDER BY dim_d DESC) rn
	INTO #prevmonth
	FROM dbo.DateDim dt WITH (NOLOCK)
	WHERE dt.year_month_str = (SELECT FORMAT(DATEADD(DAY, -1, curr.dim_d), 'yyyy-MM')
					           FROM #currmonth curr
							   WHERE curr.day_of_month_num = 1)

	SELECT *
	INTO #calendar
	FROM (
	      /* union the results together */
		  SELECT dim_d
		        ,day_of_month_num
				,day_of_week_name_str
				,month_name_str
				,year_month_str
		  FROM #currmonth

		  UNION ALL

		  SELECT dim_d
		        ,day_of_month_num
				,day_of_week_name_str
				,month_name_str
				,year_month_str
		  FROM #prevmonth trailing
		  WHERE trailing.rn < (SELECT day_of_week_num
							   FROM #currmonth curr
							   WHERE curr.day_of_month_num = 1)
		)t1

		SELECT CAST(c.dim_d AS DATETIME) AS CalendarDate
		      ,CAST(c.dim_d AS VARCHAR(10)) AS CalendarDateStr
		      ,c.day_of_month_num AS DayOfMonthNumber
			  ,c.day_of_week_name_str AS DayOfWeekName
			  ,c.month_name_str AS [MonthName]
			  ,eg.GroupShortDesc AS [ExcerciseGroup]
			  ,CASE WHEN dim_d = CAST(GETDATE() AS DATE) THEN 1 ELSE 0 END AS IsToday
			  ,CASE WHEN c.year_month_str != @YearMonth THEN 1 ELSE 0 END AS IsPreviousMonth
			  ,ISNULL(tl.TrainingLogId,-1) AS TrainingLogId
		FROM #calendar c
		LEFT JOIN
			 journal.TrainingLog tl WITH (NOLOCK) ON CAST(tl.TrainingDateTime AS DATE) = c.dim_d
		LEFT JOIN
			 journal.ExerciseGroup eg WITH (NOLOCK) ON eg.ExerciseGroupId = tl.ExerciseGroupId
		ORDER BY dim_d ASC
END
GO

/****** Object:  StoredProcedure [journal].[GetMenuHierarchy]    Script Date: 10/21/2018 2:16:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO











-- =============================================
-- Author:		Greg Olkowski
-- Create date: 03/30/2018
-- Description:	<Description,,>

-- Example: [journal].[GetMenuHierarchy]
-- =============================================
create PROCEDURE [journal].[GetMenuHierarchy]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	SELECT *
	FROM journal.ufnt_ExcerciseMenuHierarchy();

END
GO

/****** Object:  StoredProcedure [journal].[GetSimilarExcerciseEntries]    Script Date: 10/21/2018 2:16:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO








-- =============================================
-- Author:		Greg Olkowski
-- Create date: 03/30/2018
-- Description:	<Description,,>

-- Example:
-- =============================================
CREATE PROCEDURE [journal].[GetSimilarExcerciseEntries]
	 @ExcerciseId INT 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


/* "SWITCH" query */
DECLARE @ExcerciseGroupId INT
DECLARE @ExcerciseFocusId INT

SELECT @ExcerciseGroupId =  ef1.ExcerciseGroupId /* Get the general group for the specific excercise requested */
      ,@ExcerciseFocusId = ef1.ExcerciseFocusId
FROM journal.Excercise e1
INNER JOIN
	 journal.ExcerciseFocus ef1 ON ef1.ExcerciseFocusId = e1.ExcerciseFocusId
								  WHERE e1.ExcerciseId = @ExcerciseId;


								
/** LIMIT IT TO 3 PER EXCERCISE **/

WITH cte_SimilarExc AS (
SELECT tl.TrainingLogId
	  ,tl.TrainingDateTime
	  ,tl.TrainingLocationSId AS LocationShortDesc
	  ,eg.GroupShortDesc
	  ,teo.TrainingLogOrder
	  ,e.ExcerciseShortDesc
	  ,tld.ExcerciseSetOrder
	  ,tld.WeightResistence
	  ,tld.Repetitions
	  ,tld.Comments
	  ,CAST(IIF(tld.ExcerciseId = @ExcerciseId, 1, 0) AS BIT) AS IsSameExc
	  ,CAST(IIF(ef.ExcerciseFocusId = @ExcerciseFocusId, 1, 0) AS BIT) AS IsSameFocus
	  ,CAST(DENSE_RANK() OVER (partition by  tld.excerciseid ORDER BY tl.TrainingDateTime DESC) AS INT) AS ResultCount
FROM journal.TrainingLog tl 
INNER JOIN
	 journal.TrainingLogExcerciseOrder teo	on teo.TrainingLogId = tl.TrainingLogId
INNER JOIN
	 journal.TrainingLogDetails tld ON tld.TrainingLogId = teo.TrainingLogId
	                               AND tld.ExcerciseId = teo.ExcerciseId
INNER JOIN
	 journal.Excercise e on e.ExcerciseId = tld.ExcerciseId
INNER JOIN
	 journal.ExcerciseFocus ef on ef.ExcerciseFocusId = e.ExcerciseFocusId
INNER JOIN
	 journal.ExcerciseGroup eg on eg.ExcerciseGroupId = ef.ExcerciseGroupId

WHERE tl.TrainingDateTime < (SELECT MAX(t1.TrainingDateTime)
                             FROM journal.TrainingLog t1 WITH (NOLOCK)
							 INNER JOIN
								  journal.TrainingLogExcerciseOrder t2 WITH (NOLOCK) ON t1.TrainingLogId = t2.TrainingLogId
							 INNER JOIN
								  journal.Excercise t3 WITH (NOLOCK) ON t3.ExcerciseId = t2.ExcerciseId
							 INNER JOIN
								  journal.ExcerciseFocus t4 WITH (NOLOCK) ON t4.ExcerciseFocusId = t3.ExcerciseFocusId
							 WHERE t4.ExcerciseGroupId = @ExcerciseGroupId)
			)

SELECT
TOP 3

 TrainingLogId
	  ,TrainingDateTime
	  ,LocationShortDesc
	  ,GroupShortDesc
	  ,TrainingLogOrder
	  	  ,ExcerciseShortDesc
	  ,ExcerciseSetOrder
	  ,WeightResistence
	  ,Repetitions
	  ,Comments
	  ,IsSameExc
	  ,IsSameFocus
	  ,DENSE_RANK() OVER (PARTITION BY s.TrainingLogId ORDER BY s.IsSameExc DESC) AS Relevance
FROM cte_SimilarExc s
WHERE s.ResultCount <= 3 /* limit results to last three occurances of an excercise */
ORDER BY s.TrainingDateTime DESC





END
GO

/****** Object:  StoredProcedure [journal].[GetTrainingLogDetails]    Script Date: 10/21/2018 2:16:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO










-- =============================================
-- Author:		Greg Olkowski
-- Create date: 03/02/2018
-- Description:	<Description,,>

-- Example: journal.GetExcerciseGroupDetails NULL
--			journal.GetExcerciseGroupDetails 5
--			journal.GetExcerciseGroupDetials @TrainingLogId

-- =============================================
CREATE PROCEDURE [journal].[GetTrainingLogDetails]
	@TrainingLogId INT = NULL
   ,@ExerciseGroup VARCHAR(32) = NULL
   --,@TrainingDateTime DATETIME = NULL
   ,@TrainingDate DATE = NULL
   ,@TrainingDateStr VARCHAR(10) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @TrainingDateEnd DATE

    IF @TrainingDate IS NULL AND @TrainingDateStr IS NOT NULL
	BEGIN 
		SET @TrainingDate = CAST(@TrainingDateStr AS DATE);
	END
	ELSE IF @TrainingDate IS NULL
	BEGIN
		SET @TrainingDate = (SELECT MAX(TrainingDateTime) FROM journal.TrainingLog WITH (NOLOCK));
	END

	SET @TrainingDateEnd = DATEADD(DAY, 1, @TrainingDate);


	SELECT tl.TrainingLogId
	      ,tl.TrainingDateTime
		  ,loc.LocationShortDesc
		  ,eg.GroupShortDesc
		  ,o.TrainingLogOrder
		  ,e.ExerciseId
		  ,e.ExerciseShortDesc
		  ,tld.ExerciseSetOrder
		  ,tld.WeightResistence
		  ,tld.Repetitions
		  ,tld.Comments
	FROM journal.TrainingLog tl WITH (NOLOCK)
	LEFT JOIN
		 journal.TrainingLocation loc WITH (NOLOCK) ON loc.TrainingLocationSId = tl.TrainingLocationSId
	LEFT JOIN
		 journal.ExerciseGroup eg WITH (NOLOCK) ON eg.ExerciseGroupId = tl.ExerciseGroupId
	LEFT JOIN
		 journal.TrainingLogExerciseOrder o WITH (NOLOCK) ON o.TrainingLogId = tl.TrainingLogId
	LEFT JOIN
		 journal.TrainingLogDetails tld WITH (NOLOCK) ON tld.TrainingLogId = o.TrainingLogId
													 AND tld.ExerciseId = o.ExerciseId
	LEFT JOIN
		 journal.ExerciseLookUp e WITH (NOLOCK) ON e.ExerciseId = tld.ExerciseId
	WHERE tl.TrainingLogId = COALESCE(@TrainingLogId, tl.TrainingLogId)
	AND eg.GroupShortDesc = COALESCE(@ExerciseGroup, eg.GroupShortDesc)
	AND tl.TrainingDateTime >= @TrainingDate AND @TrainingDateEnd > tl.TrainingDateTime
	ORDER BY o.TrainingLogOrder ASC, tld.ExerciseSetOrder ASC




END
GO

/****** Object:  StoredProcedure [journal].[GetTrainingLogDetails_v01]    Script Date: 10/21/2018 2:16:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO








-- =============================================
-- Author:		Greg Olkowski
-- Create date: 03/02/2018
-- Description:	<Description,,>

-- Example: journal.GetExcerciseGroupDetails NULL
--			journal.GetExcerciseGroupDetails 5
--			journal.GetExcerciseGroupDetials @TrainingLogId

-- =============================================
CREATE PROCEDURE [journal].[GetTrainingLogDetails_v01]
	@TrainingLogId INT = NULL
   ,@ExerciseGroup VARCHAR(32) = NULL
   --,@TrainingDateTime DATETIME = NULL
   ,@TrainingDate DATE = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @TrainingDateEnd DATE

    IF @TrainingDate IS NULL
	BEGIN
		SET @TrainingDate = (SELECT MAX(TrainingDateTime) FROM journal.TrainingLog WITH (NOLOCK));
	END

	SET @TrainingDateEnd = DATEADD(DAY, 1, @TrainingDate);


	SELECT tl.TrainingLogId
	      ,tl.TrainingDateTime
		  ,loc.LocationShortDesc
		  ,eg.GroupShortDesc
		  ,o.TrainingLogOrder
		  ,e.ExerciseId
		  ,e.ExerciseShortDesc
		  ,tld.ExerciseSetOrder
		  ,tld.WeightResistence
		  ,tld.Repetitions
		  ,tld.Comments
	FROM journal.TrainingLog tl WITH (NOLOCK)
	LEFT JOIN
		 journal.TrainingLocation loc WITH (NOLOCK) ON loc.TrainingLocationSId = tl.TrainingLocationSId
	LEFT JOIN
		 journal.ExerciseGroup eg WITH (NOLOCK) ON eg.ExerciseGroupId = tl.ExerciseGroupId
	LEFT JOIN
		 journal.TrainingLogExerciseOrder o WITH (NOLOCK) ON o.TrainingLogId = tl.TrainingLogId
	LEFT JOIN
		 journal.TrainingLogDetails tld WITH (NOLOCK) ON tld.TrainingLogId = o.TrainingLogId
													 AND tld.ExerciseId = o.ExerciseId
	LEFT JOIN
		 journal.ExerciseLookUp e WITH (NOLOCK) ON e.ExerciseId = tld.ExerciseId
	WHERE tl.TrainingLogId = COALESCE(@TrainingLogId, tl.TrainingLogId)
	AND eg.GroupShortDesc = COALESCE(@ExerciseGroup, eg.GroupShortDesc)
	AND tl.TrainingDateTime >= @TrainingDate AND @TrainingDateEnd > tl.TrainingDateTime
	ORDER BY o.TrainingLogOrder ASC, tld.ExerciseSetOrder ASC




END
GO

/****** Object:  StoredProcedure [journal].[SetTrainingLog]    Script Date: 10/21/2018 2:16:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO













-- =============================================
-- Author:		Greg Olkowski
-- Create date: 06/09/2018
-- Description:	<Description,,>

-- Example: ...
-- =============================================
CREATE PROCEDURE [journal].[SetTrainingLog]
	 @ExerciseGroupId INT = NULL
	,@TrainingLocationSId VARCHAR(8) = NULL
	,@TrainingLogId INT = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	/** Insert if training entry does not exist yet **/
	IF NOT EXISTS (SELECT 1 FROM journal.TrainingLog WITH (NOLOCK) WHERE TrainingLogId = @TrainingLogId)
		BEGIN
			DECLARE @TrainingDT DATETIME = GETDATE();

			INSERT INTO journal.TrainingLog (TrainingDateTime
											,TrainingLocationSId
											,ExerciseGroupId
											,StartTime)
			VALUES(@TrainingDT
			      ,@TrainingLocationSId
				  ,@ExerciseGroupId
				  ,CAST(@TrainingDT AS TIME))
		END


END
GO


