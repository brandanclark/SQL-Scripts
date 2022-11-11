USE TwinScrollsMarketing

/**
Script for Step 2 of changes
For every row where Record Type = 'Keyword' AND ACoS > 100 AND Clicks > 20, you want to decrease the Max Bid column by 15%
and print "Keyword [insert keyword] has been decreased by 15% from [original] to [new]" into a new column  "
**/

/** Syntax to reset table to backup **/
DROP TABLE [dbo].[SponsoredProductsCampaigns_Updates]
SELECT * INTO dbo.[SponsoredProductsCampaigns_Updates] FROM [dbo].[SponsoredProductsCampaigns_ImportTableBackup]


DECLARE @ClicksTrigger float = '20'
DECLARE @ACoSTrigger float = '100'
DECLARE @MaxBidChangePercent float = '.15'
DECLARE @RecordTypeFilter varchar(50) = 'Keyword'

SELECT *  FROM [TwinScrollsMarketing].[dbo].[SponsoredProductsCampaigns_ImportTableBackup]
WHERE  CONVERT(float, (REPLACE([ACoS],'%', ''))) > @ACoSTrigger
	AND CONVERT(float, [Clicks]) > @ClicksTrigger
	AND [Record Type] = @RecordTypeFilter

UPDATE [TwinScrollsMarketing].[dbo].[SponsoredProductsCampaigns_Updates]
SET [Max Bid] = CONVERT(Decimal(18,2), [Max Bid] * (1 - @MaxBidChangePercent))
,[Notes] = 'Keyword' + ' "' + [Keyword or Product Targeting] + '" ' + 'bid has been decreased by' + ' ' + CONVERT(varchar(50), (@MaxBidChangePercent * 100)) + '% from' + ' ' + CONVERT(varchar(10), [Max Bid]) + ' ' + 'to' + ' ' + CONVERT(varchar(10), CONVERT(Decimal(18,2), [Max Bid] * (1 - @MaxBidChangePercent)))
WHERE  CONVERT(float, (REPLACE([ACoS],'%', ''))) > @ACoSTrigger
	AND CONVERT(float, [Clicks]) > @ClicksTrigger
	AND [Record Type] = @RecordTypeFilter

SELECT *  FROM [TwinScrollsMarketing].[dbo].[SponsoredProductsCampaigns_Updates]
WHERE  CONVERT(float, (REPLACE([ACoS],'%', ''))) > @ACoSTrigger
	AND CONVERT(float, [Clicks]) > @ClicksTrigger
	AND [Record Type] = @RecordTypeFilter





