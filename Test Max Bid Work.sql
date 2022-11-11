SELECT [Record Type]
	,[Campaign]
	,[Ad Group]
	,[Max Bid]
	,[ACos]
	,[Clicks]
	,[Keyword or Product Targeting]
	, [Max Bid] = CASE WHEN [Max Bid] = '' THEN (SELECT MAX(CONVERT(float, [Max Bid])) 
					FROM  [dbo].[SponsoredProductsCampaigns_NovToJan] m 
					WHERE m.[Record Type] = 'Ad Group' AND o.Campaign = m.Campaign AND o.[Ad Group] = m.[Ad Group] GROUP BY [Campaign])
					ELSE [Max Bid] 
					END

 FROM [dbo].[SponsoredProductsCampaigns_NovToJan] o
WHERE [Record ID] IN ( '259611661362120',
'85572770469627'
,'229200892122070')

DECLARE @OrdersTrigger float = '2'
DECLARE @ACoSTrigger float = '25'
DECLARE @MaxBidChangePercent float = '.25'
DECLARE @RecordTypeFilter varchar(50) = 'Keyword'

UPDATE [TwinScrollsMarketing].[dbo].[SponsoredProductsCampaigns_NovToJan]
SET [Max Bid] = CASE 
		WHEN [Max Bid] <> ''
			THEN CONVERT(DECIMAL(18, 2), [Max Bid] * (1 + @MaxBidChangePercent))
		WHEN [Max Bid] = ''
			THEN (CONVERT(DECIMAL(18,2), (
					SELECT MAX(CONVERT(FLOAT, [Max Bid]))
					FROM [dbo].[SponsoredProductsCampaigns_NovToJan] m
					WHERE m.[Record Type] = 'Ad Group'
						AND [TwinScrollsMarketing].[dbo].[SponsoredProductsCampaigns_NovToJan].Campaign = m.Campaign
						AND [TwinScrollsMarketing].[dbo].[SponsoredProductsCampaigns_NovToJan].[Ad Group] = m.[Ad Group]
					GROUP BY [Campaign]
			) * (1 + @MaxBidChangePercent)	))	
		ELSE [Max Bid]
		END  
	,[Notes] = 'Keyword' + ' "' + [Keyword or Product Targeting] + '" ' + 'bid has been increased by' + ' ' + CONVERT(VARCHAR(50), (@MaxBidChangePercent * 100)) + '% from' + ' ' + CONVERT(VARCHAR(10), [Max Bid]) + ' ' + 'to' + ' ' + CONVERT(VARCHAR(10), CONVERT(DECIMAL(18, 2), [Max Bid] * (1 + @MaxBidChangePercent)))
WHERE [Record ID] IN ( '259611661362120',
'85572770469627'
,'229200892122070')

SELECT * 
 FROM [dbo].[SponsoredProductsCampaigns_NovToJan] o
WHERE [Record ID] IN ( '259611661362120',
'85572770469627'
,'229200892122070')

--CONVERT(FLOAT, (REPLACE([ACoS], '%', ''))) < @ACoSTrigger
--AND CONVERT(FLOAT, [Orders]) > @OrdersTrigger
--AND [Record Type] = @RecordTypeFilter
