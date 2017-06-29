SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetWhereUsedProductID]
@StartProductID [int],
@CheckDate [datetime]
AS
BEGIN
SET NOCOUNT ON;
WITH [BOM_cte]([ProductAssemblyID], [ComponentID], [ComponentDesc], [PerAssemblyQty], [StandardCost], [ListPrice], [BOMLevel], [RecursionLevel])
AS (
SELECT b.[ProductAssemblyID], b.[ComponentID], p.[Name], b.[PerAssemblyQty], p.[StandardCost], p.[ListPrice], b.[BOMLevel], 0
FROM [Production].[BillOfMaterials] b
INNER JOIN [Production].[Product] p
ON b.[ProductAssemblyID] = p.[ProductID]
WHERE b.[ComponentID] = @StartProductID
AND @CheckDate >= b.[StartDate]
AND @CheckDate <= ISNULL(b.[EndDate], @CheckDate)
UNION ALL
SELECT b.[ProductAssemblyID], b.[ComponentID], p.[Name], b.[PerAssemblyQty], p.[StandardCost], p.[ListPrice], b.[BOMLevel], [RecursionLevel] + 1
FROM [BOM_cte] cte
INNER JOIN [Production].[BillOfMaterials] b
ON cte.[ProductAssemblyID] = b.[ComponentID]
INNER JOIN [Production].[Product] p
ON b.[ProductAssemblyID] = p.[ProductID]
WHERE @CheckDate >= b.[StartDate]
AND @CheckDate <= ISNULL(b.[EndDate], @CheckDate)
)
SELECT b.[ProductAssemblyID], b.[ComponentID], b.[ComponentDesc], SUM(b.[PerAssemblyQty]) AS [TotalQuantity] , b.[StandardCost], b.[ListPrice], b.[BOMLevel], b.[RecursionLevel]
FROM [BOM_cte] b
GROUP BY b.[ComponentID], b.[ComponentDesc], b.[ProductAssemblyID], b.[BOMLevel], b.[RecursionLevel], b.[StandardCost], b.[ListPrice]
ORDER BY b.[BOMLevel], b.[ProductAssemblyID], b.[ComponentID]
OPTION (MAXRECURSION 25)
END;
GO
EXEC sp_addextendedproperty N'MS_Description', N'Stored procedure using a recursive query to return all components or assemblies that directly or indirectly use the specified ProductID.', 'SCHEMA', N'dbo', 'PROCEDURE', N'uspGetWhereUsedProductID', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Input parameter for the stored procedure uspGetWhereUsedProductID used to eliminate components not used after that date. Enter a valid date.', 'SCHEMA', N'dbo', 'PROCEDURE', N'uspGetWhereUsedProductID', 'PARAMETER', N'@CheckDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Input parameter for the stored procedure uspGetWhereUsedProductID. Enter a valid ProductID from the Production.Product table.', 'SCHEMA', N'dbo', 'PROCEDURE', N'uspGetWhereUsedProductID', 'PARAMETER', N'@StartProductID'
GO
