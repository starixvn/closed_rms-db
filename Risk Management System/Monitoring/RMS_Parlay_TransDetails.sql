  ALTER PROCEDURE [dbo].[RMS_Parlay_TransDetails]
	@refno	BIGINT
 AS
	/*	
		Created: Johnson
		Date: 2013-10-18
		DB: SVRCSD/bodb_RMS
		Task: get details selection of parlay tickets
		
		Revisions:
		
		Parameter's Explanation:
		
	*/
SET NOCOUNT ON

	SELECT
		bettrans.transid, 
		bettrans.bettype,
		match.homeid,
		match.awayid,
		bettrans.hdp1, 
		bettrans.hdp2, 
		bettrans.odds,
		bettrans.betteam,
		bettrans.statusid,
		bettrans.status,
		bettrans.livehomescore, 
		bettrans.liveawayscore, 
		bettrans.liveindicator, 
		match.leagueid,
		match.sporttype,
		match.isNeutral as IsNeutral,
		match.matchid,
		match.matchcode,
		match.betstatus
	from 
		(SELECT matchid,  Bettype, transid,hdp1, hdp2, odds, betteam, statusid, status,
				livehomescore,liveawayscore,liveindicator
		FROM RepDB.dbo.BettransM with (nolock)
		WHERE refno=@refno ) AS bettrans
	INNER JOIN RepDB.dbo.match with (nolock) ON bettrans.matchid=match.matchid
	UNION 
	SELECT
		bettrans.transid, 
		bettrans.bettype,
		match.homeid,
		match.awayid,
		bettrans.hdp1, 
		bettrans.hdp2, 
		bettrans.odds,
		bettrans.betteam,
		bettrans.statusid,
		bettrans.status,
		bettrans.livehomescore, 
		bettrans.liveawayscore, 
		bettrans.liveindicator, 
		match.leagueid,
		match.sporttype,
		match.isNeutral as IsNeutral,
		match.matchid,
		match.matchcode,		
		match.betstatus
	from 
		(SELECT matchid,  Bettype, transid,hdp1, hdp2, odds, betteam, statusid, status,
				livehomescore,liveawayscore,liveindicator
		FROM RepDB.dbo.BettransM14 with (nolock)
		WHERE refno=@refno ) AS bettrans
	INNER JOIN RepDB.dbo.match14  as [match] with (nolock) ON bettrans.matchid=match.matchid

GO
GRANT EXECUTE ON [dbo].[RMS_Parlay_TransDetails] TO [bodbRMSNet]