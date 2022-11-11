USE TwinScrollsMarketing

/**
Script for Step 4 of changes to Sponsored Products Campaigns table. Increase the 'Increase Bids By Placement' column for Campaigns where the ACoS for Top of Search is cheaper than Rest of Search and Product Pages
Steps:
For every row where Record Type = 'Campaign By Placement'
Increase the 'Increase Bids by Placement' column by .2 if the Top of Search row ACoS is > the ACoS for Rest of Search OR Product Pages
and print "Campaign [insert Campaign] Top Of Search has been increased by 20% from [original] to [new]" into a new column"
**/

/** Syntax to reset table to backup **/
--DROP TABLE [dbo].[SponsoredProductsCampaigns_Updates]
--SELECT * INTO dbo.[SponsoredProductsCampaigns_Updates] FROM [dbo].[SponsoredProductsCampaigns_ImportTableBackup]

SELECT * FROM [TwinScrollsMarketing].dbo.[SponsoredProductsCampaigns_ImportTableBackup]
WHERE [Record Type] = 'Campaign by Placement' AND [Placement Type] = 'Top of search (page 1)'
AND CONVERT(float, (REPLACE([ACoS],'%', ''))) < (SELECT MAX (CONVERT(float, (REPLACE([ACoS],'%', '')))) FROM dbo.[SponsoredProductsCampaigns_Updates] m
 WHERE m.[Placement Type] <> 'Top of search (page 1)'
 AND [SponsoredProductsCampaigns_ImportTableBackup].Campaign = m.Campaign)
ORDER BY Campaign

UPDATE [TwinScrollsMarketing].dbo.[SponsoredProductsCampaigns_Updates]
SET [Increase bids by placement] = CASE WHEN (CONVERT(float, (REPLACE([Increase bids by placement], '%', ''))) + 20) > 150 THEN '150%' ELSE 
FORMAT((CONVERT(float, (REPLACE([Increase bids by placement], '%', ''))) + 20)/100, 'P0') END
	,[Notes] = 'Campaign ' + [Campaign] + ' Top of Search placement bid has been increased by 20% from ' + CONVERT(VARCHAR(10), [Increase bids by Placement]) + ' to ' + CONVERT(VARCHAR(20), CASE WHEN (CONVERT(float, (REPLACE([Increase bids by placement], '%', ''))) + 20) > 150 THEN '150%' ELSE 
FORMAT((CONVERT(float, (REPLACE([Increase bids by placement], '%', ''))) + 20)/100, 'P0') END)
		,[Brand] = CASE WHEN [Campaign] LIKE '%-%' THEN LEFT(Campaign, CHARINDEX('-', Campaign + '-') - 1) ELSE Campaign END
		,[Product Group] = CASE WHEN [Campaign] LIKE '%-%' THEN LEFT(Campaign, CHARINDEX('-', Campaign, CHARINDEX('-', Campaign) + 1) -1 ) ELSE Campaign END 
	WHERE [Record Type] = 'Campaign by Placement' AND [Placement Type] = 'Top of search (page 1)'
	AND CONVERT(float, (REPLACE([ACoS],'%', ''))) < (SELECT MAX (CONVERT(float, (REPLACE([ACoS],'%', '')))) FROM dbo.[SponsoredProductsCampaigns_Updates] m
	 WHERE m.[Placement Type] <> 'Top of search (page 1)'
	 AND [TwinScrollsMarketing].dbo.[SponsoredProductsCampaigns_Updates].Campaign = m.Campaign)

SELECT * FROM [TwinScrollsMarketing].dbo.[SponsoredProductsCampaigns_Updates]
WHERE [Record Type] = 'Campaign by Placement' AND [Placement Type] = 'Top of search (page 1)'
AND CONVERT(float, (REPLACE([ACoS],'%', ''))) < (SELECT MAX (CONVERT(float, (REPLACE([ACoS],'%', '')))) FROM dbo.[SponsoredProductsCampaigns_Updates] m
 WHERE m.[Placement Type] <> 'Top of search (page 1)'
 AND [SponsoredProductsCampaigns_Updates].Campaign = m.Campaign)
ORDER BY Campaign

	 