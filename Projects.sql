
------------------------------------------------------------ Search Word In All Columns For Table ------------------------------------------------------------
--Select * from TableName where * like '%searchingData%'
--Search "ai" word in all columns for Customers table
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--create procedure
CREATE PROCEDURE hak_SearchForAllColumns  @tablename nvarchar(250), @searching nvarchar(250) 
AS
BEGIN
	SET NOCOUNT ON;

		  declare @count int,@toplam int,  @columname nvarchar(250),@sql nvarchar(2500)

		  create table #columns(
			id int identity(1,1),
			name nvarchar(250)
		  )
		  create table #final 
			(
				[CustomerID] [nchar](5) NOT NULL,
				[CompanyName] [nvarchar](40) NOT NULL,
				[ContactName] [nvarchar](30) NULL,
				[ContactTitle] [nvarchar](30) NULL,
				[Address] [nvarchar](60) NULL,
				[City] [nvarchar](15) NULL,
				[Region] [nvarchar](15) NULL,
				[PostalCode] [nvarchar](10) NULL,
				[Country] [nvarchar](15) NULL,
				[Phone] [nvarchar](24) NULL,
				[Fax] [nvarchar](24) NULL
			)

		  insert into #columns
		  select COLUMN_NAME from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = @tablename

 
		  set @count = 1
		  set @toplam =(select count(1) from #columns)

		  while @count <=@toplam
		  begin
				set @columname = (select name from #columns where id=@count)
				set @sql = 'select * from '+@tablename +' where '+@columname+' like ''%'+@searching+'%'''
				insert into #final
				exec (@sql)

				set @count= @count +1
		  end

		  select * from  #final
		  drop table  #columns
		  drop table  #final
END
GO



--call procedure
exec [dbo].[hak_SearchForAllColumns] 'Customers', 'ai'
