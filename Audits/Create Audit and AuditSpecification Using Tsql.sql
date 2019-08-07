USE [master]
GO

CREATE SERVER AUDIT [Auditim]
TO FILE
(              FILEPATH = N'D:\'
                ,MAXSIZE = 1 GB
                ,MAX_ROLLOVER_FILES = 2147483647
                ,RESERVE_DISK_SPACE = OFF
)

WITH
(              QUEUE_DELAY = 1000
                ,ON_FAILURE = CONTINUE
)
GO

/*********************************************************/
ALTER SERVER AUDIT [Auditim] WITH (STATE = ON)
GO
/*********************************************************/
CREATE SERVER AUDIT SPECIFICATION [ServerAuditSpecification]
FOR SERVER AUDIT [Auditim]
ADD (AUDIT_CHANGE_GROUP),                     --Audit oluşturma, değiştirme ve silmeyi yakalar.
ADD (DATABASE_CHANGE_GROUP),                   --Veritabanı oluşturma, değiştirme ve silmeyi yakalar.
ADD (DATABASE_OBJECT_CHANGE_GROUP),            --Veritabanı nesne, şema oluşturma, değiştirme ve silmeyi yakalar.
ADD (DATABASE_OBJECT_OWNERSHIP_CHANGE_GROUP),   --Şema, rol, veritabanı nesneleri sahip değişikliklerini yakalar.
ADD (DATABASE_OBJECT_PERMISSION_CHANGE_GROUP),  --Veritabanı nesneleri, şema, rol üzerinde grant, deny, revoke işlemlerini yakalar.
ADD (DATABASE_PERMISSION_CHANGE_GROUP),         --Veritabanı üzerinde grant, deny, revoke işlemlerini yakalar.
ADD (DATABASE_PRINCIPAL_CHANGE_GROUP),          --Veritabanı kullanıcısı oluşturma, değiştirme ve silmeyi yakalar.
ADD (DATABASE_ROLE_MEMBER_CHANGE_GROUP),         --Veritabanı rollerine kullanıcı eklemeyi ve silmeyi yakalar.
ADD (DBCC_GROUP),                                 --DBCC kodlarını yakalar.
ADD (FAILED_LOGIN_GROUP),                         --Sunucu hatalı bağlanma denemelerini yakalar.
ADD (FULLTEXT_GROUP),                           --Full-text işlemlerini yakalar.
ADD (LOGIN_CHANGE_PASSWORD_GROUP),              --Sunucu bazlı kullanıcı şifre değiştirme ve sıfırlama işlemlerini yakalar.
ADD (SCHEMA_OBJECT_CHANGE_GROUP),               --Tablo, view, SP oluşturma, değiştirme ve silmeyi yakalar.
ADD (SCHEMA_OBJECT_OWNERSHIP_CHANGE_GROUP),      --Tablo, view, SP sahip değişikliklerini yakalar.
ADD (SCHEMA_OBJECT_PERMISSION_CHANGE_GROUP),      --Tablo, view, SP üzerinde grant, deny, revoke işlemlerini yakalar.
ADD (SERVER_ROLE_MEMBER_CHANGE_GROUP),            --Sunucu rollerine kullanıcı eklemeyi ve silmeyi yakalar.
ADD (SERVER_STATE_CHANGE_GROUP),                  --Sql servis start,pause,stop ve resume yakalar.
ADD (SERVER_PRINCIPAL_CHANGE_GROUP)               --Kullanıcı oluşturma, değiştirme ve silmeyi yakalar.
--ADD (SCHEMA_OBJECT_ACCESS_GROUP)                --TÜM VERİTABANLARININ SELECT, UPDATE, INSERT, DELETE VE EXECUTE İŞLEMLERİNİ YAKALAR.
--ADD (FAILED_DATABASE_AUTHENTICATION_GROUP),       --Veritabanı hatalı bağlanma denemelerini yakalar.
--ADD (SERVER_OBJECT_CHANGE_GROUP),--Master key, server credentials oluşturma, değiştirme ve silmeyi yakalar.
--ADD (SERVER_OBJECT_PERMISSION_CHANGE_GROUP),--Master key, server credentials üzerinde grant, deny, revoke işlemlerini yakalar.
--ADD (SERVER_OPERATION_GROUP),--Sunucu ayarlarını, kaynak yönetimini değiştirmeyi yakalar.
--ADD (SERVER_PERMISSION_CHANGE_GROUP),--Instance üzerinde izin değişikliklerini yakalar.
--ADD (SERVER_PRINCIPAL_CHANGE_GROUP),--Sunucu ilkesi oluşturma, değiştirme ve silmeyi yakalar.
--ADD (USER_CHANGE_PASSWORD_GROUP)--Veritabanı bazlı kullanıcı şifre değiştirme ve sıfırlama işlemlerini yakalar.

WITH ( STATE = ON)
GO
