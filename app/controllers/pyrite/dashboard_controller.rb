module Pyrite
  class DashboardController < PyriteController
    include BlocksHelper
    helper "pyrite/main"

    def index
      authorize! :read, :dashboard
      timetable_forms_data
    end

    def prints
      authorize! :read, :dashboard
      print_forms_data
    end

    def prints_part_time
      authorize! :read, :dashboard
      events = AcademicYear::Meeting.for_viewing
      unless events.count > 0
        flash[:notice] = t("pyrite.notice.missing_academic_year_meeting",
          :url => view_context.link_to(t("link_in_flash_academic_year_edit"),
          main_app.edit_academic_year_path(AcademicYear.for_viewing))).html_safe
        redirect_to dashboard_index_path
      else
        @events_with_url_for_groups = events.collect {|event|
          [event.name, print_part_time_all_groups_timetable_path(event.id)]
        }
        @events_with_url_for_groups.insert(0,
          [t("pyrite.label.all"), print_part_time_all_groups_timetable_path("all")])
      end
    end
  end
end
