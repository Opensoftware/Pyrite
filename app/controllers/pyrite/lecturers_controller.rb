module Pyrite
  class LecturersController < PyriteController
    include BlocksHelper

    skip_authorization_check :only => [:timetable]

    def timetable
      @lecturer = Lecturer.where(:id => params[:id]).first
      @events = convert_blocks_to_events_for_viewing(@lecturer.blocks.for_event(AcademicYear::Event.for_viewing))
    end

    private

      def form_params
        params.required(:lecturer).permit(:full_name, :title)
      end
  end
end
