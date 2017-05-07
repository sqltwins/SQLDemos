/*
*****************************************************************************************************************
Developed By          : Nakul Vachhrajani
Functionality         : This script attempts to demonstrate the impact of transactions on table variables
How to Use            : Run step-by-step through the sequence
Resources             :
Modifications         :
May 05, 2017 - NAV - Created
*****************************************************************************************************************
*/

--Let's study how transactions impact temporary tables first


--Safety Check
IF OBJECT_ID('tempdb..#studentInformation','U') IS NOT NULL
BEGIN
    DROP TABLE #studentInformation;
END
GO

CREATE TABLE #studentInformation (StudentId   INT          NOT NULL,
                                  StudentName VARCHAR(255) NOT NULL
                                 );
GO

--Again, note the scope and use of GO!

--Begin a transaction and insert something
BEGIN TRANSACTION InsertStudentInformation
    INSERT INTO #studentInformation (StudentId, StudentName)
    VALUES (12345, 'Nakul Vachhrajani');

    --Let's check if it's inserted
    SELECT 'Inside Transaction' AS DebugPointLocation,
           si.StudentId,
           si.StudentName
    FROM #studentInformation AS si;




--Now, let's rollback the transaction
ROLLBACK TRANSACTION InsertStudentInformation
GO

--Let's check if we still have the data?
SELECT 'Outside Transaction' AS DebugPointLocation,
        si.StudentId,
        si.StudentName
FROM #studentInformation AS si;
GO







-- Let's see if table variables behave in the same way








DECLARE @studentInformation TABLE (StudentId   INT          NOT NULL,
                                   StudentName VARCHAR(255) NOT NULL
                                  );

--Begin a transaction and insert something
BEGIN TRANSACTION InsertStudentInformation
    INSERT INTO @studentInformation (StudentId, StudentName)
    VALUES (12345, 'Nakul Vachhrajani');

    --Let's check if it's inserted
    SELECT 'Inside Transaction' AS DebugPointLocation,
           si.StudentId,
           si.StudentName
    FROM @studentInformation AS si;




--Now, let's rollback the transaction
ROLLBACK TRANSACTION InsertStudentInformation


--NOTE: We are in the same batch!
--Let's check if we still have the data?
SELECT 'Outside Transaction' AS DebugPointLocation,
        si.StudentId,
        si.StudentName
FROM @studentInformation AS si;
GO