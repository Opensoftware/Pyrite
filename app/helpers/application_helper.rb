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
    available_abbr_days.zip((1..6).to_a + [0])
  end

  def available_abbr_days
    # TODO this should be somehow configured by the user to be able to hide some
    # days which are not used.
    I18n.t("date.abbr_day_names")
  end

  def available_days
    # TODO this should be somehow configured by the user to be able to hide some
    # days which are not used.
    I18n.t "date.day_names"
  end

  def available_hours
    # TODO this should be somwhow configured by the user to be able to hide some
    # hourse which are not used.
    time_start = Time.parse("00:00")
    time_end = Time.parse("23:45")
    generate_time_steps(time_start, time_end).map { |t| t.strftime "%H:%M" }
  end

  # Fullcalendar - fc
  # list of days started from Sunday
  def fc_days
    days = available_abbr_days.dup
    days.insert(0, days.pop)
    days
  end
end
