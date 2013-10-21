 ALTER PROCEDURE [dbo].[Task_RMS_SyncDataForBettransParlay]	
AS
/*   
 Task : arrange rmBetTrans data
 DB: SVRCSD/bodb_RMS 
 Revisions:   
  - 20131016@Johnson: create SP   
  
*/  
SET NOCOUNT ON
SET DEADLOCK_PRIORITY LOW	

declare @tstamp_min binary(8), @tstamp_max binary(8)

SELECT @tstamp_min = CAST(CAST(ISNULL(VValue, 0) as bigint)+1 as binary(8))
FROM dbo.rmSettings with (rowlock)
WHERE VName = 'rmBettransSync'	

SELECT @tstamp_max = isnull(max(tstamp),@tstamp_min)  from RepDB.dbo.bettrans with(nolock)

IF @tstamp_min = 0x0000000000000001 -- 1: renew all data
BEGIN
	TRUNCATE TABLE dbo.rmBettrans
	
	INSERT INTO [dbo].[rmBetTrans] ([TransId] ,[CustId] ,[TransDate] ,[OddsId] ,[Hdp1] ,[Hdp2] ,[Odds] ,[Stake] ,[Status] ,[WinLost] ,
	[PlayerComm] ,[PlayerDiscount] ,[TWinLost] ,[TComm] ,[TPositionTaking] ,[TDiscount] ,[AgentIdList] ,[AgentPositionTakingList] ,
	[AgentDiscountList] ,[LiveHomeScore] ,[LiveAwayScore] ,[LiveIndicator] ,[BetTeam] ,[Creator] ,[RefNo] ,[WinLostDate] ,[BetFrom] ,
	[BetCheck] ,[CheckTime] ,[OddsSpread] ,[ActualRate] ,[MatchId] ,[Ruben] ,[BetId] ,[StatusWinLost] ,[MOdds] ,[BetType] ,[Actual_Stake] ,
	[Currency] ,[IP] ,[TransDesc] ,[Username] ,[CurrencyName] ,[VirtualRate] ,[StatusId] ,[DoubleCommLosing] ,[SecAcceptFlag] ,[OddsType] ,
	[balance], [Combo], [AgentID]) 
	SELECT 
		[TransId] ,b.[CustId] ,[TransDate] ,[OddsId] ,[Hdp1] ,[Hdp2] ,[Odds] ,[Stake] , b.[Status] ,[WinLost] ,
		[PlayerComm] ,[PlayerDiscount] ,[TWinLost] ,[TComm] ,[TPositionTaking] ,[TDiscount] ,[AgentIdList] ,[AgentPositionTakingList] ,
		[AgentDiscountList] ,[LiveHomeScore] ,[LiveAwayScore] ,[LiveIndicator] ,[BetTeam] , b.[Creator] ,[RefNo] ,[WinLostDate] ,[BetFrom] ,
		[BetCheck] ,[CheckTime] ,[OddsSpread] ,[ActualRate] ,[MatchId] ,[Ruben] ,[BetId] ,[StatusWinLost] ,[MOdds] ,[BetType] ,[Actual_Stake] ,
		b.[Currency] ,[IP] ,[TransDesc] ,b.[Username] ,[CurrencyName] ,[VirtualRate] ,[StatusId] ,b.[DoubleCommLosing] ,[SecAcceptFlag] ,[OddsType] ,
		[balance], RIGHT(betcheck,len(betcheck)-1), c.AgentId
	FROM RepDB.dbo.bettrans b with (NOLOCK)
		INNER JOIN RepDB.[dbo].[CustInfo] c WITH(NOLOCK) ON b.custid = c.custid
	WHERE matchid in (9,29)	
END
ELSE 
BEGIN
	SELECT	[TransId] ,[CustId] ,[TransDate] ,[OddsId] ,[Hdp1] ,[Hdp2] ,[Odds] ,[Stake] ,[Status] ,[WinLost] ,
		[PlayerComm] ,[PlayerDiscount] ,[TWinLost] ,[TComm] ,[TPositionTaking] ,[TDiscount] ,[AgentIdList] ,[AgentPositionTakingList] ,
		[AgentDiscountList] ,[LiveHomeScore] ,[LiveAwayScore] ,[LiveIndicator] ,[BetTeam] ,[Creator] ,[RefNo] ,[WinLostDate] ,[BetFrom] ,
		[BetCheck] ,[CheckTime] ,[OddsSpread] ,[ActualRate] ,[MatchId] ,[Ruben] ,[BetId] ,[StatusWinLost] ,[MOdds] ,[BetType] ,[Actual_Stake] ,
		[Currency] ,[IP] ,[TransDesc] ,[Username] ,[CurrencyName] ,[VirtualRate] ,[StatusId] ,[DoubleCommLosing] ,[SecAcceptFlag] ,[OddsType] ,
		[balance], RIGHT(betcheck,len(betcheck)-1) as combo
	INTO #temp			
	FROM RepDB.dbo.bettrans with (NOLOCK)
	WHERE tstamp between @tstamp_min and @tstamp_max
		and matchid in (9,29)
		
	MERGE dbo.rmBettrans as d	
		USING #temp s on d.transid = s.transid	
		WHEN MATCHED THEN 
			UPDATE SET 
				[TransId] = s.TransId
				,[CustId] = s.CustId 
				,[TransDate] = s.TransDate 
				,[OddsId] = s.OddsId
				,[Hdp1] = s.Hdp1 
				,[Hdp2] = s.Hdp2
				,[Odds] = s.Odds 
				,[Stake] = s.Stake 
				,[Status] = s.Status 
				,[WinLost] = s.WinLost 
				,[PlayerComm] = s.PlayerComm 
				,[PlayerDiscount] =s.PlayerDiscount 
				,[TWinLost] = s.TWinLost 
				,[TComm] = s.TComm 
				,[TPositionTaking] = s.TPositionTaking 
				,[TDiscount] = s.TDiscount 
				,[AgentIdList] = s.AgentIdList 
				,[AgentPositionTakingList] = s.AgentPositionTakingList 
				,[AgentDiscountList] = s.AgentDiscountList 
				,[LiveHomeScore] = s.LiveHomeScore 
				,[LiveAwayScore] = s.LiveAwayScore 
				,[LiveIndicator] = s.LiveIndicator 
				,[BetTeam] = s.BetTeam 
				,[Creator] = s.Creator 
				,[RefNo] = s.RefNo 
				,[WinLostDate] = s.WinLostDate 
				,[BetFrom] = s.BetFrom 
				,[BetCheck] = s.BetCheck 
				,[CheckTime] = s.CheckTime 
				,[OddsSpread] = s.OddsSpread 
				,[ActualRate] = s.ActualRate 
				,[MatchId] = s.MatchId 
				,[Ruben] = s.Ruben 
				,[BetId] = s.BetId 
				,[StatusWinLost]= s.StatusWinLost 
				,[MOdds] = s.MOdds 
				,[BetType] = s.BetType 
				,[Actual_Stake] = s.Actual_Stake 
				,[Currency] = s.Currency 
				,[IP] = s.IP 
				,[TransDesc] = s.TransDesc 
				,[Username] = s.Username 
				,[CurrencyName] = s.CurrencyName
				,[VirtualRate] = s.VirtualRate 
				,[StatusId] = s.StatusId 
				,[DoubleCommLosing] = s.DoubleCommLosing 
				,[SecAcceptFlag] = s.SecAcceptFlag
				,[OddsType] = s.OddsType 
				,[balance] = s.balance
				,[combo] = s.combo
		WHEN NOT MATCHED THEN 
		INSERT ([TransId] ,[CustId] ,[TransDate] ,[OddsId] ,[Hdp1] ,[Hdp2] ,[Odds] ,[Stake] ,[Status] ,[WinLost] ,
			[PlayerComm] ,[PlayerDiscount] ,[TWinLost] ,[TComm] ,[TPositionTaking] ,[TDiscount] ,[AgentIdList] ,[AgentPositionTakingList] ,
			[AgentDiscountList] ,[LiveHomeScore] ,[LiveAwayScore] ,[LiveIndicator] ,[BetTeam] ,[Creator] ,[RefNo] ,[WinLostDate] ,[BetFrom] ,
			[BetCheck] ,[CheckTime] ,[OddsSpread] ,[ActualRate] ,[MatchId] ,[Ruben] ,[BetId] ,[StatusWinLost] ,[MOdds] ,[BetType] ,[Actual_Stake] ,
			[Currency] ,[IP] ,[TransDesc] ,[Username] ,[CurrencyName] ,[VirtualRate] ,[StatusId] ,[DoubleCommLosing] ,[SecAcceptFlag] ,[OddsType] ,
			[balance] ,[combo]
			)
		VALUES (
			s.TransId ,s.CustId ,s.TransDate ,s.OddsId ,s.Hdp1 ,s.Hdp2 ,s.Odds ,s.Stake ,s.Status ,s.WinLost ,
			s.PlayerComm ,s.PlayerDiscount ,s.TWinLost ,s.TComm ,s.TPositionTaking ,s.TDiscount ,s.AgentIdList ,s.AgentPositionTakingList ,
			s.AgentDiscountList ,s.LiveHomeScore ,s.LiveAwayScore ,s.LiveIndicator ,s.BetTeam ,s.Creator ,s.RefNo ,[WinLostDate] ,[BetFrom] ,
			s.BetCheck ,s.CheckTime ,s.OddsSpread ,s.ActualRate ,s.MatchId ,s.Ruben ,s.BetId ,s.StatusWinLost ,s.MOdds ,s.BetType ,s.Actual_Stake ,
			s.Currency ,s.IP ,s.TransDesc ,s.Username ,s.CurrencyName ,s.VirtualRate ,s.StatusId ,s.DoubleCommLosing ,s.SecAcceptFlag ,s.OddsType ,
			s.balance, s.combo
		)
	;--end MERGE	
END

UPDATE dbo.rmSettings with(rowlock, updlock)
SET VValue = CAST(CAST(@tstamp_max as bigint) as varchar(200))
WHERE VName = 'rmBettransSync'	

SET NOCOUNT OFF

