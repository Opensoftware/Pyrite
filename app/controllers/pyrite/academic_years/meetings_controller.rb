module Pyrite
  class AcademicYears::MeetingsController < PyriteController

    def new
      authorize! :manage, AcademicYear::Meeting
      @academic_year_event = AcademicYear::Event.find(params[:event_id])
      @academic_year_meeting = @academic_year_event.meetings.build
      render :new, :layout => false
    end

    def edit
      authorize! :manage, AcademicYear::Meeting
      @academic_year_meeting = AcademicYear::Meeting.find(params[:id])
      render :edit, :layout => false
    end

    def create
      authorize! :manage, AcademicYear::Meeting
      @academic_year_event = AcademicYear::Event.find(params[:event_id])
      meeting = @academic_year_event.meetings.build(form_params)
      @academic_year = @academic_year_event.academic_year

      if meeting.save
        render :partial => "pyrite/academic_years/list", :locals => {:events => @academic_year.events }
      else
        render :partial => "pyrite/academic_years/modal_errors", :locals => { :object => meeting }, :status => 422
      end
    end

    def update
      authorize! :manage, AcademicYear::Meeting
      @academic_year_meeting = AcademicYear::Meeting.find(params[:id])
      @academic_year = @academic_year_meeting.event.academic_year
      @events = @academic_year.events

      if @academic_year_meeting.update_attributes(form_params)
        render :partial => "pyrite/academic_years/list", :locals => {:events => @events }
      else
        render :partial => "pyrite/academic_years/modal_errors", :locals => { :object => @academic_year_meeting }, :status => 422
      end
    end

    def destroy
      authorize! :manage, AcademicYear::Meeting
      @academic_year_meeting = AcademicYear::Meeting.find(params[:id])
      @academic_year = @academic_year_meeting.event.academic_year
      @academic_year_meeting.destroy
      render :partial => "pyrite/academic_years/list", :locals => {:events => @academic_year.events}
    end

    def fetch
      authorize! :manage, AcademicYear::Meeting
      @academic_year_meetings = AcademicYear::Event.find(params[:event_id]).meetings
      render :layout => false
    end

    def fetch_days
      authorize! :manage, AcademicYear::Meeting
      @days = AcademicYear::Meeting.find(params[:meeting_id]).available_days
      render :layout => false
    end

    private

      def form_params
        params.required(:academic_year_meeting).permit(:name, :start_date, :end_date)
      end
  end
end
