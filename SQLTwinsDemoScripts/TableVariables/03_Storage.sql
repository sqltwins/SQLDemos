/*
*****************************************************************************************************************
Developed By          : Nakul Vachhrajani
Functionality         : This script attempts to demonstrate the storage of table variables
How to Use            : Run step-by-step through the sequence
                      : For an ideal demo, DO NOT run this against the tempdb
Resources             :
Modifications         :
April 23, 2017 - NAV - Created
*****************************************************************************************************************
*/







--WHERE ARE TABLE VARIABLES STORED?











--Confirm that there is nothing going on which would generate tempdb activity
SELECT ExecutingSQLStatement.[text]           AS [ExecutingStatement],
       DB_NAME(executingSessions.database_id) AS [ConnectedDatabase],
       executingSessions.[host_name]          AS [ConnectedHost],
       executingRequests.[status]             AS [RequestStatus]
FROM sys.dm_exec_requests AS executingRequests
INNER JOIN sys.dm_exec_sessions AS executingSessions ON executingRequests.session_id = executingSessions.session_id
CROSS APPLY sys.dm_exec_sql_text(executingRequests.[sql_handle]) AS ExecutingSQLStatement
WHERE executingSessions.[status] NOT IN ('sleeping');







/* STEP 01: HOW BIG  IS THE TEMPDB RIGHT NOW? */

USE [tempdb];
GO

--Monitor the current space characteristics of the TempDB
--NOTE: The DMV - sys.dm_db_file_space_storage is only valid for the TEMPDB
SELECT DB_NAME() AS [DatabaseName],
       SUM(user_object_reserved_page_count)     * 8.192 AS [UserObjectsKB], 
       SUM(internal_object_reserved_page_count) * 8.192 AS [InternalObjectsKB],
       SUM(version_store_reserved_page_count)   * 8.192 AS [VersonStoreKB],
       SUM(unallocated_extent_page_count)       * 8.192 AS [FreeSpaceKB]
FROM tempdb.sys.dm_db_file_space_usage;






/* STEP 02: SWITCH TO A USER DATABASE CONTEXT */
-- Turn on actual query execution plan

USE [WideWorldImporters];
GO

-- Declare a Table variable, and insert some data into it
DECLARE @MyTable TABLE (ID     INT IDENTITY (1,1), 
                        MyName VARCHAR(100))


--Insert a large amount of data into the table variable
INSERT INTO @MyTable
SELECT msc.name + CONVERT(VARCHAR(10),ROUND(RAND()*1000,0))
FROM msdb.sys.objects mso (NOLOCK)
CROSS JOIN msdb.sys.columns msc (NOLOCK);

--Confirm that data was inserted
SELECT COUNT(*) FROM @MyTable;
GO






/* STEP 03: HOW BIG  IS THE TEMPDB NOW? */

USE [tempdb];
GO
SELECT DB_NAME() AS [DatabaseName],
       SUM(user_object_reserved_page_count)     * 8.192 AS [UserObjectsKB], 
       SUM(internal_object_reserved_page_count) * 8.192 AS [InternalObjectsKB],
       SUM(version_store_reserved_page_count)   * 8.192 AS [VersonStoreKB],
       SUM(unallocated_extent_page_count)       * 8.192 AS [FreeSpaceKB]
FROM tempdb.sys.dm_db_file_space_usage;
GO
/*
*
*
*
*
*
*
*
* CONCLUSION:
* Table Variables are stored on the tempdb.
* tempdb is one of the busiest databases and hence, use of table variables can cause I/O issues.
* It also consumes disk space!
*
*
*
/