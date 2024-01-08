USE master
GO
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @objname SYSNAME ='db.schema.table_name'
DECLARE @objid INT = OBJECT_ID(@objname)
DECLARE @dbid SMALLINT=DB_ID(PARSENAME(@objname,3))
DECLARE @handles TABLE (handle VARBINARY(64));INSERT INTO @handles SELECT sql_handle FROM sys.dm_exec_procedure_stats WHERE database_id=@dbid AND object_id = @objid UNION ALL SELECT sql_handle FROM sys.dm_exec_trigger_stats WHERE database_id=@dbid AND object_id = @objid UNION ALL SELECT sql_handle FROM sys.dm_exec_function_stats WHERE database_id=@dbid AND object_id = @objid;

SELECT 
SUBSTRING(est.text, eqs.statement_start_offset/2+1, (eqs.statement_end_offset-eqs.statement_start_offset)/2+1)
, LineNumber = LEN(SUBSTRING(est.text,1, eqs.statement_start_offset/2+1))-LEN(REPLACE(SUBSTRING(est.text,1, eqs.statement_start_offset/2+1),CHAR(10),''))+1
,[Execution Per Minute] = CAST(execution_count*60000. / (1+DATEDIFF_BIG(MILLISECOND,eqs.creation_time,eqs.last_execution_time)) AS DECIMAL(28,4))
,[Last Time] = eqs.last_execution_time
,[Execution Count] = execution_count
,[Total Cpu(ms)] = total_worker_time/1000
,[Total I/O] = total_logical_reads+total_physical_reads+total_logical_writes
,[Total Duration(ms)] = total_elapsed_time/1000
,[Cpu %] = CONVERT(DECIMAL(9,4),total_worker_time*100.0/SUM(total_worker_time) OVER())
,[I/O %] = CONVERT(DECIMAL(9,4),(total_logical_reads+total_physical_reads+total_logical_writes)*100.0/SUM(total_logical_reads+total_physical_reads+total_logical_writes) OVER())
--,[Duration %] = total_elapsed_time*100.0/SUM(total_elapsed_time) OVER()
,[Avg Cpu(ms)] = total_worker_time/1000/execution_count
,[Avg I/O] = (total_logical_reads+total_physical_reads+total_logical_writes)/execution_count
,[Avg Duration(ms)] = total_elapsed_time/1000/execution_count
,[Avg Rows] = CONVERT(DECIMAL(29,2),eqs.total_rows*1.0/eqs.execution_count)
,[Avg DOP] = eqs.total_dop/eqs.execution_count
,[Total Rows]=eqs.total_rows
,[Max I/O] = (max_logical_reads+max_physical_reads+max_logical_writes)
,[Last I/O] = (last_logical_reads+last_physical_reads+last_logical_writes)
,[Max Cpu] = (max_worker_time)/1000
,[Max Duration] = (max_elapsed_time)/100
,[Parallelism Ratio] = CAST(total_dop*1.0/execution_count AS DECIMAL(28,2))
,[Avg Grant KB] = total_grant_kb/execution_count
,[Last Run]=eqs.last_execution_time
,[First Run]=eqs.creation_time
,[Query Plan]=TRY_CONVERT(XML,eqp2.query_plan)
FROM sys.dm_exec_query_stats AS eqs
	OUTER APPLY sys.dm_exec_sql_text(eqs.sql_handle) AS est
	--OUTER APPLY sys.dm_exec_query_plan(eqs.plan_handle) AS eqp
	OUTER APPLY sys.dm_exec_text_query_plan(eqs.plan_handle,eqs.statement_start_offset,eqs.statement_end_offset) AS eqp2
WHERE sql_handle IN (SELECT handle FROM @handles) --AND execution_count>2
--ORDER BY LineNumber
ORDER BY [I/O %] DESC
OPTION (RECOMPILE)
--ORDER By [Avg Cpu(ms)] DESC, [Avg I/O] DESC
