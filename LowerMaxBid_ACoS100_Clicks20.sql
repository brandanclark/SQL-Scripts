USE TwinScrollsMarketing

/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [Max Bid]
  FROM [TwinScrollsMarketing].[dbo].[SponsoredProductsCampaigns_DecToFeb]
  WHERE CONVERT(float, (REPLACE([ACoS],'%', ''))) > 100 AND CONVERT(float, Clicks) > 20

  SELECT [Max Bid]
  FROM [TwinScrollsMarketing].[dbo].[SponsoredProductsCampaigns_DecToFeb_Backup]
  WHERE CONVERT(float, (REPLACE([ACoS],'%', ''))) > 100 AND CONVERT(float, Clicks) > 20

  UPDATE [TwinScrollsMarketing].[dbo].[SponsoredProductsCampaigns_DecToFeb]
  SET [Max Bid] = (0.85 * CONVERT(FLOAT, [Max Bid]))
  WHERE CONVERT(float, (REPLACE([ACoS],'%', ''))) > 100 AND CONVERT(float, Clicks) > 20

