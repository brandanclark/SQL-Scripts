USE TwinScrollsMarketing

/**
Script for Step 3 of changes
For every row where Record Type = 'Keyword' AND Orders > 2 AND ACoS < 25%, you want to increase the Max Bid column by 25%
AND when Max Bid is blank, then you need to reference the Max Mid for the Record Type = 'Ad group' and Campaign = Campaign and Ad Group column = Ad Group column
AND print "Keyword [insert keyword] has been increased by 25% from [original] to [new]" into a new column  
**/

/** Syntax to reset table to backup **/
DROP TABLE [dbo].[SponsoredProductsCampaigns_Updates]
SELECT * INTO dbo.[SponsoredProductsCampaigns_Updates] FROM [dbo].[SponsoredProductsCampaigns_ImportTableBackup]


DECLARE @OrdersTrigger float = '2'
DECLARE @ACoSTrigger float = '25'
DECLARE @MaxBidChangePercent float = '.25'
DECLARE @RecordTypeFilter varchar(50) = 'Keyword'

SELECT *  FROM [TwinScrollsMarketing].[dbo].[SponsoredProductsCampaigns_ImportTableBackup]
WHERE  CONVERT(float, (REPLACE([ACoS],'%', ''))) < @ACoSTrigger
	AND CONVERT(float, [Orders]) > @OrdersTrigger
	AND [Record Type] = @RecordTypeFilter

UPDATE [TwinScrollsMarketing].[dbo].[SponsoredProductsCampaigns_Updates]
SET [Max Bid] = CASE 
		WHEN [Max Bid] <> ''
			THEN CONVERT(DECIMAL(18, 2), [Max Bid] * (1 + @MaxBidChangePercent))
		WHEN [Max Bid] = ''
			THEN (CONVERT(DECIMAL(18,2), (
					SELECT MAX(CONVERT(FLOAT, [Max Bid]))
					FROM [dbo].[SponsoredProductsCampaigns_NovToJan] m
					WHERE m.[Record Type] = 'Ad Group'
						AND [TwinScrollsMarketing].[dbo].[SponsoredProductsCampaigns_Updates].Campaign = m.Campaign
						AND [TwinScrollsMarketing].[dbo].[SponsoredProductsCampaigns_Updates].[Ad Group] = m.[Ad Group]
					GROUP BY [Campaign]
			) * (1 + @MaxBidChangePercent)	))	
		ELSE [Max Bid]
		END  
	,[Notes] = 'Keyword' + ' "' + [Keyword or Product Targeting] + '" ' + 'bid has been increased by' + ' ' + CONVERT(VARCHAR(50), (@MaxBidChangePercent * 100)) + '% from' + ' ' + CONVERT(VARCHAR(10), [Max Bid]) + ' ' + 'to' + ' ' + CONVERT(VARCHAR(10), CONVERT(DECIMAL(18, 2), [Max Bid] * (1 + @MaxBidChangePercent)))
WHERE CONVERT(FLOAT, (REPLACE([ACoS], '%', ''))) < @ACoSTrigger
	AND CONVERT(FLOAT, [Orders]) > @OrdersTrigger
	AND [Record Type] = @RecordTypeFilter


SELECT *  FROM [TwinScrollsMarketing].[dbo].[SponsoredProductsCampaigns_Updates]
WHERE  CONVERT(float, (REPLACE([ACoS],'%', ''))) < @ACoSTrigger
	 AND CONVERT(float, [Orders]) > @OrdersTrigger
	AND [Record Type] = @RecordTypeFilter
	




