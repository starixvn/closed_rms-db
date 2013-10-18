  ALTER PROCEDURE [dbo].[RMS_GroupInfoUpd]
	@AdminID		INT,
	@GroupID		INT,
	@GroupName		NVARCHAR(100) = '',
	@Description	NVARCHAR(200) = NULL,
	@IP				VARCHAR(50),
	@ErrCode		INT = 0 OUTPUT,
	@ErrMsg			VARCHAR(500) = '' OUTPUT
AS
	/*
		Created: Johnson
		Date: 2013-10-18
		Task: Update group info
		DB: SVRCSD/bodb_RMS
		
		Revisions:
			
		Parameter's Explanation:
	*/
SET NOCOUNT ON

	DECLARE @startRun datetime  
		,@endRun datetime  
		,@duration int		
	
	SET @startRun=GETDATE()
	
	EXEC dbo.RMS_UserCheckPermission @UserID = @AdminID ,@FuncKey = 'ManageGroup', @ErrCode = @ErrCode OUTPUT, @ErrMsg = @ErrMsg OUTPUT
	
	IF @ErrCode > 0
		RETURN
		
	DECLARE @db_GroupName VARCHAR(100),
			@db_Description VARCHAR(200)
	
	SELECT @db_GroupName = GroupName, @db_Description = Description
	FROM rmGroup WITH(NOLOCK)
	WHERE GroupID = @GroupID
	
	IF EXISTS (SELECT 1 
			FROM rmGroup WITH(NOLOCK)
			WHERE GroupName = @GroupName AND GroupID <> @GroupID
	)
	BEGIN
		SELECT @ErrMsg = 'This group''s name is used',
				@ErrCode = 100
		RETURN
	END
		
	UPDATE rmGroup WITH(UPDLOCK,ROWLOCK)
	SET GroupName	 = @GroupName,
		Description = @Description		
	WHERE GroupID	 = @GroupID
	
	DECLARE @LogData NVARCHAR(500)
	SELECT @LogData = '<RMS_GroupInfoUpd GroupNameOld="' + COALESCE(@db_GroupName,SPACE(1)) + '" ' +
						'GroupNameNew="' + COALESCE(@GroupName,SPACE(1)) + '" ' +
						'DescriptionOld="' + COALESCE(@db_Description,SPACE(1)) + '" ' +
						'DescriptionNew="' + COALESCE(@Description,SPACE(1)) + '" ' +
						'IP="' + COALESCE(@IP,SPACE(1)) + '" />' 
						
	SET @endRun = GETDATE()  
	SET @duration  = DATEDIFF (MILLISECOND,@startRun,@endRun)   

	EXEC SVRLOG.LogDB.[dbo].[RMS_WriteLog_UserLog_UserControl]
			@custID = @GroupID,
			@Doing = @LogData,
			@userid = @AdminID,
			@TypeID = 0,
			@actionid = 10001,
			@duration = @Duration  
	



GO
GRANT EXECUTE ON [dbo].[RMS_GroupInfoUpd] TO [bodbRMSNet]

	