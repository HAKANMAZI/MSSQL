USE master
GO
-- ALERT QUERY
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
DECLARE @searchcode SYSNAME = NULL
DECLARE @searchobject SYSNAME = NULL-- 'BOACard.RPT.rpt_DailyCardBalanceSummary'boa.COR.sel_MappedAccountForMoneyTransfer
DECLARE @dbid INT = DB_ID(PARSENAME(@searchobject,3))
DECLARE @schemaname SYSNAME = PARSENAME(@searchobject,2)
DECLARE @tablename SYSNAME = PARSENAME(@searchobject,1)

DECLARE @dblist TABLE (value int)
INSERT INTO @dblist SELECT database_id FROM sys.databases WHERE 1=1 and database_id>4 and name NOT IN ('Maintenance') AND name NOT LIKE '%Archive' -- name IN ('EWS','BOADWH','ickontrol','dbteftis','Budget') --VALUES (DB_ID('Budget')),(DB_ID('BOA')),(DB_ID('BOADWH'))
-- SELECT query_plan FROM sys.dm_exec_procedure_stats AS eqs OUTER APPLY sys.dm_exec_query_plan(eqs.plan_handle) AS eqp WHERE database_id=DB_ID() AND object_id IN (OBJECT_ID('[TRE].[tsk_GenerateTCMBFXReportingCanceledData]'))
--BOA.WFL.sel_WorkManagementPoolBOA.MOB.sel_ResourceListBOAWeb.INT.sel_OtpLoginByUser
; WITH RawData AS (
SELECT 
	Obj = DB_NAME(eqs.database_id)+'.'+OBJECT_SCHEMA_NAME(eqs.object_id,eqs.database_id)+'.'+OBJECT_NAME(eqs.object_id,eqs.database_id), 
	EPM = CAST(SUM(execution_count) / (DATEDIFF(SECOND,MIN(eqs.cached_time),MAX(eqs.last_execution_time))/60.0) AS DECIMAL(28,4)),
	EC = SUM(execution_count),
	CPU = SUM(total_worker_time)/1000,
	IO = SUM(total_logical_reads+total_physical_reads+total_logical_writes),
	Duration = SUM(total_elapsed_time)/1000,
	PlanCount = COUNT(DISTINCT plan_handle),
	avgCPU = SUM(total_worker_time)/SUM(execution_count)/1000,
	avgIO = SUM(total_logical_reads+total_physical_reads+total_logical_writes)/SUM(execution_count),
	avgDuration = SUM(total_elapsed_time)/SUM(execution_count)/1000,
	lastETime = MAX(last_execution_time),
	cacheTime = MAX(cached_time),
	--lastCPU =MAX(last_worker_time)/1000,	
	--lastIO = MAX(last_logical_reads),
	--lastDuration = MAX(last_elapsed_time)/1000,
	--maxCPU = MAX(max_worker_time)/1000,
	maxIO = MAX(max_logical_reads),
	maxDuration = MAX(max_elapsed_time)/1000
	--maxDuration = SUM(max_elapsed_time)/1000

	--delta = DATEDIFF(SECOND,MIN(eqs.cached_time),MAX(eqs.last_execution_time))
FROM 

(SELECT database_id,object_id,execution_count,cached_time,last_execution_time,total_worker_time,total_logical_reads,total_physical_reads,total_logical_writes ,total_elapsed_time
,last_logical_reads,last_physical_reads,last_logical_writes,last_elapsed_time,max_elapsed_time,last_worker_time,max_worker_time,max_logical_reads,plan_handle
FROM sys.dm_exec_procedure_stats
UNION ALL
SELECT database_id,object_id,execution_count,cached_time,last_execution_time,total_worker_time,total_logical_reads,total_physical_reads,total_logical_writes ,total_elapsed_time
,last_logical_reads,last_physical_reads,last_logical_writes,last_elapsed_time,max_elapsed_time,last_worker_time,max_worker_time,max_logical_reads,plan_handle
FROM sys.dm_exec_function_stats
UNION ALL
SELECT database_id,object_id,execution_count,cached_time,last_execution_time,total_worker_time,total_logical_reads,total_physical_reads,total_logical_writes ,total_elapsed_time
,last_logical_reads,last_physical_reads,last_logical_writes,last_elapsed_time,max_elapsed_time,last_worker_time,max_worker_time,max_logical_reads,plan_handle
FROM sys.dm_exec_trigger_stats) AS eqs
	--OUTER APPLY sys.dm_exec_sql_text(eqs.sql_handle) AS estKAS.sel_POSMonitor
	
WHERE execution_count>1 AND DATEDIFF(SECOND,eqs.cached_time,eqs.last_execution_time)>0 
--AND database_id=DB_ID('BOA')
--AND (@searchobject IS NULL OR object_id IN (SELECT referencing_id FROM sys.sql_expression_dependencies WHERE referenced_entity_name=@tablename AND referenced_schema_name=@schemaname))
--AND (@searchcode IS NULL OR object_id IN (SELECT DISTINCT object_id FROM sys.sql_modules WHERE definition LIKE '%'+@searchcode+'%'))
--AND eqs.last_execution_time>DATEADD(MINUTE,-120,GETDATE())
-- AND database_id>4 AND DB_NAME(database_id) != 'Maintenance'
--AND DB_NAME(database_id)='BOAAudit'
--AND database_id IN (SELECT value FROM @dblist)
--AND OBJECT_NAME(object_id,database_id) LIKE '%DivitMail%'
--AND OBJECT_SCHEMA_NAME(object_id,database_id) ='LNC'

--AND database_id=DB_ID('BOA') AND  object_id IN (SELECT object_id FROM BOA.sys.sql_expression_dependencies AS d INNER JOIN BOA.sys.objects AS o ON (o.object_id=d.referencing_id) WHERE d.referenced_database_name='ReutersDB')
--AND object_id IN (SELECT OBJECT_ID('BOA.'+kt.StoredProcedureName) FROM BOA.LNC.ConditionDefinition AS kt WITH (NOLOCK))
--AND object_id IN (SELECT object_id FROM Maintenance.sys.sql_modules WHERE definition LIKE '%#db_files%')
--INNER JOIN sys.objects AS o ON (d.referencing_id=o.object_id)
--AND object_id IN (SELECT object_id FROM  BOA.sys.sql_dependencies AS d2 WHERE referenced_major_id=OBJECT_ID('BOA.[ORD].[BidAskOrderCentral]'))
--INNER JOIN sys.objects AS o2 ON (o2.object_id=d2.object_id)
--WHERE d.referenced_server_name='ZUMRUT' AND o.type='V' UNION SELECT o.object_id
--FROM sys.sql_expression_dependencies AS d
--INNER JOIN sys.objects AS o ON (d.referencing_id=o.object_id)
--INNER JOIN sys.sql_dependencies AS d2 ON (d2.referenced_major_id=o.object_id)
--WHERE d.referenced_server_name='ZUMRUT' AND o.type !='V'
--)
--AND object_id IN (OBJECT_ID('BOA.WFL.sel_WorkManagementPool'),OBJECT_ID('BOA.WFL.sel_WorkManagementPoolAllCriterias'))
--,OBJECT_ID('[COR].[sel_AccountingByBranchId]')
--,OBJECT_ID('[COR].[sel_AccountingList]'))
--AND OBJECT_NAME(eqs.object_id,eqs.database_id) LIKE 'sel_Model%'
--'tsk_CreditCardRiskDetail',
--'tsk_ControlBatchCustomerForNonGroup',
--'tsk_ControlBatchForNonGroupCustomers',
--'tsk_ControlBatchForGroupCustomersNew',
--'tsk_ClearControlTempTablesAfterBatch',
--'tsk_ImportControlDataToBOAAnalytic',
--'tsk_CustomerExemptionClosing',
--'tsk_SectorBasedRisk'
--)INTERFACE.CRC.RTE_GET_LINE_USAGE_AMOUNT
--AND OBJECT_SCHEMA_NAME(object_id,database_id)='INV'
--AND object_id = OBJECT_ID('BCP.sel_ConfigurationItemList')
--AND EXISTS (select top(1) 1 from BOA.sys.procedures  AS p WHERE p.object_id=eqs.object_id AND p.create_date>'2020-07-01')
--AND eqs.object_id != OBJECT_ID('BOA.CUS.tsk_UpdateSectorCodeForCorporate') AND eqs.object_id != OBJECT_ID('BOA.CUS.tsk_UpdateSectorCodeForIndividual')
GROUP BY eqs.object_id,eqs.database_id --BOA.COR.sel_ParameterGeneral
)

SELECT TOP(50) * FROM (
SELECT *,
	[% CPU] = 100.*CPU/SUM(CPU) OVER() ,
	[% IO] = 100.*IO/SUM(IO) OVER(),
	[% Duration] = 100.*Duration/SUM(Duration) OVER() ,
	[% Execution] = 100.*EC/SUM(EC) OVER(),
	[Top Order (IO)] = ROW_NUMBER() OVER(ORDER BY IO DESC),
	[Top Order (CPU)] = ROW_NUMBER() OVER(ORDER BY CPU DESC),
	[Top Order (Duration)] = ROW_NUMBER() OVER(ORDER BY Duration DESC)
FROM RawData 
) AS x
ORDER BY [Top Order (CPU)] -- DESC -- [Top Order (IO)] -- DESC
OPTION (RECOMPILE)

GO

