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
