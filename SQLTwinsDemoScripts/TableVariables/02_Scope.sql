/*
*****************************************************************************************************************
Developed By          : Nakul Vachhrajani
Functionality         : This script demonstrates the scope of table variables v/s temp tables
                        It also shows why table variables cannot be used to exchange information
How to Use            : Run step-by-step through the sequence
Resources             :
Modifications         :
April 23, 2017 - NAV - Created
*****************************************************************************************************************
*/
--Most common scenario - Exchange information the old-fashioned way! (SQL 2000 anybody?)

--Assume we have a data exchange required only for one screen
--Architects have decided this is not sufficient a reason to create a new table type (or your front-end can't support it)









--Safety Check
IF OBJECT_ID('dbo.proc_AddNumbers','P')  IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.proc_AddNumbers;
END
GO
CREATE PROCEDURE dbo.proc_AddNumbers
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE nta
    SET nta.SumOfNumbers = nta.NumberA + nta.NumberB
    FROM #numbersToAdd AS nta;
END
GO

--How many of you think this stored procedure will be created?







--Safety Checks, again!
IF OBJECT_ID('tempdb..#numbersToAdd','U') IS NOT NULL
BEGIN
    DROP TABLE #numbersToAdd;
END
GO

--Create the table
CREATE TABLE #numbersToAdd (NumberA INT,
                            NumberB INT,
                            SumOfNumbers INT
                           );
GO

--Insert some test data
INSERT INTO #numbersToAdd (NumberA, NumberB)
VALUES (1,2),
       (1,3),
       (1,4);
GO

--Make sure we did not populate SumOfNumbers column
SELECT nta.NumberA,
       nta.NumberB,
       nta.SumOfNumbers
FROM #numbersToAdd AS nta;
GO

EXEC dbo.proc_AddNumbers;
GO

--Is the Sum populated
SELECT nta.NumberA,
       nta.NumberB,
       nta.SumOfNumbers
FROM #numbersToAdd AS nta;
GO

/* CONCLUSION: As long as the connection remains the same,
               local temporary tables remain available
               for use even though the statements are not in the same batch
               ("GO" terminates a batch)
*/

--Cleanup
IF OBJECT_ID('dbo.proc_AddNumbers','P')  IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.proc_AddNumbers;
END
GO









--But...











--Can we do the same with table variables?
--Let's ensure that we can extend table variables across batches

--Create the table variable
DECLARE @numbersToAdd TABLE (NumberA INT,
                             NumberB INT,
                             SumOfNumbers INT
                            );
GO

--Insert some test data
INSERT INTO @numbersToAdd (NumberA, NumberB)
VALUES (1,2),
       (1,3),
       (1,4);
GO

--Make sure we did not populate SumOfNumbers column
SELECT nta.NumberA,
       nta.NumberB,
       nta.SumOfNumbers
FROM @numbersToAdd AS nta;
GO

--Was it successful?









/* CONCLUSION: Because table variables are batch-sensitive, 
               they can't be used to exchange information across batches
*/