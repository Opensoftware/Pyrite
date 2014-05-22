module Pyrite
  class AcademicYears::EventsController < PyriteController

    def new
      authorize! :manage, AcademicYear::Event
      @academic_year = AcademicYear.find(params[:academic_year_id])
      @academic_year_event = @academic_year.events.build
      render :new, :layout => false
    end

    def edit
      authorize! :manage, AcademicYear::Event
      @academic_year = AcademicYear.find(params[:academic_year_id])
      @academic_year_event = @academic_year.events.find(params[:id])
      render :edit, :layout => false
    end

    def create
      authorize! :manage, AcademicYear::Event
      @academic_year = AcademicYear.find(params[:academic_year_id])
      event = @academic_year.events.build(form_params)

      if event.save
        render :partial => "pyrite/academic_years/list", :locals => {:events => @academic_year.events}
      else
        render :partial => "pyrite/academic_years/modal_errors", :locals => { :object => event }, :status => 422
      end
    end

    def update
      authorize! :manage, AcademicYear::Event
      @academic_year = AcademicYear.find(params[:academic_year_id])
      @event = AcademicYear::Event.find(params[:id])

      if @event.update_attributes(form_params)
        render :partial => "pyrite/academic_years/list", :locals => {:events => @academic_year.events}
      else
        render :partial => "pyrite/academic_years/modal_errors", :locals => { :object => @event }, :status => 422
      end
    end

    def destroy
      authorize! :manage, AcademicYear::Event
      @academic_year_event = AcademicYear::Event.find(params[:id])
      @academic_year = @academic_year_event.academic_year
      if @academic_year_event.is_for_viewing?
        Settings.reset_event_id_for_viewing
      end
      if @academic_year_event.is_for_editing?
        Settings.reset_event_id_for_editing
      end
      @academic_year_event.destroy
      render :partial => "pyrite/academic_years/list", :locals => {:events => @academic_year.events}
    end

    def fetch
      authorize! :manage, AcademicYear::Event
      @academic_year_events = AcademicYear::Event.for_academic_year(params[:academic_year_id])
      render :layout => false
    end

    private

      def form_params
        params.required(:academic_year_event).permit(:name, :start_date, :end_date, :lecture_free)
      end

  end
end