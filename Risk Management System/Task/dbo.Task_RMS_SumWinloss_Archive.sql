USE [bodb_RMS]
GO
/****** Object:  StoredProcedure [dbo].[Task_RMS_SumWinloss_Archive]    Script Date: 09/27/2013 10:06:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Task_RMS_SumWinloss_Archive]
	@winlostdate	DATETIME,
	@errCode		INT				= 0 OUTPUT,
	@errMsg			VARCHAR(1000)	= '' OUTPUT
 AS
	/*
		Created: Johnson
		Date: 2013-10-16
		Task: Archive rmSumWinloss to rmSumWinloss_Old
		DB: SVRCSD/bobdb_RMS
		
		Revisions:
			
		Parameter's Explanation:
		
	*/
SET NOCOUNT ON
BEGIN
	INSERT INTO rmSumWinloss_old(
		[winlostdate]
      ,[custid]
      ,[sporttype]
      ,[statusid]
      ,[combo]
      ,[username]
      ,[currency]
      ,[stake]
      ,[winlost]
      ,[company_stake]
      ,[company_winlost]
      ,[actualrate]
      ,[odds]
      ,[betcount] 
      ,[agentid]     
	)
	SELECT [winlostdate]
      ,[custid]
      ,[sporttype]
      ,[statusid]
      ,[combo]
      ,[username]
      ,[currency]
      ,[stake]
      ,[winlost]
      ,[company_stake]
      ,[company_winlost]
      ,[actualrate]
      ,[odds]
      ,[betcount]     
      ,[agentid]
  FROM [dbo].[rmSumWinloss] WITH(NOLOCK)
  WHERE winlostdate = @winlostdate
  
  IF @@ERROR = 0
  BEGIN   
	DELETE rmSumWinloss WITH(ROWLOCK) WHERE winlostdate = @winlostdate
  END
  ELSE
  BEGIN
	SELECT  @ErrCode = 100,
			@ErrMsg = 'Archiving data failed for date :' + CONVERT(VARCHAR(10),@winlostdate,120)
	RETURN
 END
 
 
END  


