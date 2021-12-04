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

--SYSTEM
-------------------------------
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
