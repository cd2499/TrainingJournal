USE [TrainingJournal]
GO

/****** Object:  UserDefinedFunction [journal].[GetCurrentActiveTrainingLogId]    Script Date: 10/21/2018 2:17:14 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Gregory M Olkowski
-- Create date: 2018.05.22
-- Description:	Checks for an existing record within 8 hours prior to current time stamp
--				if one exists, its considered the active training session
--				otherwise, return -1 as no active record exists
--				8 hours because i dont expect to train more than twice in a day
--				
-- =============================================
CREATE FUNCTION [journal].[GetCurrentActiveTrainingLogId] 
()
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	DECLARE @CurrentTrainingLogId int = -1;
	
	DECLARE @ActiveRecordTimeCutoff DATETIME = DATEADD(HOUR, -8, GETDATE());

	SELECT @CurrentTrainingLogId = tl.TrainingLogId
	FROM journal.TrainingLog tl WITH (NOLOCK)
	WHERE tl.TrainingDateTime >= @ActiveRecordTimeCutoff;

	RETURN @CurrentTrainingLogId;
END
GO

/****** Object:  UserDefinedFunction [journal].[PeekNextTrainingLogId]    Script Date: 10/21/2018 2:17:14 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Gregory M Olkowski
-- Create date: 2018.05.22
-- Description:	Peek at next TrainingLogId. Used for creating a new
--				journal entry form
-- =============================================
CREATE FUNCTION [journal].[PeekNextTrainingLogId] 
()
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	DECLARE @PeekAtNextTrainingLogId int = -1;
	DECLARE @TrainingTableName VARCHAR(64) = 'journal.TrainingLog';

	
	SET @PeekAtNextTrainingLogId = (SELECT IDENT_CURRENT(@TrainingTableName) + IDENT_INCR(@TrainingTableName));

	-- Return the result of the function
	RETURN @PeekAtNextTrainingLogId

END
GO


