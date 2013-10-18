 ALTER PROCEDURE [dbo].[RMS_UserInfoUpdUserPwd]
	@AdminID	INT,
	@CustID		INT,
	@userpwd	NVARCHAR(50),
	@IP			VARCHAR(50),
	@ErrCode	INT = 0 OUTPUT,
	@ErrMsg		VARCHAR(500) = '' OUTPUT
AS
	/*
		Created: Johnson
		Date: 2013-10-18
		Task: Update user's password
		DB: SVRCUST/CustDB
		
		Revisions:
			
		Parameter's Explanation:
	*/ 
SET NOCOUNT ON

	DECLARE @startRun datetime  
			,@endRun datetime  
			,@duration int		
		
	SET @startRun=GETDATE()
	
	IF @AdminID <> @CustID
	BEGIN
		EXEC DBRMS.bodb_RMS.dbo.RMS_UserCheckPermission @UserID = @AdminID ,@FuncKey = 'ManageUser', @ErrCode = @ErrCode OUTPUT, @ErrMsg = @ErrMsg OUTPUT
		
		IF @ErrCode > 0
			RETURN
	END
		
	DECLARE @db_userpwd NVARCHAR(50)
	
	SELECT @db_userpwd = userpwd FROM [dbo].[AdminInfo] WITH(NOLOCK) WHERE [AdminId] = @custid
	
	IF @@ROWCOUNT = 0 OR @db_userpwd = @userpwd
		RETURN
	
	UPDATE [dbo].[AdminInfo] WITH(UPDLOCK,ROWLOCK) 
	SET userpwd = @userpwd
	WHERE [AdminId] = @custid
	
	DECLARE @LogData NVARCHAR(4000), @LogErr NVARCHAR(MAX)
	
	
	SELECT @LogData = '<RMS_UserInfoUpdUserpwd CustID="' + COALESCE(CONVERT(VARCHAR(10),@CustID),SPACE(1)) + '" ' +												
						'IP="' + COALESCE(@IP,SPACE(1)) + '" />'
		
	SET @endRun = GETDATE()  
	SET @duration  = DATEDIFF (MILLISECOND,@startRun,@endRun)  
	
	BEGIN TRY
		--Write log in IBC
		EXEC SVRLOG.LogDB.dbo.WriteLog_UserLog_RunSP  
			@UserID			= @AdminID, 
			@CustID			= @CustID,				
			@ActionID		= 10301, 
			@TrackingValue	= @LogData, 
			@duration		= @duration
	END TRY
	BEGIN CATCH		
		SELECT @LogErr = '<RMS_UserInfoUpdUserpwd CustID="' + COALESCE(CONVERT(VARCHAR(10),@CustID),SPACE(1)) + '" ' +												
						'IP="' + COALESCE(@IP,SPACE(1)) + '" ' + 
						'ErrMsg='+ COALESCE(ERROR_MESSAGE(),SPACE(1)) + '" />'
				
		EXEC SVRTXN.LogDB.dbo.WriteLog_UserLog_RunSP  
			@UserID			= @AdminID, 
			@CustID			= @CustID,				
			@ActionID		= 10301, 
			@TrackingValue	= @LogErr, 
			@duration		= @duration
	END CATCH	
	
	BEGIN TRY
		--Write log in RMS
		EXEC SVRLOG.LogDB.dbo.RMS_WriteLog_UserLog_RunSP  
			@UserID			= @AdminID, 
			@CustID			= @CustID,				
			@ActionID		= 10301, 
			@TrackingValue	= @LogData, 
			@duration		= @duration
	END TRY
	BEGIN CATCH
		SELECT @LogErr = '<RMS_UserInfoUpdUserpwd> CustID="' + COALESCE(CONVERT(VARCHAR(10),@CustID),SPACE(1)) + '" ' +												
						'IP="' + COALESCE(@IP,SPACE(1)) + '" ' + 
						'ErrMsg='+ COALESCE(ERROR_MESSAGE(),SPACE(1)) + '" ' + 
					'</RMS_UserInfoUpdUserpwd>'
					
		--Write log in RMS
		EXEC SVRTXN.LogDB.dbo.RMS_WriteLog_UserLog_RunSP  
			@UserID			= @AdminID, 
			@CustID			= @CustID,				
			@ActionID		= 10301, 
			@TrackingValue	= @LogErr, 
			@duration		= @duration
	END CATCH




GO
GRANT EXECUTE ON [dbo].[RMS_UserInfoUpdUserPwd] TO [bodbRMSNet]