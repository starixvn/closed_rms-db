ALTER PROCEDURE [dbo].[RMS_Monitor_Parlay_SelectionByTicket_League]
	@selection INT = 2,
	@sporttype INT = 0,
	@winlostdate DATETIME,
	@max_transid BIGINT = 0
AS
	/*
		Created: Johnson
		Date: 2013-10-17
		Task : Get report top leagues by selection and sport
		DB: SVRCSD/bodb_RMS
		
		Revisions:
			
		Parameter's Explanation:
			@sporttype = 0: All sports
						= 1: Soccer only
						= 2: Other sports
						= 3: Combined sports
	*/
SET NOCOUNT ON
----------------
	DECLARE @tmp_Bettrans TABLE(refno bigint, selection int)
	
	if @sporttype = 0 set @sporttype = NULL

	INSERT INTO @tmp_Bettrans (refno, selection)
	SELECT refno, combo
	FROM rmBettrans WITH(NOLOCK)
	WHERE winlostdate >= @winlostdate
		AND matchid = 9 
		AND statusid = 0
		AND currency <> 20
		AND transid <= @max_transid
		AND coalesce(@sporttype, liveawayscore) = liveawayscore
	
	DELETE @tmp_Bettrans WHERE selection <> @selection	
		
	SELECT top 5 leagueid, count(DISTINCT bm.refno) as NoTickets
	FROM RepDB.dbo.bettransm bm WITH(NOLOCK)
		INNER JOIN RepDB.dbo.match m WITH(NOLOCK) ON bm.matchid = m.matchid
	WHERE refno IN (SELECT refno FROM @tmp_Bettrans)
	GROUP BY leagueid
	ORDER BY count(DISTINCT bm.refno) DESC
	
GO
GRANT EXECUTE ON [dbo].[RMS_Monitor_Parlay_SelectionByTicket_League] TO [bodbRMSNet]