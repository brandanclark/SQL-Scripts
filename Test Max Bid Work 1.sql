USE TwinScrollsMarketing

/**
Script for Step 1 of changes
"For every row where Record Type = 'Keyword' AND Clicks > 40 AND Sales = 0, you want to update the Status column, column Q, to read 'paused'
AND
print "Keyword [insert keyword] has been paused" into a new column"
WHEN max bid is blank, then you need to reference the max bid for the record type = ad group and campaign = campaign and ad group column = ad group column
**/

DECLARE @ClicksTrigger float = '40'
DECLARE @SalesTrigger float = '0'
DECLARE @NewStatus varchar(50) = 'paused'
DECLARE @RecordTypeFilter varchar(50) = 'Keyword'
--DECLARE @SQL varchar(max) = 'Keyword' + [Keyword or Product Training

SELECT *  FROM [TwinScrollsMarketing].[dbo].[SponsoredProductsCampaigns_ImportTableBackup]
WHERE CONVERT(float, [Clicks]) > @ClicksTrigger 
	AND CONVERT(float, [Sales]) = @SalesTrigger
	AND [Record Type] = @RecordTypeFilter

UPDATE [TwinScrollsMarketing].[dbo].[SponsoredProductsCampaigns_Updates]
SET [Status] = @Newstatus
,[Notes] = 'Keyword' + ' "' + [Keyword or Product Targeting] + '" ' + 'has been set to' + ' ' + @newstatus
WHERE CONVERT(float, [Clicks]) > @ClicksTrigger 
	AND CONVERT(float, [Sales]) = @SalesTrigger
	AND [Record Type] = @RecordTypeFilter

SELECT *  FROM [TwinScrollsMarketing].[dbo].[SponsoredProductsCampaigns_Updates]
WHERE CONVERT(float, [Clicks]) > @ClicksTrigger 
	AND CONVERT(float, [Sales]) = @SalesTrigger
	AND [Record Type] = @RecordTypeFilter





