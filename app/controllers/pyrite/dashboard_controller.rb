module Pyrite
  class DashboardController < PyriteController
    include BlocksHelper

    def index
      authorize! :read, :dashboard
      timetable_forms_data
    end

    def prints
      print_forms_data
    end

    def prints_part_time

    end
  end
end
