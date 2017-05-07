/*
*****************************************************************************************************************
Developed By          : Nakul Vachhrajani
Functionality         : This script demonstrates the impact table variables have on cardinality estimation
How to Use            : Run step-by-step through the sequence
Resources             :
Modifications         :
May 05, 2017 - NAV - Created
*****************************************************************************************************************
*/

--Using the SQL 2016 sample database
USE [WideWorldImporters];
GO

--Declare the table variable
DECLARE @stockItemTransactions TABLE 
            ([StockItemTransactionId] INT NOT NULL 
                                      PRIMARY KEY CLUSTERED,
             [StockItemId] INT NOT NULL
            );

--Insert some test data
INSERT INTO @stockItemTransactions ([StockItemTransactionId], [StockItemId])
SELECT [sit].[StockItemTransactionID],
       [sit].[StockItemID]
FROM [Warehouse].[StockItemTransactions] AS [sit]
WHERE ([sit].[StockItemTransactionID] % 8) = 0;

--Fetch data from the temporary table
--Make sure that "Show Actual Execution Plan" (Ctrl + M) is shown
SELECT * FROM @stockItemTransactions;

--Now, check the "Clustered Index Scan" on the final SELECT
GO








/* WHAT'S GOING ON?
*
*
*
* Execution plans indicate how a query is being executed/evaluated.
* Database Engine generates plans based on statistics which are similar to "best case estimates"
* Because they are variables, table variables do not have statistics.
*
* By default, a variable stores only one value. 
* Hence, it is assumed that if its' a table variable, it will store only one record
*
*
* Table variables iwth more than a few hundred or thousand rows result in bad plans, impacting performance!
*
* 
* Any change to the number of rows in a table variable does not update the statistics, and hence
* does not impact the execution plan
*
*
*
*
*
*
*/


--Solution is to use temporary tables
--Using the SQL 2016 sample database
USE [WideWorldImporters];
GO

IF OBJECT_ID('tempdb..#stockItemTransactions','U') IS NOT NULL
BEGIN
    DROP TABLE #stockItemTransactions;
END
GO

--Declare the table variable
CREATE TABLE #stockItemTransactions
            ([StockItemTransactionId] INT NOT NULL 
                                      PRIMARY KEY CLUSTERED,
             [StockItemId] INT NOT NULL
            );
GO

--Insert some test data
INSERT INTO #stockItemTransactions ([StockItemTransactionId], [StockItemId])
SELECT [sit].[StockItemTransactionID],
       [sit].[StockItemID]
FROM [Warehouse].[StockItemTransactions] AS [sit]
WHERE ([sit].[StockItemTransactionID] % 8) = 0;
GO

--Fetch data from the temporary table
--Make sure that "Show Actual Execution Plan" (Ctrl + M) is shown
SELECT * FROM #stockItemTransactions;

--Now, check the "Clustered Index Scan" on the final SELECT
GO

--Cleanup
IF OBJECT_ID('tempdb..#stockItemTransactions','U') IS NOT NULL
BEGIN
    DROP TABLE #stockItemTransactions;
END
GO
