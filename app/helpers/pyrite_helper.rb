module PyriteHelper
  def error_msgs_for(obj)
    if obj.errors.any?
      s = ''
      obj.errors.full_messages.each do |msg|
        s << render(:partial => "common/flash_form_error_template", :locals => { :msg => msg})
      end
      s.html_safe
    end
  end

  def available_abbr_days
    # Day of the week in 0-6. Sunday is 0; Saturday is 6.
    user_preferences_for_days(I18n.t("date.abbr_day_names"))
  end

  def available_days
    # Day of the week in 0-6. Sunday is 0; Saturday is 6.
    user_preferences_for_days(I18n.t("date.day_names"))
  end

  def available_abbr_days_for_select
    user_preferences_for_days(I18n.t("date.abbr_day_names").zip(0..7))
  end

  def available_days_for_select
    user_preferences_for_days(I18n.t("date.day_names").zip(0..7))
  end

  # return array with days which are configured by users
  # right now we have only with/without weekends
  # days_array always need to be Sunday = 0, 0..6
  def user_preferences_for_days(days_array)
    if current_user && current_user.preferences[:without_weekends]
      # remove Sunday = 0 and Saturday = 6
      days_array.slice(1..-2)
    else
      days_array
    end
  end

  # Helper method to swap sunday with monday in array
  def swap_monday(array)
    if current_user && current_user.preferences[:without_weekends]
      return array
    else
      return array[1..-1] << array[0]
    end
  end

  # Fullcalendar - fc
  # list of abbr days started from Sunday
  def fc_days
    I18n.t("date.abbr_day_names")
  end
end
