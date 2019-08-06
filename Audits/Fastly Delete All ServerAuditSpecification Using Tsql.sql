declare @dropaudit nvarchar(max)
declare my_cursor cursor for select name from sys.server_audit_specifications
open my_cursor
fetch next from my_cursor into @dropaudit

while @@FETCH_STATUS  = 0
begin 

declare @sql2 nvarchar(max)
set @sql2='ALTER SERVER AUDIT SPESIFICATION ['+@dropaudit+ '] WITH(STATE = OFF)'
select @sql2
exec (@sql2)
	exec(' ALTER SERVER AUDIT SPESIFICATION  ['+@dropaudit+'] WITH(STATE = OFF)')
	exec(' DROP SERVER AUDIT  SPESIFICATION ['+@dropaudit+']')
	fetch next from my_cursor into @dropaudit
end
close my_cursor
deallocate my_cursor
