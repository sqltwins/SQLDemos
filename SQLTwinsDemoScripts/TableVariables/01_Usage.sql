/*
*****************************************************************************************************************
Developed By          : Nakul Vachhrajani
Functionality         : This script demonstrates the ease and flexibility of using table variables
How to Use            : Run step-by-step through the sequence
Resources             :
                      : Trivia: https://support.microsoft.com/en-us/help/305977/inf-frequently-asked-questions---sql-server-2000---table-variables
Modifications         :
April 23, 2017 - NAV - Created
*****************************************************************************************************************
*/


--Create something to stage StudentIds and Names
CREATE TABLE #stageStudentInfo (StudentID INT,
                                StudentName VARCHAR(50)
                               );
GO

--Check that it works
INSERT INTO #stageStudentInfo (StudentID, StudentName)
VALUES (1, 'Nakul');
GO

--Fetch the inserted value
SELECT ssi.StudentID,
       ssi.StudentName
FROM #stageStudentInfo AS ssi;
GO











--But, what if we need to run the script again?
--Let's try it and see!










--Explicit management of temporary tables is required as long as the connection remains active
IF OBJECT_ID('tempdb..#stageStudentInfo','U') IS NOT NULL
BEGIN
    DROP TABLE #stageStudentInfo;
END
GO










--Table Variables
DECLARE @stageStudentInfo TABLE (StudentID INT,
                                 StudentName VARCHAR(50)
                                );

--Insert some data into it
INSERT INTO @stageStudentInfo (StudentID, StudentName)
VALUES (101, 'SQLTwins');

--Select from the table variable
SELECT ssi.StudentID,
       ssi.StudentName
FROM @stageStudentInfo AS ssi;
GO