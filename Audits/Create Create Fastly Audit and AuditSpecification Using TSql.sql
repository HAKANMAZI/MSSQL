create table #specific(
    id int identity(1,1),
	ad nvarchar(250)
)

insert into #specific
Select distinct containing_group_name from sys.dm_audit_actions where containing_group_name is not null and containing_group_name not like 'BATCH%'

declare @name nvarchar(250),@sql nvarchar(2500)
declare @count int, @toplam int
set @toplam = (select count(1) from #specific)
set @count = 1

	CREATE SERVER AUDIT hakan TO FILE 
	(      FILEPATH = N'C:\audits\'
		  ,MAXSIZE = 10 MB
	)
	WITH 
	(      QUEUE_DELAY = 1000
		  ,ON_FAILURE = CONTINUE
	)
	create SERVER AUDIT SPECIFICATION hakan_Specification  
	FOR SERVER AUDIT hakan  
		ADD (BACKUP_RESTORE_GROUP);  
	


while @count < @toplam
begin 
	set @name = (select ad from #specific where id=@count)
	--select @name
	set @sql ='alter SERVER AUDIT SPECIFICATION hakan_Specification  FOR SERVER AUDIT hakan  
    ADD ('+@name+')'
	select @sql
	exec (@sql)
	
	set @count= @count + 1
end

ALTER SERVER AUDIT hakan  
WITH (STATE = ON);  
GO 

drop table #specific
