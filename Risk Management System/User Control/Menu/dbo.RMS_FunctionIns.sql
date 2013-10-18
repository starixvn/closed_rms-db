 ALTER PROCEDURE [dbo].[RMS_FunctionIns]
	@AdminID	INT,
	@FuncID		INT = 0 OUTPUT,
	@FuncName	VARCHAR(50),
	@FuncDesc	NVARCHAR(100)= NULL,
	@FuncKey	NVARCHAR(100),
	@ParentID	INT = 0,
	@ParentName	VARCHAR(50) = NULL,
	@DisplayOrder INT,
	@IP			VARCHAR(50),
	@ErrCode	INT = 0 OUTPUT,
	@ErrMsg		VARCHAR(500) = '' OUTPUT
AS
	/*
		Created: Johnson
		Date: 2013-10-18
		Task: Add new funtion
		DB: SVRCSD/bodb_RMS
		
		Revisions:
		
		Parameter's Explanation:
	*/ 
SET NOCOUNT ON
	DECLARE @startRun datetime  
		,@endRun datetime  
		,@duration int		
	
	SET @startRun=GETDATE()
	
	EXEC dbo.RMS_UserCheckPermission @UserID = @AdminID ,@FuncKey = 'ManageFunction', @ErrCode = @ErrCode OUTPUT, @ErrMsg = @ErrMsg OUTPUT
	
	IF @ErrCode > 0
		RETURN
	
	IF EXISTS (SELECT 1 FROM rmFunction WITH(NOLOCK) WHERE FuncKey = @FuncKey)
	BEGIN
		SELECT @ErrMsg = 'This function''s key not available',
				@ErrCode = 101
		RETURN
	END
	
	INSERT INTO [dbo].[rmFunction]
           ([FuncName]
           ,[FuncDesc]
           ,[FuncKey]
           ,[ParentID]
           ,[ParentName]
           ,[CreatedDate]
           ,[ModifiedDate]
           ,[Creator]
           ,[DisplayOrder])
     VALUES
           (@FuncName
           ,@FuncDesc
           ,@FuncKey
           ,@ParentID
           ,@ParentName
           ,GETDATE()
           ,GETDATE()
           ,@AdminID
           ,@DisplayOrder)
	
	SELECT @FuncID = SCOPE_IDENTITY()
	
	--initial user policy
	INSERT INTO rmUserPolicy (UserID, FuncID, Policy)
	SELECT userid, @funcid, 0
	FROM rmUserInfo WITH(NOLOCK)
	
	--initial group policy
	INSERT INTO rmGroupPolicy (GroupID, FuncID, Policy)
	SELECT groupID, @funcid, 0
	FROM rmGroup WITH(NOLOCK)
	
	DECLARE @LogData NVARCHAR(500)
	SELECT @LogData = '<RMS_FunctionIns FuncName="' + COALESCE(@FuncName, SPACE(1)) + '" ' +
						'FuncDesc="' + COALESCE(@FuncDesc, SPACE(1)) + '" ' +
						'FuncKey="' + COALESCE(@FuncKey, SPACE(1)) + '" ' +
						'ParentID="' + COALESCE(CONVERT(VARCHAR(10),@ParentID), SPACE(1)) + '" ' +						
						'ParentName="' + COALESCE(@ParentName, SPACE(1)) + '" ' +
						'DisplayOrder="' + COALESCE(CONVERT(VARCHAR(10),@DisplayOrder), SPACE(1)) + '" ' +
						'IP="'		 + COALESCE(@IP, SPACE(1)) + '" />'
	
	SET @endRun = GETDATE()  
	SET @duration  = DATEDIFF (MILLISECOND,@startRun,@endRun)   

	EXEC SVRLOG.LogDB.[dbo].[RMS_WriteLog_UserLog_UserControl]
		@custID = @FuncId,
		@Doing = @LogData,
		@userid = @AdminID,
		@TypeID = 2,
		@actionid = 10100,
		@duration = @duration





GO
GRANT EXECUTE ON [dbo].[RMS_FunctionIns] TO [bodbRMSNet]