 ALTER PROCEDURE [dbo].[RMS_GroupInfoSelAllGroup]
AS
	/*
		Created: Johnson
		Date: 2013-10-18
		Task: Select all group available
		DB: SVRCSD/bodb_RMS
		
		Revisons:
		
		Parameter's Explanation:
	*/ 
SET NOCOUNT ON

	SELECT GroupID,GroupName
	FROM rmGroup WITH(NOLOCK)
	ORDER BY groupName



GO
GRANT EXECUTE ON [dbo].[RMS_GroupInfoSelAllGroup] TO [bodbRMSNet]