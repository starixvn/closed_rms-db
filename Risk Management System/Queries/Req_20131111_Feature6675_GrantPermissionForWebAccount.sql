--GRANT PERMISSION ON SVRCSD,SVRARC
-------------------------------------------------
use bodb_RMS
GO
CREATE user bodbRMSNet for login bodbRMSNet
GO
GRANT connect to bodbRMSNet
GO
-------------------------------------------------
use ArchiveDB
GO
CREATE user bodbRMSNet for login bodbRMSNet
GO
GRANT connect to bodbRMSNet
GO
------------------------------------------------
use ArchiveDB
GO
GRANT SELECT ON bettrans_BK to bodbRMSNet
GO
GRANT SELECT ON match_BK to bodbRMSNet
GO
GRANT SELECT ON bettransM to bodbRMSNet
GO
-------------------------------------------------
use RepDB
GO
CREATE user bodbRMSNet for login bodbRMSNet
GO
GRANT connect to bodbRMSNet
GO
-------------------------------------------------
USE RepDB
GO
GRANT SELECT ON bettrans to bodbRMSNet
GO
GRANT SELECT ON bettrans14 to bodbRMSNet
GO
GRANT SELECT ON bettransM to bodbRMSNet
GO
GRANT SELECT ON bettransM14 to bodbRMSNet
GO
GRANT SELECT ON [match] to bodbRMSNet
GO
GRANT SELECT ON [match14] to bodbRMSNet
GO
GRANT SELECT ON [CustInfo] to bodbRMSNet
GO
GRANT SELECT ON [AgentInfo] to bodbRMSNet
GO
GRANT SELECT ON [Exchange] to bodbRMSNet
GO
-----------------------------------------------
