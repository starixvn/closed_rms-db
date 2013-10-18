  ALTER PROCEDURE [dbo].[RMS_MenuSel]
AS
	/*
		Created: Johnson
		Date: 2013-10-18
		Task: Manage menu
		DB: SVRCSD/bodb_RMS
		
		Revisions:
		
		Parameter's Explanation:
	*/	
SET NOCOUNT ON

	SELECT m.MenuID, m.MenuName, m.MenuDesc, m.ParentID, m.ParentName, m.URL, ISNULL(f.FuncID,0) as funcid , ISNULL(f.FuncName,'') as funcname, m.DisplayOrder, m.ModifiedDate, m.enabled
	FROM rmMenu m WITH(NOLOCK)
		LEFT JOIN rmFunction f WITH(NOLOCK) ON m.funcid = f.funcid
	ORDER BY m.parentID, m.DisplayOrder ASC



GO
GRANT EXECUTE ON [dbo].[RMS_MenuSel] TO [bodbRMSNet]