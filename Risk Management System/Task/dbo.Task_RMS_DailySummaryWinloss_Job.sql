 ALTER PROCEDURE [dbo].[Task_RMS_DailySummaryWinloss_Job]
AS
	/*
		Created: Johnson
		Date: 2013-10-16
		Task: Task summary winloss RMS
		DB: SVRCSD/bodb_RMS
		
		Revisions:
			
		Parameter's Explanation: 
	*/
SET NOCOUNT ON
	DECLARE @MaxWinlostDate_Sum DATETIME,
			@MaxWinlostDate_RM DATETIME, @ErrCode INT, @ErrMsg NVARCHAR(4000)
	
	SELECT @MaxWinlostDate_Sum = MAX(winlostdate)
	FROM RepDB.dbo.Sum_WinLoss_Cust WITH(NOLOCK)
	
	SELECT @MaxWinlostDate_RM = MAX(winlostdate) + 1
	FROM rmSumWinloss WITH(NOLOCK)

	IF @MaxWinlostDate_RM IS NULL
		SELECT @MaxWinlostDate_RM = MIN(winlostdate)
		FROM RepDB.dbo.bettrans14 WITH(NOLOCK)
		
	WHILE (@MaxWinlostDate_RM <= @MaxWinlostDate_Sum)
	BEGIN
		EXEC [dbo].[Task_RMS_DailySummaryWinloss] @winlostdate = @MaxWinlostDate_RM, @ErrCode = @ErrCode OUTPUT ,@ErrMsg=@ErrMsg OUTPUT
		
		IF @ErrCode > 0
		BEGIN
			RAISERROR(@ErrMsg,16,1)
			RETURN
		END
			
		SELECT @MaxWinlostDate_RM = @MaxWinlostDate_RM + 1 			
	END
