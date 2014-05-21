module Pyrite
  class LecturersController < PyriteController
    include BlocksHelper

    skip_authorization_check :only => [:timetable]

    def index
      @lecturers = Lecturer.all
    end

    def new
      @lecturer = Lecturer.new
    end

    def edit
      @lecturer = Lecturer.find(params[:id])
    end

    def create
      @lecturer = Lecturer.new(form_params)

      if @lecturer.save
        flash[:notice] = t("notice_lecturer_have_been_created")
        redirect_to lecturers_path
      else
        render action: "new"
      end
    end

    def update
      @lecturer = Lecturer.find(params[:id])

      if @lecturer.update_attributes(form_params)
        flash[:notice] = t("notice_lecturer_have_been_updated")
        redirect_to lecturers_path
      else
        render action: "edit"
      end
    end

    def destroy
      @lecturer = Lecturer.find(params[:id])
      @lecturer.destroy

      redirect_to lecturers_url, notice: t("notice_lecturer_have_been_deleted")
    end

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
