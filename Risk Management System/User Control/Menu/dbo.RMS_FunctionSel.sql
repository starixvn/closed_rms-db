 ALTER PROCEDURE [dbo].[RMS_FunctionSel]
AS
	/*
		Created: Johnson
		Date: 2013-10-18
		Task: Get functions info
		DB: SVRCSD/bodb_RMS
		
		Revisions:
		
		Parameter's Explanation:
	*/ 
SET NOCOUNT ON
	
	SELECT FuncID, FuncName, FuncKey, FuncDesc, ParentID, ParentName, DisplayOrder, ModifiedDate 
	FROM rmFunction WITH(NOLOCK)
	ORDER BY parentID, DisplayOrder ASC
	



GO
GRANT EXECUTE ON [dbo].[RMS_FunctionSel] TO [bodbRMSNet]