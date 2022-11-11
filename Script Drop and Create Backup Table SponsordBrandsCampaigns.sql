USE [TwinScrollsMarketing]
GO

--SQL To Select from Updates table into a backup

DECLARE @SQL nvarchar(2000)

SET @SQL='select *

INTO dbo.Backup_SponsoredBrandCampaigns'+REPLACE(CONVERT(nvarchar(50),GETDATE(),101),'/','')+'

from dbo.SponsoredBrandsCampaigns_Updates'

EXEC(@SQL)

/****** Object:  Table [dbo].[SponsoredBrandsCampaigns_ImportTableBackup]    Script Date: 9/6/2019 4:00:28 PM ******/
DROP TABLE [dbo].[SponsoredBrandsCampaigns_ImportTableBackup]
GO

/****** Object:  Table [dbo].[SponsoredBrandsCampaigns_ImportTableBackup]    Script Date: 9/6/2019 4:00:28 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SponsoredBrandsCampaigns_ImportTableBackup](
	[Record ID] [nvarchar](255) NULL,
	[Record Type] [nvarchar](255) NULL,
	[Campaign ID] [nvarchar](255) NULL,
	[Campaign] [nvarchar](255) NULL,
	[Budget] [nvarchar](255) NULL,
	[Portfolio ID] [nvarchar](255) NULL,
	[Campaign Start Date] [nvarchar](255) NULL,
	[Campaign End Date] [nvarchar](255) NULL,
	[Budget Type] [nvarchar](255) NULL,
	[Landing Page Url] [nvarchar](255) NULL,
	[Landing Page ASINs] [nvarchar](255) NULL,
	[Brand Name] [nvarchar](255) NULL,
	[Brand Logo Asset ID] [nvarchar](255) NULL,
	[Headline] [nvarchar](255) NULL,
	[Creative ASINs] [nvarchar](255) NULL,
	[Automated Bidding] [nvarchar](255) NULL,
	[Bid Multiplier] [nvarchar](255) NULL,
	[Ad Group] [nvarchar](255) NULL,
	[Max Bid] [nvarchar](255) NULL,
	[Keyword] [nvarchar](255) NULL,
	[Match Type] [nvarchar](255) NULL,
	[Campaign Status] [nvarchar](255) NULL,
	[Serving Status] [nvarchar](255) NULL,
	[Ad Group Status] [nvarchar](255) NULL,
	[Status] [nvarchar](255) NULL,
	[Impressions] [nvarchar](255) NULL,
	[Clicks] [nvarchar](255) NULL,
	[Spend] [nvarchar](255) NULL,
	[Orders] [nvarchar](255) NULL,
	[Total Units] [nvarchar](255) NULL,
	[Sales] [nvarchar](255) NULL,
	[ACoS] [nvarchar](255) NULL,
	[Placement Type] [nvarchar](255) NULL,
	[Notes] [varchar](max) NULL,
	[Brand] [varchar](255) NULL,
	[Product Group] [varchar](255) NULL
) ON [PRIMARY]

GO
