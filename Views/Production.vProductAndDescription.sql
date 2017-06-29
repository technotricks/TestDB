SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE VIEW [Production].[vProductAndDescription]
WITH SCHEMABINDING
AS
SELECT
p.[ProductID]
,p.[Name]
,pm.[Name] AS [ProductModel]
,pmx.[CultureID]
,pd.[Description]
FROM [Production].[Product] p
INNER JOIN [Production].[ProductModel] pm
ON p.[ProductModelID] = pm.[ProductModelID]
INNER JOIN [Production].[ProductModelProductDescriptionCulture] pmx
ON pm.[ProductModelID] = pmx.[ProductModelID]
INNER JOIN [Production].[ProductDescription] pd
ON pmx.[ProductDescriptionID] = pd.[ProductDescriptionID];
GO
EXEC sp_addextendedproperty N'MS_Description', N'Product names and descriptions. Product descriptions are provided in multiple languages.', 'SCHEMA', N'Production', 'VIEW', N'vProductAndDescription', NULL, NULL
GO
SET ANSI_PADDING ON
GO
CREATE UNIQUE CLUSTERED INDEX [IX_vProductAndDescription]
	ON [Production].[vProductAndDescription] ([CultureID], [ProductID])
	ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index on the view vProductAndDescription.', 'SCHEMA', N'Production', 'VIEW', N'vProductAndDescription', 'INDEX', N'IX_vProductAndDescription'
GO
