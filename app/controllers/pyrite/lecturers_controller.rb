module Pyrite
  class LecturersController < PyriteController
    include BlocksHelper
    include PyriteHelper

    skip_authorization_check :only => [:timetable]

    def timetable
      @lecturer = Lecturer.where(:id => params[:id]).first
      @events = convert_blocks_to_events_for_viewing(@lecturer.blocks.for_event(AcademicYear::Event.for_viewing))
    end

    def print_all
      authorize! :print, :timetables
      lecturers = Lecturer.all
      event_name = AcademicYear::Event.where(:id => params[:event_id]).first.try(:full_name)

      lecturers_timetable = Pdf::LecturerTimetable.new(lecturers, params[:event_id], swap_monday(available_days))
      data = lecturers_timetable.to_pdf

      send_data(data, :filename => t("pyrite.filename.lecturers_timetable", :event_name => event_name),
               :type => "application/pdf", :disposition => "inline")
    end

    def print
      authorize! :print, :timetables
      lecturer = Lecturer.where(:id => params[:id]).first
      event_id = AcademicYear::Event.for_viewing

      data = Rails.cache.fetch(cache_key_for_lecturer_timetable(lecturer, event_id)) do
        timetable = Pdf::LecturerTimetable.new([lecturer], event_id, swap_monday(available_days))
        data = timetable.to_pdf
        Rails.cache.write(cache_key_for_lecturer_timetable(lecturer, event_id), data)
        data
      end

      send_data(data, :filename => "#{lecturer.full_name}.pdf", :type => "application/pdf",
                :disposition => "inline")
    end


    private

      def form_params
        params.required(:lecturer).permit(:full_name, :title)
      end

      def cache_key_for_lecturer_timetable(lecturer, event_id)
        count = lecturer.blocks.count
        settings = Settings.maximum(:updated_at).try(:utc).try(:to_s, :number)
        max_block_updated_at = lecturer.blocks.maximum(:updated_at).try(:utc).try(:to_s, :number)
        "lecturer-timetable/#{event_id}-#{settings}-#{lecturer.id}-#{max_block_updated_at}-#{count}"
      end
  end
end
