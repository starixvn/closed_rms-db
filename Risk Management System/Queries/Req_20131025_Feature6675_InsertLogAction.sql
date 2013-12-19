USE [LogDB]
GO

INSERT INTO [dbo].[LogActionType]
           ([ActionTypeId]
           ,[ActionTypeName])
     VALUES
           (100
           ,'RMS')
GO


--insert default setting for rmSetting
USE bodb_RMS
GO
INSERT INTO rmSettings(VName,VValue)
VALUES('rmBettransSync',0)

--insert log action 
USE [LogDB]
GO

INSERT INTO [dbo].[LogAction]
           ([ActionId]
           ,[ActionTypeId]
           ,[SPName]
           ,[ActionName]
           ,[ActionNameEN]
           ,[ActionNameCT]
           ,[ActionNameCS]
           ,[ActionNameJP]
           ,[ActionNameTH]
           ,[ActionNameKO]
           ,[ActionNameES]
           ,[ActionNameVI]
           ,[IsInternal])
SELECT 10000,100,'Add new special member','RMS_CustomerIns','Add new special member','Add new special member','Add new special member','Add new special member','Add new special member','Add new special member','Add new special member','Add new special member',0
UNION ALL
SELECT 10001,100,'Add new special member','RMS_CustomerUpd','Update customer info','Update customer info','Update customer info','Update customer info','Update customer info','Update customer info','Update customer info','Update customer info',0

