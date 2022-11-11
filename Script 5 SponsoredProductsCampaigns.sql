USE TwinScrollsMarketing

/**
Script for Step 5 of changes to Sponsored Products Campaigns table. Increase Max Bid for products with high Clicks/Impressions ratio
Steps:
For every row where Record Type = 'Keyword' OR Record Type = 'Product Targeting' AND Campaign NOT LIKE '%- Auto%' 
AND Sales = 0 AND Clicks > 1, AND CTR > 5%, you want to increase the Max Bid column by 15%
AND when Max Bid is blank, reference the Max Bid for the Record Type = 'Ad group' and Campaign = Campaign and Ad Group column = Ad Group column
AND if new Max Bid > 20, set Max Bid to 20
AND print "Keyword [insert keyword] Max Bid has been increased by 20% from [original] to [new]" into a new column  
**/

/** Syntax to reset table to backup **/
--DROP TABLE [dbo].[SponsoredProductsCampaigns_Updates]
--SELECT * INTO dbo.[SponsoredProductsCampaigns_Updates] FROM [dbo].[SponsoredProductsCampaigns_ImportTableBackup]


DECLARE @SalesTrigger float = '0'
DECLARE @ClicksTrigger float = '1'
DECLARE @CTRTrigger float = '.05'
DECLARE @MaxBidChangePercent float = '.15'
DECLARE @RecordTypeFilter varchar(50) = 'Keyword'

SELECT * FROM [TwinScrollsMarketing].[dbo].[SponsoredProductsCampaigns_ImportTableBackup]
WHERE  CONVERT(float, [Clicks]) > @ClicksTrigger
	AND CONVERT(float, [Sales]) = @SalesTrigger
	AND CONVERT(float, [Clicks]) / CONVERT(float, [Impressions]) > @CTRTrigger
	AND ([Record Type] = @RecordTypeFilter OR [Record Type] = 'Product Targeting')
	AND [Campaign] NOT LIKE '%- Auto%'
ORDER BY [Record ID] ASC

UPDATE [TwinScrollsMarketing].[dbo].[SponsoredProductsCampaigns_Updates]
SET [Max Bid] = (CASE WHEN [Max Bid] = '' THEN CONVERT(decimal(18,2),(SELECT MAX(CONVERT(float, [Max Bid])) 
					FROM  [dbo].[SponsoredProductsCampaigns_Updates] m 
					WHERE m.[Record Type] = 'Ad Group' 
					AND [SponsoredProductsCampaigns_Updates].Campaign = m.Campaign 
					AND [SponsoredProductsCampaigns_Updates].[Ad Group] = m.[Ad Group] 
					AND m.[Keyword or Product Targeting] = ''
					GROUP BY [Campaign]) * (1 + @MaxBidChangePercent)) --Converts our new [Max Bid] value
					WHEN (CONVERT(decimal(18,2), [Max Bid] * (1 + @MaxBidChangePercent)) > 20) THEN CONVERT(decimal(18,2), 20)
					ELSE CONVERT(decimal(18,2), [Max Bid] * (1 + @MaxBidChangePercent))
					 
					END)  
	,[Notes] = 'The Sponsored Products ' + [Match Type] + ' match keyword' + ' "' + 
				[Keyword or Product Targeting] + '" ' + 'bid has been increased by' + ' ' 
				+ CONVERT(VARCHAR(50), (@MaxBidChangePercent * 100)) + '% from' + ' ' + 
				CONVERT(VARCHAR(10), (CASE WHEN [Max Bid] = '' THEN CONVERT(decimal(18,2),(SELECT MAX(CONVERT(float, [Max Bid])) 
					FROM  [dbo].[SponsoredProductsCampaigns_Updates] m 
					WHERE m.[Record Type] = 'Ad Group' 
					AND [SponsoredProductsCampaigns_Updates].Campaign = m.Campaign 
					AND [SponsoredProductsCampaigns_Updates].[Ad Group] = m.[Ad Group] 
					AND m.[Keyword or Product Targeting] = ''
					GROUP BY [Campaign])) --Converts our new [Max Bid] value
					ELSE [Max Bid]
					 
					END) ) + ' ' 
				+ 'to' + ' ' + 
				CONVERT(VARCHAR(10), (CASE WHEN [Max Bid] = '' THEN CONVERT(decimal(18,2),(SELECT MAX(CONVERT(float, [Max Bid])) 
					FROM  [dbo].[SponsoredProductsCampaigns_Updates] m 
					WHERE m.[Record Type] = 'Ad Group' 
					AND [SponsoredProductsCampaigns_Updates].Campaign = m.Campaign 
					AND [SponsoredProductsCampaigns_Updates].[Ad Group] = m.[Ad Group] 
					AND m.[Keyword or Product Targeting] = ''
					GROUP BY [Campaign]) * (1 + @MaxBidChangePercent)) --Converts our new [Max Bid] value
					WHEN (CONVERT(decimal(18,2), [Max Bid] * (1 + @MaxBidChangePercent)) > 20) THEN CONVERT(decimal(18,2), 20)
					ELSE CONVERT(decimal(18,2), [Max Bid] * (1 + @MaxBidChangePercent))
					 END))
		 		,[Brand] = CASE WHEN [Campaign] LIKE '%-%' THEN LEFT(Campaign, CHARINDEX('-', Campaign + '-') - 1) ELSE Campaign END
		,[Product Group] = CASE WHEN [Campaign] LIKE '%-%' THEN LEFT(Campaign, CHARINDEX('-', Campaign, CHARINDEX('-', Campaign) + 1) -1 ) ELSE Campaign END 
WHERE  CONVERT(float, [Clicks]) > @ClicksTrigger
	AND CONVERT(float, [Sales]) = @SalesTrigger
	AND CONVERT(float, [Clicks]) / CONVERT(float, [Impressions]) > @CTRTrigger
	AND ([Record Type] = @RecordTypeFilter OR [Record Type] = 'Product Targeting')
	AND [Campaign] NOT LIKE '%- Auto%'


SELECT *  FROM [TwinScrollsMarketing].[dbo].[SponsoredProductsCampaigns_Updates]
WHERE  CONVERT(float, [Clicks]) > @ClicksTrigger
	AND CONVERT(float, [Sales]) = @SalesTrigger
	AND CONVERT(float, [Clicks]) / CONVERT(float, [Impressions]) > @CTRTrigger
	AND ([Record Type] = @RecordTypeFilter OR [Record Type] = 'Product Targeting')
	AND [Campaign] NOT LIKE '%- Auto%'
ORDER BY [Record ID] ASC
	




