  ALTER PROCEDURE [dbo].[RMS_UserInfoUpdAll]
	@AdminID	INT,
	@CustID		INT,		
	@firstname	NVARCHAR(50),
	@lastname	NVARCHAR(50),	
	@GroupID	INT,	
	@IP			VARCHAR(50),
	@ErrCode	INT = 0 OUTPUT,
	@ErrMsg		VARCHAR(500) = '' OUTPUT
AS
	/*
		Created: Johnson
		Date: 2013-10-18
		Task: Update user info 
		DB: SVRCUST/CustDB
		
		Revsisions:
			
		Parameter's Explanation:
	*/
SET NOCOUNT ON

	DECLARE @startRun datetime  
		,@endRun datetime  
		,@duration int		
	
	SET @startRun=GETDATE()
	
	EXEC DBRMS.bodb_RMS.dbo.RMS_UserCheckPermission @UserID = @AdminID ,@FuncKey = 'ManageUser', @ErrCode = @ErrCode OUTPUT, @ErrMsg = @ErrMsg OUTPUT
	
	IF @ErrCode > 0
		RETURN
	
	EXEC DBRMS.bodb_RMS.dbo.RMS_UserInfoUpdUserGroup 
		@AdminID = @AdminID,
		@CustID	 = @CustID,
		@GroupID = @GroupID,
		@IP		 = @IP,
		@ErrCode = @ErrCode OUTPUT,
		@ErrMsg	 = @ErrMsg OUTPUT
	
	IF @ErrCode > 0
		RETURN
		
	DECLARE @db_firstname	NVARCHAR(50),			
			@db_lastname	NVARCHAR(50)
	
	SELECT @db_firstname = firstname, 
		@db_lastname = lastname
	FROM [dbo].[AdminInfo] WITH(NOLOCK)
	WHERE [AdminId] = @CustID
	
	IF @@ROWCOUNT = 0 
		RETURN	
	
	IF @db_firstname = @firstname AND @db_lastname = @lastname
		RETURN
		
	UPDATE [dbo].[AdminInfo] WITH(UPDLOCK,ROWLOCK)
	SET firstname = @firstname,
		lastname = @lastname 
	WHERE [AdminId] = @CustID
	
	DECLARE @LogData NVARCHAR(MAX)
	SELECT @LogData = '<RMS_UserInfoUpdAll FirstNameOld="' + COALESCE(@db_firstname,SPACE(1)) + '" ' +
						'FirstNameNew="' + COALESCE(@firstname,SPACE(1)) + '" ' +
						'LastNameOld="' + COALESCE(@db_lastname,SPACE(1)) + '" ' +
						'LastNameNew="' + COALESCE(@lastname,SPACE(1)) + '" ' +
						'IP="' + COALESCE(@IP,SPACE(1)) + '" />'
				
	SET @endRun = GETDATE()  
	SET @duration  = DATEDIFF (MILLISECOND,@startRun,@endRun)   
	
	BEGIN TRY
		EXEC SVRLOG.LogDB.[dbo].[RMS_WriteLog_UserLog_UserControl] 
			@custID = @CustID, 
			@Doing = @LogData, 
			@userid = @AdminID, 
			@TypeID = 1, 
			@actionid = 10007, 
			@duration = @duration
	END TRY
	BEGIN CATCH
		SELECT @LogData = '<RMS_UserInfoUpdAll FirstNameOld="' + COALESCE(@db_firstname,SPACE(1)) + '" ' +
						'FirstNameNew="' + COALESCE(@firstname,SPACE(1)) + '" ' +
						'LastNameOld="' + COALESCE(@db_lastname,SPACE(1)) + '" ' +
						'LastNameNew="' + COALESCE(@lastname,SPACE(1)) + '" ' +
						'IP="' + COALESCE(@IP,SPACE(1)) + '" ' + 
						'ErrMsg="' + COALESCE(ERROR_MESSAGE(),SPACE(1)) + '" />'
						
		EXEC SVRTXN.LogDB.[dbo].[RMS_WriteLog_UserLog_UserControl] 
			@custID = @CustID, 
			@Doing = @LogData, 
			@userid = @AdminID, 
			@TypeID = 1, 
			@actionid = 10007, 
			@duration = @duration
	END CATCH



GO 
GRANT EXECUTE ON [dbo].[RMS_UserInfoUpdAll] TO [bodbRMSNet]