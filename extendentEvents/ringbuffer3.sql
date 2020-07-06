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
