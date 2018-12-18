USE [TrainingJournal]
GO

/****** Object:  UserDefinedFunction [journal].[ufnt_ExcerciseMenuHierarchy]    Script Date: 10/21/2018 2:16:41 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [journal].[ufnt_ExcerciseMenuHierarchy]()
RETURNS 
	@menu TABLE 
(
	-- Add the column definitions for the TABLE variable here
	 MenuId INT IDENTITY(1,1) NOT NULL
	,MenuItem VARCHAR(128)
	,ParentMenuItemId INT
	,ParentMenuItem VARCHAR(128)
)
AS
BEGIN
	-- Fill the table variable with the rows for your result set
	INSERT INTO @menu (MenuItem
					  ,ParentMenuItem)
	SELECT CONCAT(e.MachineBrandName + ': ', e.ExcerciseShortDesc) AS MenuItem
						  ,ef.FocusDesc AS ParentMenuItem
	FROM journal.Excercise e WITH (NOLOCK)
	INNER JOIN	 
		journal.ExcerciseFocus ef WITH (NOLOCK) ON e.ExcerciseFocusId = ef.ExcerciseFocusId
	
	UNION ALL

	SELECT ef.FocusDesc AS MenuItem
		  ,eg.GroupShortDesc AS ParentMenuItem
	FROM journal.ExcerciseFocus ef WITH (NOLOCK)
	INNER JOIN
		journal.ExcerciseGroup eg WITH (NOLOCK) ON eg.ExcerciseGroupId = ef.ExcerciseGroupId

	UNION ALL

	SELECT eg.GroupShortDesc AS MenuItem
		,NULL AS ParentMenuItem
	FROM journal.ExcerciseGroup eg WITH (NOLOCK);

	UPDATE child
	SET ParentMenuItemId = parent.MenuId
	FROM @menu child
	INNER JOIN
		 @menu parent ON parent.MenuItem = child.ParentMenuItem
	WHERE child.ParentMenuItem IS NOT NULL




	RETURN 
END
GO


