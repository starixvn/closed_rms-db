 ALTER PROCEDURE [dbo].[RMS_CustomerCheckExisting]
	@custid		INT,
	@isExists	BIT = 0 OUTPUT
AS
	/*
		Created: Johnson
		Date: 2013-10-21
		Task: Check customer is exists in RMS or not
		DB: SVRCSD/bodb_RMS
		
		Revisions:
		
		Parameter's Explanation:
	*/
SET NOCOUNT ON
	IF EXISTS(SELECT 1 FROM rmCustomer WITH(NOLOCK) WHERE custid = @custid)
		SELECT @isExists = 1
	ELSE 
		SELECT @isExists = 0 

GO
GRANT EXECUTE ON [dbo].[RMS_CustomerCheckExisting] TO [bodbRMSNet] 