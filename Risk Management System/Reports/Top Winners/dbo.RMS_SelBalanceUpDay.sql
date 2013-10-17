 ALTER PROCEDURE [dbo].[RMS_SelBalanceUpDay]
AS
	/*
		Created: Johnson
		Date: 2013-10-17
		Task: Get move bets day and balance up day for RMS
		DB: SVRCS/bodb_RMS
		
		Revisions:
		
		Parameter's Explanation: 
	*/ 
SET NOCOUNT ON
	DECLARE @BalanceUpDay smalldatetime, @MoveBetsDay smalldatetime
	SELECT 
		TOP 1 @BalanceUpDay = winlostdate
	FROM RepDB.dbo.Bettrans WITH(NOLOCK)
	WHERE bettype = 20000 and matchid = 0
	
	SELECT    
		@MoveBetsDay = MAX(eventdate)  
	FROM RepDB.dbo.match14 WITH(NOLOCK)  
	

	select @BalanceUpDay as BalanceUpDay, @MoveBetsDay as MoveBetsDay


GO
GRANT EXECUTE ON [dbo].[RMS_SelBalanceUpDay] TO [bodbRMSNet]