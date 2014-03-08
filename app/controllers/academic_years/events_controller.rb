class AcademicYears::EventsController < ApplicationController

  def new
    @academic_year = AcademicYear.find(params[:academic_year_id])
    @academic_year_event = @academic_year.events.build
    render :new, :layout => false
  end

  def edit
    @academic_year = AcademicYear.find(params[:academic_year_id])
    @academic_year_event = @academic_year.events.find(params[:id])
    render :edit, :layout => false
  end

  def create
    @academic_year = AcademicYear.find(params[:academic_year_id])
    event = @academic_year.events.build(params[:academic_year_event])

    if event.save
      render :partial => "academic_years/list", :locals => {:events => @academic_year.events}
    else
      render :partial => "academic_years/modal_errors", :locals => { :object => event }, :status => 422
    end
  end

  def update
    @academic_year = AcademicYear.find(params[:academic_year_id])
    @event = AcademicYear::Event.find(params[:id])

    if @event.update_attributes(params[:academic_year_event])
      render :partial => "academic_years/list", :locals => {:events => @academic_year.events}
    else
      render :partial => "academic_years/modal_errors", :locals => { :object => @event }, :status => 422
    end
  end

  def destroy
    @academic_year_event = AcademicYear::Event.find(params[:id])
    @academic_year = @academic_year_event.academic_year
    @academic_year_event.destroy
    render :partial => "academic_years/list", :locals => {:events => @academic_year.events}
  end

  def fetch
    @academic_year_events = AcademicYear::Event.for_academic_year(params[:academic_year_id])
    render :layout => false
  end
end
