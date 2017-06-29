SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [Person].[vStateProvinceCountryRegion]
WITH SCHEMABINDING
AS
SELECT
sp.[StateProvinceID]
,sp.[StateProvinceCode]
,sp.[IsOnlyStateProvinceFlag]
,sp.[Name] AS [StateProvinceName]
,sp.[TerritoryID]
,cr.[CountryRegionCode]
,cr.[Name] AS [CountryRegionName]
FROM [Person].[StateProvince] sp
INNER JOIN [Person].[CountryRegion] cr
ON sp.[CountryRegionCode] = cr.[CountryRegionCode];
GO
EXEC sp_addextendedproperty N'MS_Description', N'Joins StateProvince table with CountryRegion table.', 'SCHEMA', N'Person', 'VIEW', N'vStateProvinceCountryRegion', NULL, NULL
GO
