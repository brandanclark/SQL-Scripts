USE [TwinScrollsMarketing]
GO

--SQL To Select from Updates table into a backup

DECLARE @SQL nvarchar(2000)

SET @SQL='select *

INTO dbo.Backup_'+REPLACE(CONVERT(nvarchar(50),GETDATE(),101),'/','')+'

from dbo.SponsoredProductsCampaigns_Updates'

EXEC(@SQL)

/****** Object:  Table [dbo].[SponsoredProductsCampaigns_ImportTableBackup]    Script Date: 4/24/2019 9:28:07 PM ******/
DROP TABLE [dbo].[SponsoredProductsCampaigns_ImportTableBackup]
GO

/****** Object:  Table [dbo].[SponsoredProductsCampaigns_ImportTableBackup]    Script Date: 4/24/2019 9:28:07 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[SponsoredProductsCampaigns_ImportTableBackup](
	[Record ID] [nvarchar](255) NULL,
	[Record Type] [nvarchar](255) NULL,
	[Campaign] [nvarchar](255) NULL,
	[Campaign Daily Budget] [nvarchar](255) NULL,
	[Portfolio ID] [nvarchar](255) NULL,
	[Campaign Start Date] [nvarchar](255) NULL,
	[Campaign End Date] [nvarchar](255) NULL,
	[Campaign Targeting Type] [nvarchar](255) NULL,
	[Ad Group] [nvarchar](255) NULL,
	[Max Bid] [nvarchar](255) NULL,
	[Keyword or Product Targeting] [nvarchar](255) NULL,
	[Product Targeting ID] [nvarchar](255) NULL,
	[Match Type] [nvarchar](255) NULL,
	[SKU] [nvarchar](255) NULL,
	[Campaign Status] [nvarchar](255) NULL,
	[Ad Group Status] [nvarchar](255) NULL,
	[Status] [nvarchar](255) NULL,
	[Impressions] [nvarchar](255) NULL,
	[Clicks] [nvarchar](255) NULL,
	[Spend] [nvarchar](255) NULL,
	[Orders] [nvarchar](255) NULL,
	[Total Units] [nvarchar](255) NULL,
	[Sales] [nvarchar](255) NULL,
	[ACoS] [nvarchar](255) NULL,
	[Bidding strategy] [nvarchar](255) NULL,
	[Placement Type] [nvarchar](255) NULL,
	[Increase bids by placement] [nvarchar](255) NULL,
	[Notes] [varchar](max) NULL,
	[Brand] [varchar](255) NULL,
	[Product Group] [varchar](255) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


