  ALTER PROCEDURE [dbo].[RMS_WriteLog_UserLog_Login]
	@UserID INT,  
    @LoginIP VARCHAR(50)='', 
	@ActionID int = 0, 
    @DomainName NVARCHAR(253) = NULL,
    @Doing VARCHAR(300),
    @BrowserName NVARCHAR(255) = NULL,
    @Platform NVARCHAR(255) = NULL,
    @CountryCode VARCHAR(64) = NULL,
    @Duration INT = NULL	
 AS
	/*
		Created: Johnson
		Date: 2013-10-21
		Task: Write log admin login RMS
		DB: SVRLOG/LogDB
		
		Revisions:
		
		Parameter's Explanations:
	*/
SET NOCOUNT ON

	INSERT INTO [dbo].[rmUserLog_Login]
           ([UserID]
           ,[IP]
           ,[LogDate]
		   ,[ActionID]
           ,[Doing]
           ,[DomainName]
           ,[BrowserName]
           ,[Platform]
           ,[CountryCode]
           ,[Duration])
     VALUES
           (@UserID,@LoginIP,GETDATE(),@ActionID,@Doing,@DomainName,@BrowserName,@Platform,@CountryCode,@Duration)



GO
GRANT EXECUTE ON [dbo].[RMS_WriteLog_UserLog_Login] TO [bodbRMSNet]