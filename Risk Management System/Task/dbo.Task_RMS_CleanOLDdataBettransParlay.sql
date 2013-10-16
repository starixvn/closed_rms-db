 ALTER PROCEDURE [dbo].[Task_RMS_CleanOLDdataBettransParlay]
AS
/*   
 Task : remove before movebet data for rmBettrans
 DB: SVRCSD/bodb_RMS
 Revisions:   
  - 20131016@Johnson: create SP  
 
*/  
BEGIN
	SET NOCOUNT ON 
	DECLARE @MoveBetsDay smalldatetime

	SELECT @MoveBetsDay = max(eventdate)   
	FROM RepDB.dbo.match14 WITH(NOLOCK) 

	DELETE FROM dbo.rmBettrans WITH(rowlock) WHERE Winlostdate <= @MoveBetsDay
END