USE TwinScrollsMarketing

/**
Script for Step 3 of changes to the Sponsored Brands Campaigns table. Increasing Max Bid for Brands with low ACoS and high orders
Steps:
For every row where Record Type = 'Keyword' OR Record Type = 'Product Targeting' AND Campaign NOT LIKE '%- Auto%'
AND Orders > 2 AND ACoS < 25%, you want to increase the Max Bid column by 20%
AND when Max Bid is blank, then you need to reference the Max Bid for the Record Type = 'Ad group' and Campaign = Campaign and Ad Group column = Ad Group column
AND if new Max Bid > 20, set Max Bid to 20
AND print "Keyword [insert keyword] Max Bid has been increased by 20% from [original] to [new]" into a new column  
**/

/** Syntax to reset table to backup **/
--DROP TABLE [dbo].[SponsoredBrandsCampaigns_Updates]
--SELECT * INTO dbo.[SponsoredBrandsCampaigns_Updates] FROM [dbo].[SponsoredBrandsCampaigns_ImportTableBackup]


DECLARE @OrdersTrigger float = '2'
DECLARE @ACoSTrigger float = '25'
DECLARE @MaxBidChangePercent float = '.20'
DECLARE @RecordTypeFilter varchar(50) = 'Keyword'

SELECT *  FROM [TwinScrollsMarketing].[dbo].[SponsoredBrandsCampaigns_ImportTableBackup]
WHERE  CONVERT(float, (REPLACE([ACoS],'%', ''))) < @ACoSTrigger
	AND CONVERT(float, [Orders]) > @OrdersTrigger
	AND ([Record Type] = @RecordTypeFilter OR [Record Type] = 'Product Targeting')
	AND [Campaign] NOT LIKE '%- Auto%'
ORDER BY [Record ID] ASC

UPDATE [TwinScrollsMarketing].[dbo].[SponsoredBrandsCampaigns_Updates]
SET [Max Bid] = (CASE WHEN [Max Bid] = '' THEN CONVERT(decimal(18,2),(SELECT MAX(CONVERT(float, [Max Bid])) 
					FROM  [dbo].[SponsoredBrandsCampaigns_Updates] m 
					WHERE m.[Record Type] = 'Ad Group' 
					AND [SponsoredBrandsCampaigns_Updates].Campaign = m.Campaign 
					AND [SponsoredBrandsCampaigns_Updates].[Ad Group] = m.[Ad Group] 
					AND m.[Keyword] = ''
					GROUP BY [Campaign]) * (1 + @MaxBidChangePercent)) --Converts our new [Max Bid] value
					WHEN (CONVERT(decimal(18,2), [Max Bid] * (1 + @MaxBidChangePercent)) > 20) THEN CONVERT(decimal(18,2), 20)
					ELSE CONVERT(decimal(18,2), [Max Bid] * (1 + @MaxBidChangePercent))
					 
					END)  
	,[Notes] = 'The Sponsored Brands ' + [Match Type] + ' match keyword' + ' "' + 
				[Keyword] + '" ' + 'bid has been increased by' + ' ' 
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
					GROUP BY [Campaign]) * (1 + @MaxBidChangePercent)) --Converts our new [Max Bid] value
					WHEN (CONVERT(decimal(18,2), [Max Bid] * (1 + @MaxBidChangePercent)) > 20) THEN CONVERT(decimal(18,2), 20)
					ELSE CONVERT(decimal(18,2), [Max Bid] * (1 + @MaxBidChangePercent))
					 END))
		 ,[Brand] = [Campaign]
		,[Product Group] = [Campaign]
WHERE CONVERT(FLOAT, (REPLACE([ACoS], '%', ''))) < @ACoSTrigger
	AND CONVERT(FLOAT, [Orders]) > @OrdersTrigger
	AND ([Record Type] = @RecordTypeFilter OR [Record Type] = 'Product Targeting')
	AND [Campaign] NOT LIKE '%- Auto%'


SELECT *  FROM [TwinScrollsMarketing].[dbo].[SponsoredBrandsCampaigns_Updates]
WHERE  CONVERT(float, (REPLACE([ACoS],'%', ''))) < @ACoSTrigger
	 AND CONVERT(float, [Orders]) > @OrdersTrigger
	AND ([Record Type] = @RecordTypeFilter OR [Record Type] = 'Product Targeting')
	AND [Campaign] NOT LIKE '%- Auto%'
ORDER BY [Record ID] ASC
	




