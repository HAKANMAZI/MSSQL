--Delete Trigger
--SQL SERVER – Fix : Error : 17892 Logon failed for login due to trigger execution. Changed database context to ‘master’.
FirstWay
  USE master
  GO
  DROP TRIGGER [TriggerName] ON ALL SERVER
  GO
SecondWay
  C:\Users\Pinal>sqlcmd -S LocalHost -d master -A
  1> DROP TRIGGER Tr_ServerLogon ON ALL SERVER
  2> GO
