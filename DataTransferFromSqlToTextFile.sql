--Data Transfer From Sql Server To Text File...

declare @output nvarchar(1000), @filepath nvarchar(1000), @bcp nvarchar(1000)
set @bcp = 'bcp "select * from sys.traces" queryout '
set @filepath = 'C:\x\'
set @output = 'text.txt'
set @bcp = @bcp + @filepath + @output + ' -c -t, -T -S'+ @@SERVERNAME
EXEC master..xp_cmdshell @bcp
