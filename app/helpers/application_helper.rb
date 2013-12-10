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

  def days_for_select
    # Day of the week in 0-6. Sunday is 0; Saturday is 6.
    # Monday should be always first! Monday = 1
    (I18n.t "date.abbr_day_names").zip((1..6).to_a + [0])
  end
end
