-- (Error converting data type nvarchar to decimal.) 
-- not: Rakam haricinde bir değer olmadığından eminseniz o zaman sorun virgül ile alakalı olabilir
cast( replace(column,',','.') as decimal )

-- Update tabloyu select query kullanarak
update table1 
set = ( select column from table2 
        where table1.id = table2.id )
