USE TwinScrollsMarketing

/**
Script for Step 2 of changes
For every row where Record Type = 'Keyword' AND ACoS > 100 AND Clicks > 20, you want to decrease the Max Bid column by 15%
and print "Keyword [insert keyword] has been decreased by 15% from [original] to [new]" into a new column  "
WHEN max bid is blank, then you need to reference the max bid for the record type = ad group and campaign = campaign and ad group column = ad group column
**/

/** Syntax to reset table to backup **/
DROP TABLE [dbo].[SponsoredProductsCampaigns_Updates]
SELECT * INTO dbo.[SponsoredProductsCampaigns_Updates] FROM [dbo].[SponsoredProductsCampaigns_ImportTableBackup]


DECLARE @ClicksTrigger float = '20'
DECLARE @ACoSTrigger float = '100'
DECLARE @MaxBidChangePercent float = '.15'
DECLARE @RecordTypeFilter varchar(50) = 'Keyword'

SELECT *,  CASE 
		WHEN [Max Bid] <> ''
			THEN CONVERT(DECIMAL(18, 2), [Max Bid] * (1 - @MaxBidChangePercent))
		WHEN [Max Bid] = ''
			THEN (CONVERT(DECIMAL(18,2), (
					SELECT MAX(CONVERT(FLOAT, [Max Bid]))
					FROM [dbo].[SponsoredProductsCampaigns_NovToJan] m
					WHERE m.[Record Type] = 'Ad Group'
						AND [TwinScrollsMarketing].[dbo].[SponsoredProductsCampaigns_ImportTableBackup].Campaign = m.Campaign
						AND [TwinScrollsMarketing].[dbo].[SponsoredProductsCampaigns_ImportTableBackup].[Ad Group] = m.[Ad Group]
					GROUP BY [Campaign]
			) * (1 + @MaxBidChangePercent)	))	
		ELSE [Max Bid]
		END    
FROM [TwinScrollsMarketing].[dbo].[SponsoredProductsCampaigns_ImportTableBackup]
WHERE  --CONVERT(float, (REPLACE([ACoS],'%', ''))) > @ACoSTrigger
	--AND CONVERT(float, [Clicks]) > @ClicksTrigger
	--AND [Record Type] = @RecordTypeFilter
	 [Record ID] IN ( '259611661362120','85572770469627','229200892122070')

UPDATE [TwinScrollsMarketing].[dbo].[SponsoredProductsCampaigns_Updates]
SET  [Max Bid] = CASE 
		WHEN [Max Bid] <> ''
			THEN CONVERT(DECIMAL(18, 2), [Max Bid] * (1 - @MaxBidChangePercent))
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
,[Notes] = 'Keyword' + ' "' + [Keyword or Product Targeting] + '" ' + 'bid has been decreased by' + ' ' + CONVERT(varchar(50), (@MaxBidChangePercent * 100)) + '% from' + ' ' + CONVERT(varchar(10), [Max Bid]) + ' ' + 'to' + ' ' + CONVERT(varchar(10), CONVERT(Decimal(18,2), [Max Bid] * (1 - @MaxBidChangePercent)))
WHERE  [Record ID] IN ( '259611661362120',
'85572770469627'
,'229200892122070')
--CONVERT(float, (REPLACE([ACoS],'%', ''))) > @ACoSTrigger
--	AND CONVERT(float, [Clicks]) > @ClicksTrigger
--	AND [Record Type] = @RecordTypeFilter

SELECT *  FROM [TwinScrollsMarketing].[dbo].[SponsoredProductsCampaigns_Updates]
WHERE 	 [Record ID] IN ( '259611661362120',
'85572770469627'
,'229200892122070') 
--CONVERT(float, (REPLACE([ACoS],'%', ''))) > @ACoSTrigger
	--AND CONVERT(float, [Clicks]) > @ClicksTrigger
	--AND [Record Type] = @RecordTypeFilter



--WHEN max bid is blank, then you need to reference the max bid for the record type = ad group and campaign = campaign and ad group column = ad group column

