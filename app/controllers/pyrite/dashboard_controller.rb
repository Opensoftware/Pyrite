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
    end
  end
end
