USE TwinScrollsMarketing

/**
Script for Step 2 of changes to Sponsored Products Campaigns table. Decrease Max Bid for Auto campaigns that have high ACoS and high clicks.
Steps:
For every row where Record Type = 'Keyword' OR Record Type = 'Product Targeting' AND Campaign LIKE '%Auto%'
AND ACoS > 60 AND Clicks > 20, you want to decrease the Max Bid column by 10%
AND when Max Bid is blank, then you need to reference the Max Bid for the Record Type = 'Ad group' and Campaign = Campaign and Ad Group column = Ad Group column
and print "Keyword [insert keyword] has been decreased by 10% from [original] to [new]" into a new column
**/

/** Syntax to reset table to backup **/
--DROP TABLE [dbo].[SponsoredProductsCampaigns_Updates]
--SELECT * INTO dbo.[SponsoredProductsCampaigns_Updates] FROM [dbo].[SponsoredProductsCampaigns_ImportTableBackup]


DECLARE @ClicksTrigger float = '20'
DECLARE @ACoSTrigger float = '60'
DECLARE @MaxBidChangePercent float = '.10'
DECLARE @RecordTypeFilter varchar(50) = 'Product Targeting'

SELECT *  FROM [TwinScrollsMarketing].[dbo].[SponsoredProductsCampaigns_ImportTableBackup]
WHERE  CONVERT(float, (REPLACE([ACoS],'%', ''))) > @ACoSTrigger
	AND CONVERT(float, [Clicks]) > @ClicksTrigger
	AND [Record Type] = @RecordTypeFilter
	AND [Campaign] LIKE '%Auto%'
	AND [Campaign] NOT LIKE '%Auto Low%'
ORDER BY [Record ID] ASC

UPDATE [TwinScrollsMarketing].[dbo].[SponsoredProductsCampaigns_Updates]
SET [Max Bid] = (CASE WHEN [Max Bid] = '' THEN CONVERT(decimal(18,2),(SELECT MAX(CONVERT(float, [Max Bid])) 
					FROM  [dbo].[SponsoredProductsCampaigns_Updates] m 
					WHERE m.[Record Type] = 'Ad Group' 
					AND [SponsoredProductsCampaigns_Updates].Campaign = m.Campaign 
					AND [SponsoredProductsCampaigns_Updates].[Ad Group] = m.[Ad Group] 
					AND m.[Keyword or Product Targeting] = ''
					GROUP BY [Campaign]) * (1 - @MaxBidChangePercent)) --Converts our new [Max Bid] value
					ELSE CONVERT(decimal(18,2), [Max Bid] * (1 - @MaxBidChangePercent))
					 
					END)  
	,[Notes] = 'The enhanced auto target ' +
				[Keyword or Product Targeting] + ' bid has been decreased by' + ' ' 
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
					GROUP BY [Campaign]) * (1 - @MaxBidChangePercent)) --Converts our new [Max Bid] value
					ELSE CONVERT(decimal(18,2), [Max Bid] * (1 - @MaxBidChangePercent))
					 END))
		,[Brand] = CASE WHEN [Campaign] LIKE '%-%' THEN LEFT(Campaign, CHARINDEX('-', Campaign + '-') - 1) ELSE Campaign END
		,[Product Group] = CASE WHEN [Campaign] LIKE '%-%' THEN LEFT(Campaign, CHARINDEX('-', Campaign, CHARINDEX('-', Campaign) + 1) -1 ) ELSE Campaign END 
WHERE  CONVERT(float, (REPLACE([ACoS],'%', ''))) > @ACoSTrigger
	AND CONVERT(float, [Clicks]) > @ClicksTrigger
		AND [Record Type] = @RecordTypeFilter
	AND [Campaign] LIKE '%Auto%'
	AND [Campaign] NOT LIKE '%Auto Low%'

SELECT *  FROM [TwinScrollsMarketing].[dbo].[SponsoredProductsCampaigns_Updates]
WHERE  CONVERT(float, (REPLACE([ACoS],'%', ''))) > @ACoSTrigger
	AND CONVERT(float, [Clicks]) > @ClicksTrigger
	AND [Record Type] = @RecordTypeFilter
	AND [Campaign] LIKE '%Auto%'
	AND [Campaign] NOT LIKE '%Auto Low%'
ORDER BY [Record ID] ASC





