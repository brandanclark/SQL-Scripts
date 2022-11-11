USE TwinScrollsMarketing

/**
Script for Step 3 of changes
For every row where Record Type = 'Keyword' OR Record Type = 'Product Targeting' AND Campaign NOT LIKE '%- Auto%'
AND Orders > 2 AND ACoS < 25%, you want to increase the Max Bid column by 20%
AND when Max Bid is blank, then you need to reference the Max Bid for the Record Type = 'Ad group' and Campaign = Campaign and Ad Group column = Ad Group column
AND print "Keyword [insert keyword] Max Bid has been increased by 20% from [original] to [new]" into a new column  
**/

/** Syntax to reset table to backup **/
--DROP TABLE [dbo].[SponsoredProductsCampaigns_Updates]
--SELECT * INTO dbo.[SponsoredProductsCampaigns_Updates] FROM [dbo].[SponsoredProductsCampaigns_ImportTableBackup]


DECLARE @OrdersTrigger float = '2'
DECLARE @ACoSTrigger float = '25'
DECLARE @MaxBidChangePercent float = '.20'
DECLARE @RecordTypeFilter varchar(50) = 'Keyword'

SELECT *  FROM [TwinScrollsMarketing].[dbo].[SponsoredProductsCampaigns_ImportTableBackup]
WHERE  CONVERT(float, (REPLACE([ACoS],'%', ''))) < @ACoSTrigger
	AND CONVERT(float, [Orders]) > @OrdersTrigger
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
					ELSE CONVERT(decimal(18,2), [Max Bid] * (1 + @MaxBidChangePercent))
					 
					END)  
	,[Notes] = 'The ' + [Match Type] + ' match keyword' + ' "' + 
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
					ELSE CONVERT(decimal(18,2), [Max Bid] * (1 + @MaxBidChangePercent))
					 END))
		 ,[Brand] = LEFT(Campaign, CHARINDEX('-', Campaign + '-') - 1)
		,[Product Group] = LEFT(Campaign, CHARINDEX('-', Campaign, CHARINDEX('-', Campaign) + 1) -1 )
WHERE CONVERT(FLOAT, (REPLACE([ACoS], '%', ''))) < @ACoSTrigger
	AND CONVERT(FLOAT, [Orders]) > @OrdersTrigger
	AND ([Record Type] = @RecordTypeFilter OR [Record Type] = 'Product Targeting')
	AND [Campaign] NOT LIKE '%- Auto%'


SELECT *  FROM [TwinScrollsMarketing].[dbo].[SponsoredProductsCampaigns_Updates]
WHERE  CONVERT(float, (REPLACE([ACoS],'%', ''))) < @ACoSTrigger
	 AND CONVERT(float, [Orders]) > @OrdersTrigger
	AND ([Record Type] = @RecordTypeFilter OR [Record Type] = 'Product Targeting')
	AND [Campaign] NOT LIKE '%- Auto%'
ORDER BY [Record ID] ASC
	




