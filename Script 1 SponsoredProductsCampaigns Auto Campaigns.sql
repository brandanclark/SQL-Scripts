USE TwinScrollsMarketing

/**
Script for Step 1 of changes to Sponsored Products Campaigns table. Pause records with high clicks and zero sales
"For every row where Record Type = 'Keyword' OR Record Type = 'Product Targeting' AND Campaign NOT LIKE '%- Auto%'
AND Clicks > 40 AND Sales = 0, you want to update the Status column, column Q, to read 'paused'
AND print "Keyword [insert keyword] has been paused" into a new column"

+++ASK IF WE ACTUALLY USE THIS ONE OR NOT+++

**/

/** Syntax to reset table to backup **/
--DROP TABLE [dbo].[SponsoredProductsCampaigns_Updates]
--SELECT * INTO dbo.[SponsoredProductsCampaigns_Updates] FROM [dbo].[SponsoredProductsCampaigns_ImportTableBackup]

DECLARE @ClicksTrigger float = '40'
DECLARE @SalesTrigger float = '0'
DECLARE @NewStatus varchar(50) = 'paused'
DECLARE @RecordTypeFilter varchar(50) = 'Product Targeting'
--DECLARE @SQL varchar(max) = 'Keyword' + [Keyword or Product Training]

SELECT *  FROM [TwinScrollsMarketing].[dbo].[SponsoredProductsCampaigns_ImportTableBackup]
WHERE (CONVERT(float, [Clicks]) > @ClicksTrigger  
	AND CONVERT(float, [Sales]) = @SalesTrigger
	--AND [Record Type] = @RecordTypeFilter
	AND [Campaign] LIKE '%Auto%'
	AND [Campaign] NOT LIKE '%Auto Low%')
	OR (CONVERT(float, [Clicks]) > 60  
	AND CONVERT(float, [Sales]) = @SalesTrigger
	--AND [Record Type] = @RecordTypeFilter
	AND [Campaign] LIKE '%Auto%'
	AND [Campaign] NOT LIKE '%Auto Low%'
	AND [Match Type] LIKE '%broad%')
ORDER BY [Record ID] ASC

UPDATE [TwinScrollsMarketing].[dbo].[SponsoredProductsCampaigns_Updates]
SET [Status] = @Newstatus
,[Notes] = 'The Sponsored Products ' + [Match Type] + ' match keyword' + ' "' + ISNULL([Keyword or Product Targeting], '') + '" ' + 'has been set to' + ' ' + @newstatus
		,[Brand] = CASE WHEN [Campaign] LIKE '%-%' THEN LEFT(Campaign, CHARINDEX('-', Campaign + '-') - 1) ELSE Campaign END
		,[Product Group] = CASE WHEN [Campaign] LIKE '%-%' THEN LEFT(Campaign, CHARINDEX('-', Campaign, CHARINDEX('-', Campaign) + 1) -1 ) ELSE Campaign END 
WHERE CONVERT(float, [Clicks]) > @ClicksTrigger 
	AND CONVERT(float, [Sales]) = @SalesTrigger
	AND ([Record Type] = @RecordTypeFilter OR [Record Type] = 'Product Targeting')
	AND [Campaign] NOT LIKE '%- Auto%'

SELECT *  FROM [TwinScrollsMarketing].[dbo].[SponsoredProductsCampaigns_Updates]
WHERE CONVERT(float, [Clicks]) > @ClicksTrigger 
	AND CONVERT(float, [Sales]) = @SalesTrigger
	AND ([Record Type] = @RecordTypeFilter OR [Record Type] = 'Product Targeting')
	AND [Campaign] NOT LIKE '%- Auto%'
ORDER BY [Record ID] ASC




	
