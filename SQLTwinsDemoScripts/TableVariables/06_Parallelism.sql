/*
*****************************************************************************************************************
Developed By          : Nakul Vachhrajani
Functionality         : This script demonstrates how table variables are functionally different
How to Use            : Run step-by-step through the sequence
Resources             :
Modifications         :
May 05, 2017 - NAV - Created
*****************************************************************************************************************
*/

sp_configure 'show advanced options',1;
RECONFIGURE
GO

sp_configure 'max degree of parallelism',0;
RECONFIGURE
GO

--Re-run the query: 05_Cardinality.sql
--Study plan and optimization information

sp_configure 'max degree of parallelism',1;
RECONFIGURE
GO


sp_configure 'show advanced options',0;
RECONFIGURE
GO