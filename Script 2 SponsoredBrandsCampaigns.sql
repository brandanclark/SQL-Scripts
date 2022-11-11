USE TwinScrollsMarketing

/**
Script for Step 2 of changes to the Sponsored Brands Campaigns table. Decreasing Max Bid for Brands with high ACoS and high clicks
Steps:
For every row where Record Type = 'Keyword' OR Record Type = 'Product Targeting' AND Campaign NOT LIKE '%- Auto%'
AND ACoS > 120 AND Clicks > 20, you want to decrease the Max Bid column by 20%
AND when Max Bid is blank, then you need to reference the Max Bid for the Record Type = 'Ad group' and Campaign = Campaign and Ad Group column = Ad Group column
and print "Keyword [insert keyword] has been decreased by 20% from [original] to [new]" into a new column  "
**/

/** Syntax to reset table to backup **/
--DROP TABLE [dbo].[SponsoredBrandsCampaigns_Updates]
--SELECT * INTO dbo.[SponsoredBrandsCampaigns_Updates] FROM [dbo].[SponsoredBrandsCampaigns_ImportTableBackup]


DECLARE @ClicksTrigger float = '20'
DECLARE @ACoSTrigger float = '120'
DECLARE @MaxBidChangePercent float = '.20'
DECLARE @RecordTypeFilter varchar(50) = 'Keyword'

SELECT *  FROM [TwinScrollsMarketing].[dbo].[SponsoredBrandsCampaigns_ImportTableBackup]
WHERE  CONVERT(float, (REPLACE([ACoS],'%', ''))) > @ACoSTrigger
	AND CONVERT(float, [Clicks]) > @ClicksTrigger
	AND [Record Type] = @RecordTypeFilter
	AND [Campaign] NOT LIKE '%- Auto%'
ORDER BY [Record ID] ASC

UPDATE [TwinScrollsMarketing].[dbo].[SponsoredBrandsCampaigns_Updates]
SET [Max Bid] = (CASE WHEN [Max Bid] = '' THEN CONVERT(decimal(18,2),(SELECT MAX(CONVERT(float, [Max Bid])) 
					FROM  [dbo].[SponsoredBrandsCampaigns_Updates] m 
					WHERE m.[Record Type] = 'Ad Group' 
					AND [SponsoredBrandsCampaigns_Updates].Campaign = m.Campaign 
					AND [SponsoredBrandsCampaigns_Updates].[Ad Group] = m.[Ad Group] 
					AND m.[Keyword] = ''
					GROUP BY [Campaign]) * (1 - @MaxBidChangePercent)) --Converts our new [Max Bid] value
					ELSE CONVERT(decimal(18,2), [Max Bid] * (1 - @MaxBidChangePercent))
					 
					END)  
	,[Notes] = 'The Sponsored Brand ' + [Match Type] + ' match keyword' + ' "' +
				[Keyword] + '" ' + 'bid has been decreased by' + ' ' 
				+ CONVERT(VARCHAR(50), (@MaxBidChangePercent * 100)) + '% from' + ' ' + 
				CONVERT(VARCHAR(10), (CASE WHEN [Max Bid] = '' THEN CONVERT(decimal(18,2),(SELECT MAX(CONVERT(float, [Max Bid])) 
					FROM  [dbo].[SponsoredBrandsCampaigns_Updates] m 
					WHERE m.[Record Type] = 'Ad Group' 
					AND [SponsoredBrandsCampaigns_Updates].Campaign = m.Campaign 
					AND [SponsoredBrandsCampaigns_Updates].[Ad Group] = m.[Ad Group] 
					AND m.[Keyword] = ''
					GROUP BY [Campaign])) --Converts our new [Max Bid] value
					ELSE [Max Bid]
					 
					END) ) + ' ' 
				+ 'to' + ' ' + 
				CONVERT(VARCHAR(10), (CASE WHEN [Max Bid] = '' THEN CONVERT(decimal(18,2),(SELECT MAX(CONVERT(float, [Max Bid])) 
					FROM  [dbo].[SponsoredBrandsCampaigns_Updates] m 
					WHERE m.[Record Type] = 'Ad Group' 
					AND [SponsoredBrandsCampaigns_Updates].Campaign = m.Campaign 
					AND [SponsoredBrandsCampaigns_Updates].[Ad Group] = m.[Ad Group] 
					AND m.[Keyword] = ''
					GROUP BY [Campaign]) * (1 - @MaxBidChangePercent)) --Converts our new [Max Bid] value
					ELSE CONVERT(decimal(18,2), [Max Bid] * (1 - @MaxBidChangePercent))
					 END))
		,[Brand] = [Campaign]
		,[Product Group] = [Campaign]
WHERE  CONVERT(float, (REPLACE([ACoS],'%', ''))) > @ACoSTrigger
	AND CONVERT(float, [Clicks]) > @ClicksTrigger
	AND [Record Type] = @RecordTypeFilter
	AND [Campaign] NOT LIKE '%- Auto%'

SELECT *  FROM [TwinScrollsMarketing].[dbo].[SponsoredBrandsCampaigns_Updates]
WHERE  CONVERT(float, (REPLACE([ACoS],'%', ''))) > @ACoSTrigger
	AND CONVERT(float, [Clicks]) > @ClicksTrigger
	AND [Record Type] = @RecordTypeFilter 
	AND [Campaign] NOT LIKE '%- Auto%'
ORDER BY [Record ID] ASC





