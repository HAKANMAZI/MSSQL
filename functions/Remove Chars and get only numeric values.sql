declare @phone nvarchar(100)
set @phone = '905414,.9p/6'

declare @count int, @total int, @combine nvarchar(2500), @newValue nvarchar(2500)
set @combine = ''
set @count = 1
set @total = len(@phone)

while @count <= @total
begin
	set @newValue = SUBSTRING(@phone,@count,1)
	--if ISNUMERIC(@newValue) = 1   /* this function doesnt clean ., characters */
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
