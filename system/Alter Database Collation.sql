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
