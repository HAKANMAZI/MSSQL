  DELETE [database].[schema].[tablename]                              DİKKAT ET  identity key delete
  DBCC CHECKIDENT ('[database].[schema].[tablename]', RESEED, 0);
  GO
