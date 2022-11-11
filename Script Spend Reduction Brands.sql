USE TwinScrollsMarketing

/**
Script for spend reduction changes to Sponsored Products Campaigns table. 
Steps:
Increse Max Bid by 10% if ACoS is less than 25%
Decrease Max Bid by 15% if ACos between 90% and 120%
Cap all bids at $10

For every row where Record Type = 'Keyword' OR Record Type = 'Product Targeting' AND Campaign NOT LIKE '%- Auto%'
AND when Max Bid is blank, then you need to reference the Max Bid for the Record Type = 'Ad group' and Campaign = Campaign and Ad Group column = Ad Group column
and print "Keyword [insert keyword] has been decreased by 20% from [original] to [new]" into a new column  "
**/

/** Syntax to reset table to backup **/
DROP TABLE [dbo].[SponsoredBrandsCampaigns_Updates]
SELECT * INTO dbo.[SponsoredBrandsCampaigns_Updates] FROM [dbo].[SponsoredBrandsCampaigns_ImportTableBackup]

DECLARE @ClicksTrigger float = '10'
DECLARE @IncreaseBidPercent float = '.10'
DECLARE @DecreaseBidPercent float = '.15'
DECLARE @RecordTypeFilter varchar(50) = 'Keyword'

SELECT * FROM [TwinScrollsMarketing].[dbo].[SponsoredBrandsCampaigns_ImportTableBackup] 
WHERE (CONVERT(float, (REPLACE([ACoS],'%', ''))) < '25'
	OR CONVERT(float, (REPLACE([ACoS],'%', ''))) BETWEEN '90' AND '120'
	OR CONVERT(float, [Max Bid]) > 10)
	AND CONVERT(float, [Clicks]) > @ClicksTrigger
	AND ([Record Type] = @RecordTypeFilter OR [Record Type] = 'Product Targeting')
	AND [Campaign] NOT LIKE '%- Auto%'
	AND CONVERT(Float, [Orders]) > 0
ORDER BY [Record ID] ASC

UPDATE [TwinScrollsMarketing].[dbo].[SponsoredBrandsCampaigns_Updates]
SET [Max Bid] = CASE 
		WHEN CONVERT(FLOAT, (REPLACE([ACoS], '%', ''))) < '25'
			THEN (
					CASE 
						WHEN (
								CASE 
									WHEN [Max Bid] = ''
										THEN CONVERT(DECIMAL(18, 2), (
													SELECT MAX(CONVERT(FLOAT, [Max Bid]))
													FROM [dbo].[SponsoredBrandsCampaigns_Updates] m
													WHERE m.[Record Type] = 'Ad Group'
														AND [SponsoredBrandsCampaigns_Updates].Campaign = m.Campaign
														AND [SponsoredBrandsCampaigns_Updates].[Ad Group] = m.[Ad Group]
														AND m.[Keyword] = ''
													GROUP BY [Campaign]
													) * (1 + @IncreaseBidPercent)) --Converts our new [Max Bid] value
									ELSE CONVERT(DECIMAL(18, 2), [Max Bid] * (1 + @IncreaseBidPercent))
									END
								) > '10'
							THEN '10.00'
						ELSE (
								CASE 
									WHEN [Max Bid] = ''
										THEN CONVERT(DECIMAL(18, 2), (
													SELECT MAX(CONVERT(FLOAT, [Max Bid]))
													FROM [dbo].[SponsoredBrandsCampaigns_Updates] m
													WHERE m.[Record Type] = 'Ad Group'
														AND [SponsoredBrandsCampaigns_Updates].Campaign = m.Campaign
														AND [SponsoredBrandsCampaigns_Updates].[Ad Group] = m.[Ad Group]
														AND m.[Keyword] = ''
													GROUP BY [Campaign]
													) * (1 + @IncreaseBidPercent)) --Converts our new [Max Bid] value
									ELSE CONVERT(DECIMAL(18, 2), [Max Bid] * (1 + @IncreaseBidPercent))
									END
								)
						END
					)
		WHEN CONVERT(FLOAT, (REPLACE([ACoS], '%', ''))) BETWEEN '90'
				AND '120'
			THEN (
					CASE 
						WHEN (
								CASE 
									WHEN [Max Bid] = ''
										THEN CONVERT(DECIMAL(18, 2), (
													SELECT MAX(CONVERT(FLOAT, [Max Bid]))
													FROM [dbo].[SponsoredBrandsCampaigns_Updates] m
													WHERE m.[Record Type] = 'Ad Group'
														AND [SponsoredBrandsCampaigns_Updates].Campaign = m.Campaign
														AND [SponsoredBrandsCampaigns_Updates].[Ad Group] = m.[Ad Group]
														AND m.[Keyword] = ''
													GROUP BY [Campaign]
													) * (1 - @DecreaseBidPercent)) --Converts our new [Max Bid] value
									ELSE CONVERT(DECIMAL(18, 2), [Max Bid] * (1 - @DecreaseBidPercent))
									END
								) > '10'
							THEN '10.00'
						ELSE (
								CASE 
									WHEN [Max Bid] = ''
										THEN CONVERT(DECIMAL(18, 2), (
													SELECT MAX(CONVERT(FLOAT, [Max Bid]))
													FROM [dbo].[SponsoredBrandsCampaigns_Updates] m
													WHERE m.[Record Type] = 'Ad Group'
														AND [SponsoredBrandsCampaigns_Updates].Campaign = m.Campaign
														AND [SponsoredBrandsCampaigns_Updates].[Ad Group] = m.[Ad Group]
														AND m.[Keyword] = ''
													GROUP BY [Campaign]
													) * (1 - @DecreaseBidPercent)) --Converts our new [Max Bid] value
									ELSE CONVERT(DECIMAL(18, 2), [Max Bid] * (1 - @DecreaseBidPercent))
									END
								)
						END
					)
		ELSE [Max Bid]
		END
	,[Notes] = CASE 
		WHEN CONVERT(FLOAT, (REPLACE([ACoS], '%', ''))) < '25'
			THEN 'The Sponsored Product ' + [Match Type] + ' match keyword' + ' "' + [Keyword] + '" ' + 'bid has been increased by' + ' ' + CONVERT(VARCHAR(50), (@IncreaseBidPercent * 100)) + '% from' + ' ' + CONVERT(VARCHAR(10), (
						CASE 
							WHEN [Max Bid] = ''
								THEN CONVERT(DECIMAL(18, 2), (
											SELECT MAX(CONVERT(FLOAT, [Max Bid]))
											FROM [dbo].[SponsoredBrandsCampaigns_Updates] m
											WHERE m.[Record Type] = 'Ad Group'
												AND [SponsoredBrandsCampaigns_Updates].Campaign = m.Campaign
												AND [SponsoredBrandsCampaigns_Updates].[Ad Group] = m.[Ad Group]
												AND m.[Keyword] = ''
											GROUP BY [Campaign]
											)) --Converts our new [Max Bid] value
							ELSE [Max Bid]
							END
						)) + ' ' + 'to' + ' ' + CASE 
					WHEN CONVERT(float, (
							CONVERT(VARCHAR(10), (
									CASE 
										WHEN [Max Bid] = ''
											THEN CONVERT(DECIMAL(18, 2), (
														SELECT MAX(CONVERT(FLOAT, [Max Bid]))
														FROM [dbo].[SponsoredBrandsCampaigns_Updates] m
														WHERE m.[Record Type] = 'Ad Group'
															AND [SponsoredBrandsCampaigns_Updates].Campaign = m.Campaign
															AND [SponsoredBrandsCampaigns_Updates].[Ad Group] = m.[Ad Group]
															AND m.[Keyword] = ''
														GROUP BY [Campaign]
														) * (1 + @IncreaseBidPercent)) --Converts our new [Max Bid] value
										ELSE CONVERT(DECIMAL(18, 2), [Max Bid] * (1 + @IncreaseBidPercent))
										END
									))
							)) > '10.00'
						THEN '10.00'
					ELSE (
							CONVERT(VARCHAR(10), (
									CASE 
										WHEN [Max Bid] = ''
											THEN CONVERT(DECIMAL(18, 2), (
														SELECT MAX(CONVERT(FLOAT, [Max Bid]))
														FROM [dbo].[SponsoredBrandsCampaigns_Updates] m
														WHERE m.[Record Type] = 'Ad Group'
															AND [SponsoredBrandsCampaigns_Updates].Campaign = m.Campaign
															AND [SponsoredBrandsCampaigns_Updates].[Ad Group] = m.[Ad Group]
															AND m.[Keyword] = ''
														GROUP BY [Campaign]
														) * (1 + @IncreaseBidPercent)) --Converts our new [Max Bid] value
										ELSE CONVERT(DECIMAL(18, 2), [Max Bid] * (1 + @IncreaseBidPercent))
										END
									))
							)
					END
		WHEN CONVERT(FLOAT, (REPLACE([ACoS], '%', ''))) BETWEEN '90'
				AND '120'
			THEN 'The Sponsored Product ' + [Match Type] + ' match keyword' + ' "' + [Keyword] + '" ' + 'bid has been decreased by' + ' ' + CONVERT(VARCHAR(50), (@DecreaseBidPercent * 100)) + '% from' + ' ' + CONVERT(VARCHAR(10), (
						CASE 
							WHEN [Max Bid] = ''
								THEN CONVERT(DECIMAL(18, 2), (
											SELECT MAX(CONVERT(FLOAT, [Max Bid]))
											FROM [dbo].[SponsoredBrandsCampaigns_Updates] m
											WHERE m.[Record Type] = 'Ad Group'
												AND [SponsoredBrandsCampaigns_Updates].Campaign = m.Campaign
												AND [SponsoredBrandsCampaigns_Updates].[Ad Group] = m.[Ad Group]
												AND m.[Keyword] = ''
											GROUP BY [Campaign]
											)) --Converts our new [Max Bid] value
							ELSE [Max Bid]
							END
						)) + ' ' + 'to' + ' ' + CASE 
					WHEN CONVERT(float, (
							CONVERT(VARCHAR(10), (
									CASE 
										WHEN [Max Bid] = ''
											THEN CONVERT(DECIMAL(18, 2), (
														SELECT MAX(CONVERT(FLOAT, [Max Bid]))
														FROM [dbo].[SponsoredBrandsCampaigns_Updates] m
														WHERE m.[Record Type] = 'Ad Group'
															AND [SponsoredBrandsCampaigns_Updates].Campaign = m.Campaign
															AND [SponsoredBrandsCampaigns_Updates].[Ad Group] = m.[Ad Group]
															AND m.[Keyword] = ''
														GROUP BY [Campaign]
														) * (1 - @DecreaseBidPercent)) --Converts our new [Max Bid] value
										ELSE CONVERT(DECIMAL(18, 2), [Max Bid] * (1 - @DecreaseBidPercent))
										END
									))
							)) > '10.00'
						THEN '10.00'
					ELSE (
							CONVERT(VARCHAR(10), (
									CASE 
										WHEN [Max Bid] = ''
											THEN CONVERT(DECIMAL(18, 2), (
														SELECT MAX(CONVERT(FLOAT, [Max Bid]))
														FROM [dbo].[SponsoredBrandsCampaigns_Updates] m
														WHERE m.[Record Type] = 'Ad Group'
															AND [SponsoredBrandsCampaigns_Updates].Campaign = m.Campaign
															AND [SponsoredBrandsCampaigns_Updates].[Ad Group] = m.[Ad Group]
															AND m.[Keyword] = ''
														GROUP BY [Campaign]
														) * (1 - @DecreaseBidPercent)) --Converts our new [Max Bid] value
										ELSE CONVERT(DECIMAL(18, 2), [Max Bid] * (1 - @DecreaseBidPercent))
										END
									))
							)
					END
		ELSE [Notes]
		END
	,[Brand] = CASE 
		WHEN [Campaign] LIKE '%-%'
			THEN [Campaign] --LEFT(Campaign, CHARINDEX('-', Campaign + '-') - 1)
		ELSE Campaign
		END
	,[Product Group] = CASE 
		WHEN [Campaign] LIKE '%-%'
			THEN [Campaign] --LEFT(Campaign, CHARINDEX('-', Campaign, CHARINDEX('-', Campaign) + 1) - 1)
		ELSE Campaign
		END
WHERE (CONVERT(float, (REPLACE([ACoS],'%', ''))) < '25'
	OR CONVERT(float, (REPLACE([ACoS],'%', ''))) BETWEEN '90' AND '120'
	OR CONVERT(float, [Max Bid]) > 10)
	AND CONVERT(float, [Clicks]) > @ClicksTrigger
	AND ([Record Type] = @RecordTypeFilter OR [Record Type] = 'Product Targeting')
	AND [Campaign] NOT LIKE '%- Auto%'
	AND CONVERT(Float, [Orders]) > 0

--DECLARE @ClicksTrigger float = '10'
--DECLARE @IncreaseBidPercent float = '.10'
--DECLARE @DecreaseBidPercent float = '.15'
--DECLARE @RecordTypeFilter varchar(50) = 'Keyword'

SELECT *  FROM [TwinScrollsMarketing].[dbo].[SponsoredBrandsCampaigns_Updates]
WHERE (CONVERT(float, (REPLACE([ACoS],'%', ''))) < '25'
	OR CONVERT(float, (REPLACE([ACoS],'%', ''))) BETWEEN '90' AND '120'
	OR CONVERT(float, [Max Bid]) > 10)
	AND CONVERT(float, [Clicks]) > @ClicksTrigger
	AND ([Record Type] = @RecordTypeFilter OR [Record Type] = 'Product Targeting')
	AND [Campaign] NOT LIKE '%- Auto%'
	AND CONVERT(Float, [Orders]) > 0
ORDER BY [Record ID] ASC


