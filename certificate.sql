-- master key create
use master;
go
create master key encryption by password = 'password1'
go


-- create certificate 
use master 
go 
create certificate GenelCertifica
with subject = 'genel certificate',
expiry_date = '20500101'
go


--get certificate backup
use master
go 
backup certificate GenelCertifica to file = 'D:\cert\Crypto.cer' --real certificate
with private key ( File = 'D:\cert\Crypto.pvk', encryption by password = 'password1' ) --key
go

