USE TwinScrollsMarketing

/**
Script for Step 1 of changes to the Sponsored Brands Campaigns table. Pausing Brand Keywords that have high clicks and no sales.
"For every row where Record Type = 'Keyword' OR Record Type = 'Product Targeting' AND Match Type like Broad
AND Clicks > 40 AND Sales = 0, you want to update the Status column, column Q, to read 'paused'
AND print "The Sponsored Brands Keyword [insert keyword] has been paused" into a new column"
**/

/** Syntax to reset table to backup **/
DROP TABLE [dbo].[SponsoredBrandsCampaigns_Updates]
SELECT * INTO dbo.[SponsoredBrandsCampaigns_Updates] FROM [dbo].[SponsoredBrandsCampaigns_ImportTableBackup]

DECLARE @ClicksTrigger float = '40'
DECLARE @SalesTrigger float = '0'
DECLARE @NewStatus varchar(50) = 'paused'
DECLARE @RecordTypeFilter varchar(50) = 'Keyword'
--DECLARE @SQL varchar(max) = 'Keyword' + [Keyword or Product Training

SELECT *  FROM [TwinScrollsMarketing].[dbo].[SponsoredBrandsCampaigns_ImportTableBackup]
WHERE (CONVERT(float, [Clicks]) > @ClicksTrigger 
	AND CONVERT(float, [Sales]) = @SalesTrigger
	AND ([Record Type] = @RecordTypeFilter OR [Record Type] = 'Product Targeting')
	--AND [Campaign] NOT LIKE '%- Auto%'
	AND [Match Type] NOT LIKE '%broad%')
	OR
	(CONVERT(float, [Clicks]) > 60 
	AND CONVERT(float, [Sales]) = @SalesTrigger
	AND ([Record Type] = @RecordTypeFilter OR [Record Type] = 'Product Targeting')
	--AND [Campaign] NOT LIKE '%- Auto%'
	AND [Match Type] LIKE '%broad%')
ORDER BY [Record ID] ASC

UPDATE [TwinScrollsMarketing].[dbo].[SponsoredBrandsCampaigns_Updates]
SET [Status] = @Newstatus
,[Notes] = 'The Sponsored Brands ' + [Match Type] + ' match keyword' + ' "' + ISNULL([Keyword], '') + '" ' + 'has been set to' + ' ' + @newstatus
,[Brand] = [Campaign]
,[Product Group] = [Campaign]
WHERE (CONVERT(float, [Clicks]) > @ClicksTrigger 
	AND CONVERT(float, [Sales]) = @SalesTrigger
	AND ([Record Type] = @RecordTypeFilter OR [Record Type] = 'Product Targeting')
	--AND [Campaign] NOT LIKE '%- Auto%'
	AND [Match Type] NOT LIKE '%broad%')
	OR
	(CONVERT(float, [Clicks]) > 60 
	AND CONVERT(float, [Sales]) = @SalesTrigger
	AND ([Record Type] = @RecordTypeFilter OR [Record Type] = 'Product Targeting')
	--AND [Campaign] NOT LIKE '%- Auto%'
	AND [Match Type] LIKE '%broad%')

SELECT *  FROM [TwinScrollsMarketing].[dbo].[SponsoredBrandsCampaigns_Updates]
WHERE (CONVERT(float, [Clicks]) > @ClicksTrigger 
	AND CONVERT(float, [Sales]) = @SalesTrigger
	AND ([Record Type] = @RecordTypeFilter OR [Record Type] = 'Product Targeting')
	--AND [Campaign] NOT LIKE '%- Auto%'
	AND [Match Type] NOT LIKE '%broad%')
	OR
	(CONVERT(float, [Clicks]) > 60 
	AND CONVERT(float, [Sales]) = @SalesTrigger
	AND ([Record Type] = @RecordTypeFilter OR [Record Type] = 'Product Targeting')
	--AND [Campaign] NOT LIKE '%- Auto%'
	AND [Match Type] LIKE '%broad%')
ORDER BY [Record ID] ASC




	
