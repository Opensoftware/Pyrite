# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def error_msgs_for(obj)
    if obj.errors.any?
      s = ''
      obj.errors.full_messages.each do |msg|
        s << render(:partial => "common/flash_form_error_template", :locals => { :msg => msg})
      end
      s.html_safe
    end
  end

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
