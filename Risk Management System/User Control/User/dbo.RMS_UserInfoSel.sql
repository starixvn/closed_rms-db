 ALTER PROCEDURE [dbo].[RMS_UserInfoSel]
	@GroupID	INT = NULL,
	@Username	VARCHAR(50) = NULL
AS
	/*
		Created: Johnson
		Date: 2013-10-18
		Task: Get RMS's users
		DB: SVRCSD/bodb_RMS
		
		Revisions:
		
		Parameter's Explanations:
	*/ 
SET NOCOUNT ON

	SELECT c.[AdminId], c.username, c.firstname, c.lastname, g.groupid, g.groupname, ISNULL(creator.username,'') as creator, ui.CreatedDate, ui.enabled
	FROM rmUserInfo ui WITH(NOLOCK)
		INNER JOIN RepDB.dbo.AdminInfo c WITH(NOLOCK) ON ui.userid = c.[AdminId]
		INNER JOIN rmGroup g WITH(NOLOCK) ON ui.groupID = g.groupID
		LEFT JOIN RepDB.dbo.AdminInfo creator WITH(NOLOCK) ON ui.creator = creator.[AdminId]
	WHERE ui.GroupID = ISNULL(@GroupID,ui.GroupID)
		AND c.username LIKE '%'+ ISNULL(@Username,c.username) + '%'
	ORDER BY ui.enabled DESC, g.groupName ASC, c.username ASC
	
	
GO
GRANT EXECUTE ON [dbo].[RMS_UserInfoSel] TO [bodbRMSNet]