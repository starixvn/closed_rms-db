  ALTER PROCEDURE [dbo].[RMS_GroupInfoSel]	
AS
	/*
		Created: Johnson
		Date: 2013-10-18
		Task: Get RMS's groups 
		DB: SVRCSD/bodb_RMS
		
		Revisions:
		
		Parameter's Explanation:
			
	*/	
SET NOCOUNT ON

	SELECT g.GroupID, g.GroupName, ISNULL(p.Users,0) as NoUsers, ISNULL(g.Description,'') as Description, ISNULL(c.username,'') as Creator, g.createdDate
	FROM rmGroup g WITH(NOLOCK) 
		LEFT JOIN RepDB.[dbo].[AdminInfo] c WITH(NOLOCK) ON g.creator = c.[AdminId]
		LEFT JOIN 
		(
			SELECT GroupID, count(1) users
			FROM rmUserInfo WITH(NOLOCK)
			GROUP BY GroupID
		) p ON g.groupID = p.groupID
	ORDER BY  groupName



GO
GRANT EXECUTE ON [dbo].[RMS_GroupInfoSel] TO [bodbRMSNet]

	