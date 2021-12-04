-------------------------- erişimimiz olan databaseleri listeler --------------------------
select * from sys.databases where HAS_DBACCESS(name) = 1

-------------------------- image to mssql --------------------------
select * from openrowset(BULK N'hakan.png', single_blob) as t1)
  
  
-------------------------- Tüm dataları siler id yi de resetler --------------------------
  DELETE [database].[schema].[tablename]                             
  DBCC CHECKIDENT ('[database].[schema].[tablename]', RESEED, 0);
  GO


-------------------------- Tablo2 de olup Tablo1 de olmayan --------------------------
select  * from Table1 a 
where not exists (select  1 from Table2 b where rtrim(ltrim (a.TCKNO ))
collate Turkish_CI_AI=rtrim(ltrim (b.TCKNO )) collate Turkish_CI_AI);

-------------------------- Langitude ve Latitude mesafe hesaplama --------------------------
  DECLARE @source geography = 'POINT(0 51.5)'
  DECLARE @target geography = 'point(-3 56)'
  select @source.STDistance(@target)
  
 -------------------------- change schema --------------------------
  if (not exists (select * from sys.schemas where name = 'hsv'))
  begin
     exec('create schema [hsv] authorization [dbo]')
  end

  alter schema hsv
      transfer dbo.arac
      
 ---------------------------- Data Transfer From Sql Server To Text File Using BCP format ----------------------------

declare @output nvarchar(1000), @filepath nvarchar(1000), @bcp nvarchar(1000)
set @bcp = 'bcp "select * from sys.traces" queryout '
set @filepath = 'C:\x\'
set @output = 'text.txt'
set @bcp = @bcp + @filepath + @output + ' -c -t, -T -S'+ @@SERVERNAME
EXEC master..xp_cmdshell @bcp

	 
 -------------------------- a ile b nin kesişimi --------------------------
 a intersect b  
 --a da var b de yok
 a except b       
 
-------------------------- -------------------------- 
EXEC sp_MSforeachdb N'
IF N''?'' NOT IN(N''master'',N''model'',N''tempdb'',N''msdb'',N''SSISDB'')
BEGIN
        USE [?];
    INSERT INTO #TableList
		 SELECT * FROM TableName1.INFORMATION_SCHEMA.TABLES;
		INSERT INTO #TableList
		 SELECT * FROM TableName1.INFORMATION_SCHEMA.TABLES;
END;';

------------------------------- Call StoreProcedure Using LinkedServer  -------------------------------
1)Create LinkedName and change RCP and RCP OUT (True) in LinkedName Properties
2)exec ('exec DatabasName.schema.StoreProcedureName') at [LinkedName]
  or
  exec ('DatabasName.schema.StoreProcedureName') at [LinkedName]
  
  
-------------------------- indexini bul --------------------------
  select PATINDEX('%[ ]%','hakan mazi')   --ilk boşluğun indexini bul
  select PATINDEX('%[_-]%','hakan mazi')   --ilk _ yada - indexini bul
  
--------------------------   --------------------------
use DatabaseName
go
select
s.name as schemaName,
t.name as tableName,
p.rows as RowCounts,
cast(round((sum(a.used_pages)/128.00),2) as numeric(36,2)) as KullanılanAlanMb,
cast(round((sum(a.total_pages)/128.00),2) as numeric(36,2)) as ToplamAlanMb
from sys.tables t
inner join sys.indexes i on t.object_id = i.object_id
inner join sys.partitions p on i.object_id = p.object_id and i.index_id = p.index_id
inner join sys.allocation_units a on p.partition_id = a.container_id
inner join sys.schemas s on t.schema_id = s.schema_id
group by t.Name, s.Name, p.Rows 
order by s.name, t.name
go

-- Update tabloyu select query kullanarak
update table1 
set = ( select column from table2 
        where table1.id = table2.id )


-- Sık kullanılan
select * from fn_get_audit_file('P:\audits\*.sqlaudit',default,default)


-------------------------- io and time statistics ------------------------------
set statistics io on
set statistics time on 
SELECT * FROM [NORTHWND].[dbo].[Orders] where ShipAddress = 'Luisenstr. 48'

-------------------------- Check for the backup --------------------------
SELECT 
 b.database_name,
    key_algorithm,
    encryptor_thumbprint,
    encryptor_type,
	b.media_set_id,
    is_encrypted, 
	type,
    is_compressed,
	bf.physical_device_name
	 FROM msdb.dbo.backupset b
INNER JOIN msdb.dbo.backupmediaset m ON b.media_set_id = m.media_set_id
INNER JOIN msdb.dbo.backupmediafamily bf on bf.media_set_id=b.media_set_id
WHERE database_name = 'NORTHWND'
ORDER BY b.backup_start_date  DESC


----------------------------------
------------ SYSTEM
----------------------------------
use master;
go

alter database [DatabaseName]
set single_user with rollback immediate
go

alter database [DatabaseName]
collate Turkish_CI_AS;
go

alter database [DatabaseName]
set multi_user with rollback immediate;
go

------------------------------- Delete Trigger -------------------------------
--SQL SERVER – Fix : Error : 17892 Logon failed for login due to trigger execution. Changed database context to ‘master’.
FirstWay
  USE master
  GO
  DROP TRIGGER [TriggerName] ON ALL SERVER
  GO
SecondWay
  C:\Users\Pinal>sqlcmd -S LocalHost -d master -A
  1> DROP TRIGGER Tr_ServerLogon ON ALL SERVER
  2> GO


----------------------------------
------------ Certificate
----------------------------------

------------ master key create 
use master;
go
create master key encryption by password = 'password1'
go

------------ create certificate 
use master 
go 
create certificate GenelCertifica
with subject = 'genel certificate',
expiry_date = '20500101'
go

------------ get certificate backup
use master
go 
backup certificate GenelCertifica to file = 'D:\cert\Crypto.cer' --real certificate
with private key ( File = 'D:\cert\Crypto.pvk', encryption by password = 'password1' ) --key
go





---------------------------- users vs logins ----------------------------
--https://dataedo.com/kb/query/sql-server/list-logins-on-server

select sp.name as login,
       sp.type_desc as login_type,
       sl.password_hash,
       sp.create_date,
       sp.modify_date,
       case when sp.is_disabled = 1 then 'Disabled'
            else 'Enabled' end as status
from sys.server_principals sp
left join sys.sql_logins sl
          on sp.principal_id = sl.principal_id
where sp.type not in ('G', 'R')
order by sp.name;


---------------------------- Remove Chars and get only numeric values ----------------------------
declare @phone nvarchar(100)
set @phone = '905414,.9p/6'

declare @count int, @total int, @combine nvarchar(2500), @newValue nvarchar(2500)
set @combine = ''
set @count = 1
set @total = len(@phone)

while @count <= @total
begin
	set @newValue = SUBSTRING(@phone,@count,1)
	--if ISNUMERIC(@newValue) = 1   /* this function show us  ., characters are numerics */
	if @newValue in ('0','1','2','3','4','5','6','7','8','9')
	begin
		set @combine = @combine + @newValue
	end
	else begin
		set @combine = @combine + ''
	end

	set @count = @count + 1
end 
print @combine



-- ExtendentEvents
------------------------------------ ringBuffer1 ------------------------------------
SELECT CAST(target_data as xml) AS targetdata
INTO #capture_waits_data
FROM sys.dm_xe_session_targets xet
JOIN sys.dm_xe_sessions xes
    ON xes.address = xet.event_session_address
WHERE xes.name = 'sql_control'
  AND xet.target_name = 'ring_buffer';
 

insert into #capture_waits_data
SELECT CAST(target_data as xml) AS targetdata
FROM sys.dm_xe_session_targets xet
JOIN sys.dm_xe_sessions xes
    ON xes.address = xet.event_session_address
WHERE xes.name = 'sql_control'
  AND xet.target_name = 'ring_buffer';

SELECT *
FROM #capture_waits_data;
--drop table #capture_waits_data

SELECT distinct
  xed.event_data.value('(@timestamp)[1]', 'datetime2') AS [timestamp],
  xed.event_data.value('(@name)[1]', 'varchar(max)') AS eventname,
  xed.event_data.value('(data[@name="database_name"]/value)[1]', 'varchar(200)') AS database_name,
  xed.event_data.value('(action[@name="username"]/value)[1]', 'varchar(max)') AS username,
  xed.event_data.value('(action[@name="sql_text"]/value)[1]', 'varchar(max)') AS sql_text,
  xed.event_data.value('(action[@name="session_nt_username"]/value)[1]', 'varchar(max)') AS session_nt_username,
  xed.event_data.value('(action[@name="client_app_name"]/value)[1]', 'varchar(max)') AS client_app_name,
  xed.event_data.value('(action[@name="server_instance_name"]/value)[1]', 'varchar(max)') AS server_instance_name
FROM #capture_waits_data
  CROSS APPLY targetdata.nodes('//RingBufferTarget/event') AS xed (event_data);
  
------------------------------------ ringBuffer2 ------------------------------------
WITH hadr(record) AS  
(  
SELECT CAST(target_data as xml) AS targetdata
FROM sys.dm_xe_session_targets xet
JOIN sys.dm_xe_sessions xes
    ON xes.address = xet.event_session_address
WHERE xes.name = 'sql_control'
  AND xet.target_name = 'ring_buffer'
)  
SELECT   
   record.value('(./RingBufferTarget/event/@name)[1]', 'varchar(100)') AS name,  
  record.value('(./RingBufferTarget/event/@timestamp)[1]', 'datetime2') AS timestamp, 
  record.value('(./RingBufferTarget/event/data[@name="database_name"])[1]', 'varchar(100)') AS database_name, 
  record.value('(./RingBufferTarget/event/action[@name="sql_text"])[1]', 'varchar(max)') AS sql_text,
  record.value('(./RingBufferTarget/event/action[@name="username"])[1]', 'varchar(max)') AS username
FROM hadr  



------------------------------------ ringBuffer3 ------------------------------------
select 
  xed.event_data.value('(@timestamp)[1]', 'datetime2') AS [timestamp],
  xed.event_data.value('(@name)[1]', 'varchar(max)') AS eventname,
  xed.event_data.value('(data[@name="database_name"]/value)[1]', 'varchar(200)') AS database_name,
  xed.event_data.value('(action[@name="username"]/value)[1]', 'varchar(max)') AS username,
  xed.event_data.value('(action[@name="sql_text"]/value)[1]', 'varchar(max)') AS sql_text,
  xed.event_data.value('(action[@name="session_nt_username"]/value)[1]', 'varchar(max)') AS session_nt_username,
  xed.event_data.value('(action[@name="client_app_name"]/value)[1]', 'varchar(max)') AS client_app_name,
  xed.event_data.value('(action[@name="server_instance_name"]/value)[1]', 'varchar(max)') AS server_instance_name

from (
	SELECT 
		CAST(target_data as xml) AS targetdata
	FROM sys.dm_xe_session_targets xet
	JOIN sys.dm_xe_sessions xes
	ON xes.address = xet.event_session_address
	WHERE xes.name = 'sql_control' AND xet.target_name = 'ring_buffer'
  ) x 
CROSS APPLY targetdata.nodes('//RingBufferTarget/event') AS xed (event_data)




--------------------------------------------------------------------------------------------------------------
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

----------------------------------
------------ Always On
----------------------------------
1) Windows on install for DC, Node1, Node2 using VmWare Workstation
2) Install "Active Directory Domain Services" for DC
    Create new forest 
    change Computer Name to DC
    to ping from DC to Node1,Node2
    close the firewall for Node1 and Node2. connection between
3) install Failover Cluster for Node1, Node2



---------------------------------------------- View Image Data from Sql ----------------------------------------------
create proc getPhoto as 
--ERROR     SQL Server blocked access to procedure 'sys.sp_OACreate' of component 'Ole Automation Procedures'

--EXEC sp_configure 'Ole Automation Procedures';
--GO
--sp_configure 'show advanced options', 1;
--GO
--RECONFIGURE;
--GO
--sp_configure 'Ole Automation Procedures', 1;
--GO
--RECONFIGURE;
--GO

DECLARE @ImageData VARBINARY (max);
DECLARE @Path2OutFile NVARCHAR (2000);
DECLARE @Obj INT
declare @ImageFolderPath NVARCHAR(1000)

set   @ImageFolderPath = 'C:\xy'  --degistir
	
SELECT @ImageData = (
	   SELECT top 1 convert (VARBINARY (max), face_crop, 1)
	   FROM  [YUZTANIMA].[dbo].[face_crop]                           
	   where id = 3                                                   
	   );

if @ImageData is not null
begin 
	 SET @Path2OutFile = CONCAT (
		   @ImageFolderPath
		   ,'\'
		   , 'foto.jpg'
		   );
	  BEGIN TRY
	   EXEC sp_OACreate 'ADODB.Stream' ,@Obj OUTPUT;
	   EXEC sp_OASetProperty @Obj ,'Type',1;
	   EXEC sp_OAMethod @Obj,'Open';
	   EXEC sp_OAMethod @Obj,'Write', NULL, @ImageData;
	   EXEC sp_OAMethod @Obj,'SaveToFile', NULL, @Path2OutFile, 2;
	   EXEC sp_OAMethod @Obj,'Close';
	   EXEC sp_OADestroy @Obj;
	  END TRY

   BEGIN CATCH
	EXEC sp_OADestroy @Obj;
   END CATCH
end






