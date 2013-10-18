 ALTER PROCEDURE [dbo].[RMS_UserInfoUpdStatus]
	@AdminID	INT,
	@CustID		INT,
	@enabled	BIT,
	@IP			VARCHAR(50),
	@ErrCode	INT = 0 OUTPUT,
	@ErrMsg		VARCHAR(500) = '' OUTPUT
AS
	/*
		Created: Johnson
		Date: 2013-10-18
		Task: Update enable's status of user
		DB: SVRCSD/bodb_RMS
		
		Revisions:
			
		Parameter's Explanation:

	*/
SET NOCOUNT ON
	DECLARE @startRun datetime  
		,@endRun datetime  
		,@duration int		
	
	SET @startRun=GETDATE()
	
	EXEC dbo.RMS_UserCheckPermission @UserID = @AdminID ,@FuncKey = 'ManageUser', @ErrCode = @ErrCode OUTPUT, @ErrMsg = @ErrMsg OUTPUT
	
	IF @ErrCode > 0
		RETURN
		
	DECLARE @db_enabled BIT
	
	SELECT @db_enabled = enabled FROM rmUserInfo WITH(NOLOCK) WHERE userid = @CustID
	
	IF @@ROWCOUNT = 0
	BEGIN
		SELECT @ErrMsg = 'This user not exists',
				@ErrCode = 100
		RETURN		
	END
	
	IF @db_enabled = @enabled
		RETURN
	
	UPDATE rmUserInfo WITH(UPDLOCK,ROWLOCK)
	SET enabled = @enabled
	WHERE UserID = @CustID
	
	DECLARE @LogData VARCHAR(4000)
	SELECT @LogData = '<RMS_UserInfoUpdStatus CustID="' + COALESCE(CONVERT(VARCHAR(10),@CustID),SPACE(1)) + '" ' +
						'enabled="' + COALESCE(CONVERT(VARCHAR(1),@enabled),SPACE(1)) + '" ' +						
						'IP="' + COALESCE(@IP,SPACE(1)) + '" />'
					
	SET @endRun = GETDATE()  
	SET @duration  = DATEDIFF (MILLISECOND,@startRun,@endRun)   
	
	EXEC SVRLOG.LogDB.dbo.RMS_WriteLog_UserLog_RunSP  
		@UserID			= @AdminID, 
		@CustID			= @CustID,				
		@ActionID		= 10300, 
		@TrackingValue	= @LogData, 
		@duration		= @duration
		
		
		
GO
GRANT EXECUTE ON [dbo].[RMS_UserInfoUpdStatus] TO [bodbRMSNet]