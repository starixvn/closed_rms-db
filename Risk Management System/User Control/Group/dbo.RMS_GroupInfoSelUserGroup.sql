  ALTER PROCEDURE [dbo].[RMS_GroupInfoSelUserGroup]
	@GroupID	INT
AS
	/*
		Created: Johnson
		Date: 2013-10-18
		Task: Get users of group
		DB: SVRCSD/bodb_RMS
		
		Revisions:
		
		Parameter's Explanation:
	*/
SET NOCOUNT ON

	SELECT c.username, c.firstname, c.lastname, c.creatdate, ui.enabled, creator.username as creator
	FROM rmUserInfo ui WITH(NOLOCK)
		INNER JOIN RepDB.[dbo].[AdminInfo] c WITH(NOLOCK) ON ui.userid = c.[AdminId]
		LEFT JOIN RepDB.dbo.[AdminInfo] creator WITH(NOLOCK) ON c.creator = creator.[AdminId]	
	WHERE GroupID = @GroupID



GO
GRANT EXECUTE ON [dbo].[RMS_GroupInfoSelUserGroup] TO [bodbRMSNet]