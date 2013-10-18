ALTER PROCEDURE [dbo].[RMS_GroupInfoSelByGroupID]
	@GroupID	INT
AS
	/*
		Created: Johnson
		Date: 2013-10-18
		Task: get group info by id
		DB: SVRCSD/bodb_RMS
		
		Revisions:
		
		Parameter's Explanation:
	*/ 
SET NOCOUNT ON

	SELECT GroupName, Description
	FROM rmGroup WITH(NOLOCK)
	WHERE groupID = @GroupID




GO
GRANT EXECUTE ON [dbo].[RMS_GroupInfoSelByGroupID] TO [bodbRMSNet]