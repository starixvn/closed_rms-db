 ALTER PROCEDURE [dbo].[RMS_CustomerIns]
	@CurrentUserId	INT,
	@username	VARCHAR(30),
	@level		INT,
	@IP			VARCHAR(50),	
	@ErrCode	INT = 0 OUTPUT,
	@ErrMsg		VARCHAR(500) = '' OUTPUT
AS
	/*
		Created: Johnson
		Date: 2013-10-21
		Task: Insert customer for monitoring
		DB: SVRCSD/bodb_RMS
		
		Revisions:
			
		Parameter's Explanation:
	*/
SET NOCOUNT ON

	DECLARE @startRun datetime  
			,@endRun datetime  
			,@duration int		
	
	SET @startRun=GETDATE()
	
	DECLARE @custid INT, @roleid TINYINT
	
	SELECT @custid = custid
	FROM RepDB.[dbo].[CustInfo] WITH(NOLOCK)
	WHERE username = @username
	
	IF ISNULL(@custid ,0) = 0 
	BEGIN
		SELECT @ErrMsg = 'Invalid customer.',
				@ErrCode = 100
		RETURN
	END
	
	IF EXISTS (SELECT 1 FROM rmCustomer WITH(NOLOCK) WHERE custid = @custid)
	BEGIN
		SELECT @ErrMsg = 'This customer is exists.',
				@ErrCode = 102
		RETURN
	END
	
	INSERT INTO rmCustomer (custid, username, [level], createdDate, creator)
	VALUES (@custid, @username, @level, CURRENT_TIMESTAMP, @CurrentUserId)
	
	DECLARE @LogData NVARCHAR(500)	
	
	SELECT @LogData = '<RMS_CustomerIns UserName="' + COALESCE(@Username,SPACE(1)) + '" ' +						
						'level="' + COALESCE(CONVERT(VARCHAR(10),@level),SPACE(1)) + '" ' +
						'IP="' + COALESCE(@IP,SPACE(1)) + '" />'

	SET @endRun = GETDATE()  
	SET @duration  = DATEDIFF (MILLISECOND,@startRun,@endRun)   
	
	EXEC SVRLOG.LogDB.[dbo].[RMS_WriteLog_UserLog_RunSP] 
		@userid		= @CurrentUserId, 
		@actionid	= 10000,	
		@TrackingValue = @LogData, 					
		@duration	= @duration
	
GO 
GRANT EXECUTE ON [dbo].[RMS_CustomerIns] TO [bodbRMSNet]