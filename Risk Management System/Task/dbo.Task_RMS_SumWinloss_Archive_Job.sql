USE [bodb_RMS]
GO
/****** Object:  StoredProcedure [dbo].[Task_RMS_SumWinloss_Archive_Job]    Script Date: 2/9/2014 11:36:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  Stored Procedure dbo.Task_RMS_SumWinloss_Archive_Job    Script Date: 12/19/2013 4:02:19 PM ******/
ALTER PROCEDURE [dbo].[Task_RMS_SumWinloss_Archive_Job]
AS
	/*
		Created: Johnson
		Date: 2012-12-12
		Task: Archive RMS data
		DB: SVRCSD/bodb_RMS
		
		Revisions:
			
		Parameter's Explanation:	
	*/ 
BEGIN
	SET NOCOUNT ON
	DECLARE @maxDateSum_Old DATETIME,
			@balanceUpDay	DATETIME ,
			@errCode		INT,
			@errMsg			VARCHAR(1000) 
		
	SELECT	@maxDateSum_Old = MAX(winlostdate) + 1  ---Saturday 
	FROM	dbo.rmSumWinloss_Old WITH (NOLOCK)
	
	IF @maxDateSum_Old IS NULL
		SELECT @maxDateSum_Old = MIN(winlostdate)
		FROM dbo.rmSumWinloss WITH (NOLOCK)

	SELECT TOP 1 @balanceUpDay = winlostdate
	FROM RepDB.dbo.bettrans WITH(NOLOCK)
	WHERE bettype = 20000 AND matchid =0 
	
	WHILE (@maxDateSum_Old < @balanceUpDay) 
	BEGIN
		EXEC Task_RMS_SumWinloss_Archive @winlostdate = @maxDateSum_Old, @errCode = @ErrCode OUTPUT, @errMsg = @ErrMsg OUTPUT
		
		IF @ErrCode > 0
		BEGIN
			RAISERROR(@ErrMsg,16,1)
			RETURN
		END
		
		SELECT @maxDateSum_Old = @maxDateSum_Old + 1			
	END
END