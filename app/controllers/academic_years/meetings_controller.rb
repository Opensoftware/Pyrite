class AcademicYears::MeetingsController < ApplicationController

  def new
    @academic_year_event = AcademicYear::Event.find(params[:event_id])
    @academic_year_meeting = @academic_year_event.meetings.build
    render :new, :layout => false
  end

  def edit
    @academic_year_meeting = AcademicYear::Meeting.find(params[:id])
    render :edit, :layout => false
  end

  def create
    @academic_year_event = AcademicYear::Event.find(params[:event_id])
    meeting = @academic_year_event.meetings.build(params[:academic_year_meeting])
    @academic_year = @academic_year_event.academic_year

    if meeting.save
      render :partial => "academic_years/list", :locals => {:events => @academic_year.events }
    else
      render :partial => "academic_years/modal_errors", :locals => { :object => meeting }, :status => 422
    end
  end

  def update
    @academic_year_meeting = AcademicYear::Meeting.find(params[:id])
    @academic_year = @academic_year_meeting.event.academic_year
    @events = @academic_year.events

    if @academic_year_meeting.update_attributes(params[:academic_year_meeting])
      render :partial => "academic_years/list", :locals => {:events => @events }
    else
      render :partial => "academic_years/modal_errors", :locals => { :object => @academic_year_meeting }, :status => 422
    end
  end

  def destroy
    @academic_year_meeting = AcademicYear::Meeting.find(params[:id])
    @academic_year = @academic_year_meeting.event.academic_year
    @academic_year_meeting.destroy
    render :partial => "academic_years/list", :locals => {:events => @academic_year.events}
  end

  def fetch
    @academic_year_meetings = AcademicYear::Event.find(params[:event_id]).meetings
    render :layout => false
  end

  def fetch_days
    @days = AcademicYear::Meeting.find(params[:meeting_id]).available_days
    render :layout => false
  end
end
