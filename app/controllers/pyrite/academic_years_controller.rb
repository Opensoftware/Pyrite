module Pyrite
  class AcademicYearsController < PyriteController

    def index
      authorize! :manage, AcademicYear
      @academic_years = AcademicYear.all
    end

    def show
      authorize! :show, AcademicYear
      @academic_year = AcademicYear.find(params[:id])
    end

    def new
      authorize! :manage, AcademicYear
      @academic_year = AcademicYear.new
    end

    def edit
      authorize! :manage, AcademicYear
      @academic_year = AcademicYear.find(params[:id])
    end

    def create
      authorize! :manage, AcademicYear

      @academic_year = AcademicYear.new(form_params)

      if @academic_year.save
        flash[:notice] = t("notice_academic_year_was_created")
        redirect_to academic_year_path(@academic_year)
      else
        render action: "new"
      end
    end

    def update
      authorize! :manage, AcademicYear
      @academic_year = AcademicYear.find(params[:id])

      if @academic_year.update_attributes(form_params)
        flash[:notice] = t("notice_academic_year_was_updated")
        redirect_to academic_year_path(@academic_year)
      else
        render action: "edit"
      end
    end

    def destroy
      authorize! :manage, AcademicYear
      @academic_year = AcademicYear.find(params[:id])
      if @academic_year.is_used_in_settings?
        Settings.reset_event_id_for_editing
        Settings.reset_event_id_for_viewing
      end
      @academic_year.destroy

      redirect_to academic_years_path
    end

    private

      def form_params
        params.required(:academic_year).permit(:name, :start_date, :end_date)
      end
  end
end
