 USE [master]
GO

/****** Object:  Database [bodb_RMS]    Script Date: 10/25/2013 8:57:26 AM ******/
CREATE DATABASE [bodb_RMS]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'bodb_RMS', FILENAME = N'E:\APL_DB\bodb_RMS\bodb_RMS.mdf' , SIZE = 10240KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB ), 
 FILEGROUP [rmData] 
( NAME = N'rmData', FILENAME = N'E:\APL_DB\bodb_RMS\rmData.ndf' , SIZE = 10240KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB ), 
 FILEGROUP [rmIndex] 
( NAME = N'rmIndex', FILENAME = N'E:\APL_DB\bodb_RMS\rmIndex.ndf' , SIZE = 10240KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB ), 
 FILEGROUP [rmLogin] 
( NAME = N'rmLogin', FILENAME = N'E:\APL_DB\bodb_RMS\rmLogin.ndf' , SIZE = 4096KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB ), 
 FILEGROUP [rmSumWinloss] 
( NAME = N'rmSumWinloss', FILENAME = N'E:\APL_DB\bodb_RMS\rmSumWinloss.ndf' , SIZE = 10240KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB ), 
 FILEGROUP [rmSumWinlossOld] 
( NAME = N'rmSumWinlossOld', FILENAME = N'E:\APL_DB\bodb_RMS\rmSumWinlossOld.ndf' , SIZE = 10240KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB ), 
 FILEGROUP [rmUserControl] 
( NAME = N'rmUserControl', FILENAME = N'E:\APL_DB\bodb_RMS\rmUserControl.ndf' , SIZE = 4096KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'bodb_RMS_log', FILENAME = N'E:\APL_DB\bodb_RMS\bodb_RMS_log.ldf' , SIZE = 1792KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO

ALTER DATABASE [bodb_RMS] SET COMPATIBILITY_LEVEL = 110
GO

IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [bodb_RMS].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO

ALTER DATABASE [bodb_RMS] SET ANSI_NULL_DEFAULT OFF 
GO

ALTER DATABASE [bodb_RMS] SET ANSI_NULLS OFF 
GO

ALTER DATABASE [bodb_RMS] SET ANSI_PADDING OFF 
GO

ALTER DATABASE [bodb_RMS] SET ANSI_WARNINGS OFF 
GO

ALTER DATABASE [bodb_RMS] SET ARITHABORT OFF 
GO

ALTER DATABASE [bodb_RMS] SET AUTO_CLOSE OFF 
GO

ALTER DATABASE [bodb_RMS] SET AUTO_CREATE_STATISTICS ON 
GO

ALTER DATABASE [bodb_RMS] SET AUTO_SHRINK OFF 
GO

ALTER DATABASE [bodb_RMS] SET AUTO_UPDATE_STATISTICS ON 
GO

ALTER DATABASE [bodb_RMS] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO

ALTER DATABASE [bodb_RMS] SET CURSOR_DEFAULT  GLOBAL 
GO

ALTER DATABASE [bodb_RMS] SET CONCAT_NULL_YIELDS_NULL OFF 
GO

ALTER DATABASE [bodb_RMS] SET NUMERIC_ROUNDABORT OFF 
GO

ALTER DATABASE [bodb_RMS] SET QUOTED_IDENTIFIER OFF 
GO

ALTER DATABASE [bodb_RMS] SET RECURSIVE_TRIGGERS OFF 
GO

ALTER DATABASE [bodb_RMS] SET  DISABLE_BROKER 
GO

ALTER DATABASE [bodb_RMS] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO

ALTER DATABASE [bodb_RMS] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO

ALTER DATABASE [bodb_RMS] SET TRUSTWORTHY OFF 
GO

ALTER DATABASE [bodb_RMS] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO

ALTER DATABASE [bodb_RMS] SET PARAMETERIZATION SIMPLE 
GO

ALTER DATABASE [bodb_RMS] SET READ_COMMITTED_SNAPSHOT OFF 
GO

ALTER DATABASE [bodb_RMS] SET HONOR_BROKER_PRIORITY OFF 
GO

ALTER DATABASE [bodb_RMS] SET RECOVERY FULL 
GO

ALTER DATABASE [bodb_RMS] SET  MULTI_USER 
GO

ALTER DATABASE [bodb_RMS] SET PAGE_VERIFY CHECKSUM  
GO

ALTER DATABASE [bodb_RMS] SET DB_CHAINING OFF 
GO

ALTER DATABASE [bodb_RMS] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO

ALTER DATABASE [bodb_RMS] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO

ALTER DATABASE [bodb_RMS] SET  READ_WRITE 
GO



--------------------------------------------------------------------------------
-----------------------create tables for RMS------------------------------------
--------------------------------------------------------------------------------

USE [bodb_RMS]
GO

/****** Object:  Table [dbo].[rmCustomer]    Script Date: 10/25/2013 9:01:25 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[rmCustomer](
	[custid] [int] NOT NULL,
	[username] [varchar](30) NOT NULL,
	[level] [tinyint] NOT NULL,
	[createdDate] [datetime] NULL,
	[creator] [int] NULL,
 CONSTRAINT [PK_rmCustomer] PRIMARY KEY CLUSTERED 
(
	[custid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [rmData]
) ON [rmData]

GO

SET ANSI_PADDING OFF
GO


--------------------------------------------------------------------------------


USE [bodb_RMS]
GO

/****** Object:  Table [dbo].[rmBetTrans]    Script Date: 10/25/2013 1:31:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[rmBetTrans](
	[TransId] [bigint] NOT NULL,
	[CustId] [int] NOT NULL,
	[TransDate] [datetime] NOT NULL,
	[OddsId] [int] NOT NULL,
	[Hdp1] [smallmoney] NULL,
	[Hdp2] [smallmoney] NULL,
	[Odds] [smallmoney] NULL,
	[Stake] [money] NOT NULL,
	[Status] [varchar](10) NULL,
	[WinLost] [money] NULL,
	[PlayerComm] [money] NULL,
	[PlayerDiscount] [decimal](9, 8) NULL,
	[TWinLost] [money] NULL,
	[TComm] [money] NULL,
	[TPositionTaking] [smallmoney] NULL,
	[TDiscount] [decimal](9, 8) NULL,
	[AgentIdList] [varchar](max) NULL,
	[AgentPositionTakingList] [varchar](max) NULL,
	[AgentDiscountList] [varchar](max) NULL,
	[LiveHomeScore] [smallint] NULL,
	[LiveAwayScore] [smallint] NULL,
	[LiveIndicator] [bit] NULL,
	[BetTeam] [varchar](10) NULL,
	[Creator] [int] NOT NULL,
	[RefNo] [bigint] NOT NULL,
	[WinLostDate] [date] NULL,
	[BetFrom] [varchar](1) NULL,
	[BetCheck] [nvarchar](50) NULL,
	[CheckTime] [datetime] NULL,
	[OddsSpread] [smallmoney] NULL,
	[ActualRate] [float] NULL,
	[MatchId] [int] NULL,
	[Ruben] [tinyint] NULL,
	[BetId] [bigint] NULL,
	[StatusWinLost] [tinyint] NULL,
	[MOdds] [smallmoney] NULL,
	[BetType] [smallint] NULL,
	[TStamp] [timestamp] NULL,
	[Actual_Stake] [money] NULL,
	[Currency] [tinyint] NULL,
	[IP] [varchar](40) NULL,
	[TransDesc] [nvarchar](300) NULL,
	[Username] [nvarchar](50) NULL,
	[CurrencyName] [varchar](100) NULL,
	[VirtualRate] [float] NOT NULL,
	[StatusId] [tinyint] NULL,
	[DoubleCommLosing] [bit] NULL,
	[SecAcceptFlag] [bit] NULL,
	[OddsType] [tinyint] NULL,
	[balance] [money] NULL,
	[combo] [int] NULL,
	[agentID] [int] NULL,
 CONSTRAINT [PK_BetTrans] PRIMARY KEY CLUSTERED 
(
	[TransId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [rmIndex]
) ON [rmIndex] TEXTIMAGE_ON [rmData]

GO

SET ANSI_PADDING OFF
GO

-----------------------------
---CREATE Index on rmBettrans


USE [bodb_RMS]
GO

/****** Object:  Index [IX_winlostdate_matchid_statusid]    Script Date: 10/25/2013 1:33:02 PM ******/
CREATE NONCLUSTERED INDEX [IX_winlostdate_matchid_statusid] ON [dbo].[rmBetTrans]
(
	[WinLostDate] ASC,
	[CustId] ASC,
	[MatchId] ASC,
	[StatusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [rmIndex]
GO
-------------------------------------------

USE [bodb_RMS]
GO

/****** Object:  Index [IX_AgentID]    Script Date: 10/25/2013 1:33:52 PM ******/
CREATE NONCLUSTERED INDEX [IX_AgentID] ON [dbo].[rmBetTrans]
(
	[agentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [rmIndex]
GO


--------------------------------------------------------------------------------
USE [bodb_RMS]
GO

/****** Object:  Table [dbo].[rmSumWinloss]    Script Date: 10/25/2013 1:35:59 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[rmSumWinloss](
	[winlostdate] [smalldatetime] NOT NULL,
	[custid] [int] NOT NULL,
	[sporttype] [tinyint] NOT NULL,
	[statusid] [tinyint] NOT NULL,
	[combo] [tinyint] NOT NULL,
	[username] [varchar](30) NOT NULL,
	[currency] [tinyint] NULL,
	[stake] [money] NULL,
	[winlost] [money] NULL,
	[company_stake] [money] NULL,
	[company_winlost] [money] NULL,
	[actualrate] [float] NULL,
	[odds] [smallmoney] NULL,
	[betcount] [int] NULL,
	[AgentID] [int] NULL
) ON [rmSumWinloss]

GO

SET ANSI_PADDING OFF
GO

----------------------------
USE [bodb_RMS]
GO

/****** Object:  Index [CIX_rmSumWinloss]    Script Date: 10/25/2013 1:37:02 PM ******/
CREATE CLUSTERED INDEX [CIX_rmSumWinloss] ON [dbo].[rmSumWinloss]
(
	[custid] ASC,
	[winlostdate] ASC,
	[sporttype] ASC,
	[statusid] ASC,
	[combo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [rmSumWinloss]
GO

--------------------------------------------------------------------------------

USE [bodb_RMS]
GO

/****** Object:  Table [dbo].[rmSumWinloss_Old]    Script Date: 10/25/2013 1:37:30 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[rmSumWinloss_Old](
	[winlostdate] [smalldatetime] NOT NULL,
	[custid] [int] NOT NULL,
	[sporttype] [tinyint] NOT NULL,
	[statusid] [tinyint] NOT NULL,
	[combo] [tinyint] NOT NULL,
	[username] [varchar](30) NOT NULL,
	[currency] [tinyint] NULL,
	[stake] [money] NULL,
	[winlost] [money] NULL,
	[company_stake] [money] NULL,
	[company_winlost] [money] NULL,
	[actualrate] [float] NULL,
	[odds] [smallmoney] NULL,
	[betcount] [int] NULL,
	[AgentID] [int] NULL
) ON [rmSumWinlossOld]

GO

SET ANSI_PADDING OFF
GO

-----------------------------------------------------
USE [bodb_RMS]
GO

/****** Object:  Index [CIX_rmSumWinloss_Old]    Script Date: 10/25/2013 1:37:41 PM ******/
CREATE CLUSTERED INDEX [CIX_rmSumWinloss_Old] ON [dbo].[rmSumWinloss_Old]
(
	[custid] ASC,
	[winlostdate] ASC,
	[sporttype] ASC,
	[statusid] ASC,
	[combo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [rmSumWinlossOld]
GO

----------------------------------------------------------------------------

USE [bodb_RMS]
GO

/****** Object:  Table [dbo].[rmSettings]    Script Date: 10/25/2013 1:38:06 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[rmSettings](
	[VID] [int] IDENTITY(1,1) NOT NULL,
	[VName] [varchar](30) NULL,
	[VValue] [varchar](500) NULL,
 CONSTRAINT [PK_rmSettings] PRIMARY KEY CLUSTERED 
(
	[VID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [rmData]
) ON [rmData]

GO

SET ANSI_PADDING OFF
GO


-----------------------------------------------------------------------------
--create file group on LogDB for store log user run sp
--------------------------------------------------------
USE LogDB
GO

ALTER DATABASE LogDB
ADD FILEGROUP rmLogUserRunSP
GO

ALTER DATABASE LogDB
ADD FILE ( NAME = N'rmLogUserRunSP', FILENAME = N'D:\APL_DB\CustomerLog\rmLogUserRunSP.ndf' , SIZE = 10240KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
TO FILEGROUP rmLogUserRunSP

------------------------------------------------------------------------------

USE [LogDB]
GO

/****** Object:  Table [dbo].[rmUserLog_RunSP]    Script Date: 10/25/2013 2:40:47 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[rmUserLog_RunSP](
	[LogID] [bigint] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NULL,
	[Logdate] [datetime] NULL,
	[CustID] [int] NULL,
	[ActionID] [int] NULL,
	[TrackingValue] [nvarchar](max) NULL,
	[Duration] [int] NULL,
	[TrackingValue2] [nvarchar](max) NULL,
 CONSTRAINT [PK_rmUserLog_RunSP] PRIMARY KEY CLUSTERED 
(
	[LogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [rmLogUserRunSP]
) ON [rmLogUserRunSP] TEXTIMAGE_ON [rmLogUserRunSP]

GO



