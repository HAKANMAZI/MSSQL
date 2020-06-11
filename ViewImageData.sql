create proc getPhoto as 
--ERROR     SQL Server blocked access to procedure 'sys.sp_OACreate' of component 'Ole Automation Procedures'

--EXEC sp_configure 'Ole Automation Procedures';
--GO
--sp_configure 'show advanced options', 1;
--GO
--RECONFIGURE;
--GO
--sp_configure 'Ole Automation Procedures', 1;
--GO
--RECONFIGURE;
--GO

DECLARE @ImageData VARBINARY (max);
DECLARE @Path2OutFile NVARCHAR (2000);
DECLARE @Obj INT
declare @ImageFolderPath NVARCHAR(1000)

set   @ImageFolderPath = 'C:\xy'  --degistir
	
SELECT @ImageData = (
	   SELECT top 1 convert (VARBINARY (max), face_crop, 1)
	   FROM  [YUZTANIMA].[dbo].[face_crop]                           
	   where id = 3                                                   
	   );

if @ImageData is not null
begin 
	 SET @Path2OutFile = CONCAT (
		   @ImageFolderPath
		   ,'\'
		   , 'foto.jpg'
		   );
	  BEGIN TRY
	   EXEC sp_OACreate 'ADODB.Stream' ,@Obj OUTPUT;
	   EXEC sp_OASetProperty @Obj ,'Type',1;
	   EXEC sp_OAMethod @Obj,'Open';
	   EXEC sp_OAMethod @Obj,'Write', NULL, @ImageData;
	   EXEC sp_OAMethod @Obj,'SaveToFile', NULL, @Path2OutFile, 2;
	   EXEC sp_OAMethod @Obj,'Close';
	   EXEC sp_OADestroy @Obj;
	  END TRY

   BEGIN CATCH
	EXEC sp_OADestroy @Obj;
   END CATCH
end



