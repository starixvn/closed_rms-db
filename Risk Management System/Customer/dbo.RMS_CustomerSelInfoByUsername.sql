 ALTER PROCEDURE [dbo].[RMS_CustomerSelInfoByUsername]
	@username NVARCHAR(50),
	@custid		INT = 0 OUTPUT,
	@roleid		INT = 0 OUTPUT
	
AS
	/*
		Created: Johnson
		Date: 2013-10-21
		Task: get custid by username
		DB: SVRCSD/RepDB
		
		Revisions:
		
		Parameter's Explanation:
	*/
SET NOCOUNT ON 

	SELECT @custid = custid, @roleid = 1
	FROM RepDB.[dbo].[CustInfo] WITH(NOLOCK) 
	WHERE username = @username
	
	IF ISNULL(@custid,0) = 0
		SELECT @custid = [AgentId], @roleid = 2
		FROM RepDB.[dbo].[AgentInfo] WITH(NOLOCK) 
		WHERE username = @username

GO
GRANT EXECUTE ON  [dbo].[RMS_CustomerSelInfoByUsername] TO [bodbRMSNet]