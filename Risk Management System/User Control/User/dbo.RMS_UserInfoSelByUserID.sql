 ALTER PROCEDURE [dbo].[RMS_UserInfoSelByUserID]
	@UserID		INT
AS
	/*
		Created: Johnson
		Date: 2013-10-18
		Task: Get user's info
		DB: SVRCSD/bodb_RMS
		
		Revisions:
		
		Parameter's Explanation:
	*/ 
SET NOCOUNT ON
	SELECT c.[AdminId], c.username, c.firstname, c.lastname, g.groupID, g.groupname, ui.enabled
	FROM rmUserInfo ui WITH(NOLOCK)
		INNER JOIN RepDB.[dbo].[AdminInfo] c WITH(NOLOCK) ON ui.UserID = c.[AdminId]
		INNER JOIN rmGroup g WITH(NOLOCK) ON ui.groupID = g.groupID
	WHERE ui.UserID = @UserID




GO
GRANT EXECUTE ON [dbo].[RMS_UserInfoSelByUserID] TO [bodbRMSNet]