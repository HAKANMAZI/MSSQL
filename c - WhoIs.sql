	USE master
GO
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
DROP TABLE IF EXISTS #tmp; -- kill 288
-- SELECT TOP(10) * FROM msdb.dbo.backupset WITH (NOLOCK) WHERE database_name='BOADWH' AND compressed_backup_size>1520135813120 ORDER BY backup_set_id DESC
-- SELECT database_name,CONVERT(INT,MAX(compressed_backup_size)/1024/1024/1024) AS size_gb FROM msdb.dbo.backupset WITH (NOLOCK) WHERE backup_start_date>'2020-12-15' GROUP BY database_name ORDER BY 2 DESC
--SELECT 1354396/3600LNC.ins_Collateral select blocking_session_id,session_id from sys.dm_exec_requests where blocking_session_id>0
-- SELECT COUNT(1) FROM sys.dm_exec_sessions
SELECT -- DBCC INPUTBUFFER(983) -- SELECT 30638/3600 7 499 993 3961 643 480 675
	--er.context_info, select OBJECT_SCHEMA_NAME(object_id)+'.'+OBJECT_NAME(object_id), index_id from sys.partitions where hobt_id =7205760134964838472058445589250048KEY: 5:72057601349648384 (31514a09ae29) (276ms)
	SPID                = er.session_id --mAXspId = MAX(er.session_id) OVER()LNS.LNS.sel_ProjectForeignPaymentReturnByCriteria
	--,'Kill '+LTRIM(er.session_id)
	,BlkBy              = er.blocking_session_id
	--,Lead = CASE WHEN lead_blocker = 1 THEN -1 ELSE er.blocking_session_id END Kill 73
	,Duration           = er.total_elapsed_time
	,CPU                = er.cpu_time
	,Reads              = er.logical_reads + er.reads
	,er.granted_query_memory AS GQM
	,Writes             = er.writes     --COR.LedgerBalance12 299 427 522
	,Rows			 = er.row_count
	,Execs         = ec.execution_count  
	,Command        = er.command    
	,[Percent]    = er.percent_complete     
	,LastWait       = er.last_wait_type   
	,WaitInfo			 = er.wait_resource+' ('+LTRIM(er.wait_time)+'ms)'
	,ObjectName         = OBJECT_SCHEMA_NAME(qt.objectid,qt.dbid) + '.' + OBJECT_NAME(qt.objectid, qt.dbid)  
	,[T-SQL]			= SUBSTRING(qt.text, er.statement_start_offset/2+1, (CASE WHEN er.statement_end_offset = -1 THEN LEN(qt.text) * 2 ELSE er.statement_end_offset END - er.statement_start_offset)/2+1)   
	,STATUS             = ses.STATUS
	-- ,WorkloadGroup		 = wg.name
	,[Login]            = ses.login_name
	,Host               = ses.host_name
	,DBName             = DB_Name(er.database_id)
	,AppName			 = ses.program_name
	,StartTime          = er.start_time
	,Protocol           = con.net_transport
	,Isolation = CASE ses.transaction_isolation_level WHEN 0 THEN 'Unspecified' WHEN 1 THEN 'Read Uncommitted' WHEN 2 THEN 'Read Committed' WHEN 3 THEN 'Repeatable' WHEN 4 THEN 'Serializable' WHEN 5 THEN 'Snapshot' END
	,ConnWrites   = con.num_writes
	,ConnReads    = con.num_reads
	,ConnClient      = con.client_net_address
	,ConnAuth     = con.auth_scheme
	,DatetimeSnapshot   = GETDATE()
	,RecompileSp = 'EXEC dba.sp_recompilex '''+OBJECT_SCHEMA_NAME(qt.objectid,qt.dbid) + '.' + OBJECT_NAME(qt.objectid, qt.dbid)+''''
	,FreePlanCash = 'DBCC FREEPROCCACHE ('+rtrim(convert(varchar(max),er.plan_handle,1))+')'
	,inp.event_info,er.open_transaction_count AS TranCount
	,TRY_CONVERT(XML,qp.query_plan) AS query_plan
INTO #tmp
FROM sys.dm_exec_requests er  --select * from sys.all_objects where name like '%workload%'kill 3162kill 380 sp_recompile 'COR.ins_Journal'
--LEFT JOIN sys.dm_resource_governor_workload_groups AS wg ON (wg.group_id=er.group_id)
LEFT JOIN sys.dm_exec_sessions ses ON ses.session_id = er.session_id
LEFT JOIN sys.dm_exec_connections con ON con.session_id = ses.session_id
OUTER APPLY sys.dm_exec_input_buffer(er.session_id,er.request_id) AS inp
OUTER APPLY sys.dm_exec_sql_text(er.sql_handle) AS qt  --BOAWEB..sp_recompile 'FAL.sel_AllotmentAssuranceCheckCollectionLastYearDetail'
OUTER APPLY  -- SELECT 964072*8/1024 dbcc inputbuffer (4629)
(
     SELECT execution_count = MAX(cp.execution_count)
     FROM sys.dm_exec_query_stats cp
     WHERE cp.plan_handle = er.plan_handle
) ec
--EXEC sys.sp_configure N'min memory per query (KB)', N'4096'
--RECONFIGURE WITH OVERRIDE sp_recompile 'COR.sel_AccountComponentSearch1_2'
--

--select * FROM sys.dm_exec_cached_plans AS p WHERE NOT EXISTS (SELECT 1 FROM sys.dm_exec_query_stats AS s WHERE s.plan_handle=p.plan_handle) 
--SELECT * FROM sys.dm_exec_sql_text(0x05000500D08AF61000AF32C0B002000001000000000000000000000000000000000000000000000000000000)
-- sp_recompile 'CLT.sel_CollateralForProjectRelation'kill 107
OUTER APPLY
(
--SET STATISTICS IO ON kill 755
     SELECT TOP(1)
         lead_blocker = 1
     FROM master.dbo.sysprocesses sp
		left join master.dbo.sysprocesses sp2 on sp2.blocked = sp.spid
	where sp2.spid>0 and sp.blocked=0
	--WHERE sp.spid IN (SELECT DISTINCT sp2.blocked FROM master.dbo.sysprocesses AS sp2)
   --AND sp.blocked = 0
--     --AND sp.spid = er.session_id kill 598 kill 65
) lb

outer apply sys.dm_exec_text_query_plan(er.plan_handle,er.statement_start_offset,er.statement_end_offset) AS qp
WHERE 
(er.sql_handle IS NOT NULL
AND er.session_id != @@SPID
and last_wait_type not in ('WAITFOR','BROKER_RECEIVE_WAITFOR')
) or er.session_id IN (SELECT session_id FROM sys.dm_exec_sessions  
WHERE open_transaction_count>0 AND DATEADD(MINUTE,-1,GETDATE())>last_request_start_time)
--er.session_id IN (SELECT st.session_id FROM 
--sys.dm_tran_session_transactions as stCOR.sel_vMessagingByCode
--INNER JOIN sys.dm_tran_database_transactions as dt ON (dt.transaction_id=st.transaction_id)
--WHERE dt.database_transaction_begin_time < DATEADD(MINUTE,-1,GETDATE())) -- sp_recompile 'COR.sel_InstallmentListCommissionByBranchId'
--and OBJECT_NAME(objectid,dbid) LIKE 'ins_Pro%'
-- SELECT * FROM BOA.sys.partitions WHERE hobt_id=72057601349648384 and database_id=5KEY: 5:72057601349648384 (c9bc88d5fd9c) (14819ms)
-- SELECT OBJECT_SCHEMA_NAME(786817865,5)+'.'+OBJECT_NAME(786817865,5)
--SELECT * FROM BOA.COR.Account (NOLOCK) WHERE %%lockres%% = '(c9bc88d5fd9c)'
--SELECT * FROM BOA.sys.dm_db_incremental_stats_properties (786817865, 1)  
--SELECT * FROM BOA.sys.dm_db_stats_properties (786817865, 1) --1,28,30,31
--SELECT * FROM BOA.sys.stats WHERE object_id=786817865
--SELECT * FROM BOA.sys.columns WHERE object_id=786817865
--SELECT * FROM BOA.sys.stats_columns WHERE object_id=786817865 AND column_id=2
--ORDER BY Duration desc
OPTION (RECOMPILE)
SELECT * FROM #tmp 
ORDER BY Duration DESC --BlkBy DESC,TranCount DESC, Duration DESC
GO


--EXEC sp_recompile 'CUS.fIsEmployee'
--EML.sel_QueueByColumns kill 207

--SELECT session_id FROM sys.dm_exec_sessions  
--WHERE open_transaction_count>0 AND DATEADD(MINUTE,-1,GETDATE())>last_request_start_time
--ORDER BY last_request_start_time ASC

SELECT b.event_info,b.event_type, 
CASE WHEN r.session_id IS NULL THEN 'Request Not Found' ELSE 'Request Found' END AS request,
SUBSTRING(t.text, r.statement_start_offset/2+1, (CASE WHEN r.statement_end_offset = -1 THEN LEN(t.text) * 2 ELSE r.statement_end_offset END - r.statement_start_offset)/2+1) as tsql,
s.* FROM sys.dm_exec_sessions as s
LEFT JOIN sys.dm_exec_requests AS r ON (r.session_id=s.session_id)
OUTER APPLY sys.dm_exec_input_buffer(s.session_id, DEFAULT) AS b
OUTER APPLY sys.dm_exec_sql_text(r.sql_handle) AS t
WHERE s.session_id IN (SELECT DISTINCT blkby FROM #tmp)


