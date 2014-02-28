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

  # Fullcalendar - fc
  # list of days started from Sunday
  def fc_days
    days = available_abbr_days.dup
    days.insert(0, days.pop)
    days
  end
end
