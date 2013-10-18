 ALTER PROCEDURE [dbo].[RMS_UserPolicyUpd]
	 @AdminID		INT,
	 @CustID		INT,
	 @UserPolicy	VARCHAR(4000),
	 @IP			VARCHAR(50),
	 @ErrCode		INT = 0 OUTPUT,
	 @ErrMsg		VARCHAR(500) ='' OUTPUT
AS
	/*
		Created: Johnson
		Date: 2013-10-18
		Task: Update policy of user
		DB: SVRCSD/bodb_RMS
		
		Revisions:
			
		Parameter's Explanation:
			- @Policy: contains ID's function changed and new policy 
					ex: '7,1;8,2;4,0'
	*/
SET NOCOUNT ON
	DECLARE @startRun datetime  
		,@endRun datetime  
		,@duration int		
	
	SET @startRun=GETDATE()
	
	EXEC dbo.RMS_UserCheckPermission @UserID = @AdminID ,@FuncKey = 'ManageUser', @ErrCode = @ErrCode OUTPUT, @ErrMsg = @ErrMsg OUTPUT
	
	IF @ErrCode > 0
		RETURN
	
	DECLARE @Func TABLE (FuncID INT, Policy INT)
	
	INSERT INTO @Func (funcid, policy)
		SELECT funcid,policy
		FROM f_RMS_PolicySplit (@UserPolicy,';',',')
		
		
	UPDATE u
	SET u.Policy = t.Policy
	FROM rmUserPolicy u
		INNER JOIN @Func t ON u.userid = @custid AND u.funcid = t.funcid
	
	INSERT INTO rmUserPolicy (UserID, FuncID, Policy)
		SELECT @custID, t.FuncID, t.Policy 
		FROM @Func t
			LEFT OUTER JOIN rmUserPolicy u WITH(NOLOCK) ON u.userID = @custID AND u.funcID = t.FuncID
		WHERE u.FuncID IS NULL

	/**************Write to Log table for each action********************/
	DECLARE @LogData VARCHAR(4000)
	SELECT @LogData = '<RMS_UserPolicyUpd UserPolicy="' + COALESCE(@UserPolicy,SPACE(1)) + '" ' +
					'IP="' + COALESCE(@IP,SPACE(1)) + '" />'

	SET @endRun = getdate()  
	SET @duration  = datediff (millisecond,@startRun,@endRun)   

	EXEC SVRLOG.LogDB.[dbo].[RMS_WriteLog_UserLog_UserControl] 
		@custID = @CustID, 
		@Doing = @LogData, 
		@userid = @AdminID, 
		@TypeID = 1, 
		@actionid = 10006, 
		@duration = @duration
		



GO
GRANT EXECUTE ON [dbo].[RMS_UserPolicyUpd] TO [bodbRMSNet]
	 