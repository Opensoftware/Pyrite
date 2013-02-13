# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
 	def GetHour(gz)
    @Gz = (gz.to_i / 60)
    @Mz = gz.to_i - @Gz.minutes 
    if (@Mz == 0 ) 
      @GMz = "#{@Gz}:#{@Mz}0" 
    else 
      @GMz = "#{@Gz}:#{@Mz}" 
    end
		@GMz
	end
end
