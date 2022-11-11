USE TwinScrollsMarketing

/**
Script for Step 3 of changes
For every row where Record Type = 'Keyword' AND Orders > 2 AND ACoS < 25%, you want to increase the Max Bid column by 25%
and print "Keyword [insert keyword] has been increased by 25% from [original] to [new]" into a new column  
**/

DECLARE @OrdersTrigger float = '2'
DECLARE @ACoSTrigger float = '25'
DECLARE @MaxBidChangePercent float = '.25'
DECLARE @RecordTypeFilter varchar(50) = 'Keyword'

SELECT *  FROM [TwinScrollsMarketing].[dbo].[SponsoredProductsCampaigns_Updates]
WHERE  CONVERT(float, (REPLACE([ACoS],'%', ''))) < @ACoSTrigger
	AND CONVERT(float, [Orders]) > @OrdersTrigger
	AND [Record Type] = @RecordTypeFilter

UPDATE [TwinScrollsMarketing].[dbo].[SponsoredProductsCampaigns_Updates]
SET [Max Bid] = CONVERT(Decimal(18,2), [Max Bid] * (1 + @MaxBidChangePercent))
,[Notes] = 'Keyword' + ' "' + [Keyword or Product Targeting] + '" ' + 'bid has been increased by' + ' ' + CONVERT(varchar(50), (@MaxBidChangePercent * 100)) + '% from' + ' ' + CONVERT(varchar(10), [Max Bid]) + ' ' + 'to' + ' ' + CONVERT(varchar(10), CONVERT(Decimal(18,2), [Max Bid] * (1 + @MaxBidChangePercent)))
WHERE  CONVERT(float, (REPLACE([ACoS],'%', ''))) < @ACoSTrigger
	AND CONVERT(float, [Orders]) > @OrdersTrigger
	AND [Record Type] = @RecordTypeFilter

SELECT *  FROM [TwinScrollsMarketing].[dbo].[SponsoredProductsCampaigns_Updates]
WHERE  CONVERT(float, (REPLACE([ACoS],'%', ''))) < @ACoSTrigger
	AND CONVERT(float, [Orders]) > @OrdersTrigger
	AND [Record Type] = @RecordTypeFilter





