SELECT DB_NAME(database_id) AS database_name, 
    type_desc, 
    name AS FileName, 
    size/128.0 AS CurrentSizeMB
FROM sys.master_files
WHERE database_id > 6 AND type IN (0,1)

--------------------------------------------------------------------------------------------------------------
SELECT DISTINCT DB_NAME(dovs.database_id) DBName,
mf.physical_name PhysicalFileLocation,
dovs.logical_volume_name AS LogicalName,
dovs.volume_mount_point AS Drive,
CONVERT(INT,dovs.available_bytes/1048576.0) AS FreeSpaceInMB
FROM sys.master_files mf
CROSS APPLY sys.dm_os_volume_stats(mf.database_id, mf.FILE_ID) dovs
ORDER BY FreeSpaceInMB ASC
GO

--------------------------------------------------------------------------------------------------------------
EXEC MASTER..xp_fixeddrives
GO

--------------------------------------------------------------------------------------------------------------
SELECT * from master.sys.sql_logins
--------------------------------------------------------------------------------------------------------------
	
SELECT DB_NAME() AS DbName, 
    name AS FileName, 
    type_desc,
    size/128.0 AS CurrentSizeMB,  
    size/128.0 - CAST(FILEPROPERTY(name, 'SpaceUsed') AS INT)/128.0 AS FreeSpaceMB
FROM sys.database_files
WHERE type IN (0,1);
--------------------------------------------------------------------------------------------------------------

CREATE TABLE #FileSize
(dbName NVARCHAR(128), 
    FileName NVARCHAR(128), 
    type_desc NVARCHAR(128),
    CurrentSizeMB DECIMAL(10,2), 
    FreeSpaceMB DECIMAL(10,2)
);
    
INSERT INTO #FileSize(dbName, FileName, type_desc, CurrentSizeMB, FreeSpaceMB)
exec sp_msforeachdb 
'use [?]; 
 SELECT DB_NAME() AS DbName, 
        name AS FileName, 
        type_desc,
        size/128.0 AS CurrentSizeMB,  
        size/128.0 - CAST(FILEPROPERTY(name, ''SpaceUsed'') AS INT)/128.0 AS FreeSpaceMB
FROM sys.database_files
WHERE type IN (0,1);';
    
SELECT * FROM #FileSize
WHERE dbName NOT IN ('distribution', 'master', 'model', 'msdb')
AND FreeSpaceMB > 10;
    
DROP TABLE #FileSize;
--------------------------------------------------------------------------------------------------------------
--get CPU usage by database for particular instance?
;WITH cte AS
(
  SELECT stat.[sql_handle],
         stat.statement_start_offset,
         stat.statement_end_offset,
         COUNT(*) AS [NumExecutionPlans],
         SUM(stat.execution_count) AS [TotalExecutions],
         ((SUM(stat.total_logical_reads) * 1.0) / SUM(stat.execution_count)) AS [AvgLogicalReads],
         ((SUM(stat.total_worker_time) * 1.0) / SUM(stat.execution_count)) AS [AvgCPU]
  FROM sys.dm_exec_query_stats stat
  GROUP BY stat.[sql_handle], stat.statement_start_offset, stat.statement_end_offset
)
SELECT CONVERT(DECIMAL(15, 5), cte.AvgCPU) AS [AvgCPU],
       CONVERT(DECIMAL(15, 5), cte.AvgLogicalReads) AS [AvgLogicalReads],
       cte.NumExecutionPlans,
       cte.TotalExecutions,
       DB_NAME(txt.[dbid]) AS [DatabaseName],
       OBJECT_NAME(txt.objectid, txt.[dbid]) AS [ObjectName],
       SUBSTRING(txt.[text], (cte.statement_start_offset / 2) + 1,
       (
         (CASE cte.statement_end_offset 
           WHEN -1 THEN DATALENGTH(txt.[text])
           ELSE cte.statement_end_offset
          END - cte.statement_start_offset) / 2
         ) + 1
       )
FROM cte
CROSS APPLY sys.dm_exec_sql_text(cte.[sql_handle]) txt
ORDER BY cte.AvgCPU DESC;
--------------------------------------------------------------------------------------------------------------
EXEC sp_spaceused 
     @updateusage = 'FALSE', 
     @mode = 'ALL', 
     @oneresultset = '1', 
     @include_total_xtp_storage = '1';
GO
--------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------
