-- (Error converting data type nvarchar to decimal.) 
-- not: Rakam haricinde bir değer olmadığından eminseniz o zaman sorun virgül ile alakalı olabilir
cast( replace(column,',','.') as decimal )


