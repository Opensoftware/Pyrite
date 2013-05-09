class AcademicYearsController < ApplicationController

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
    @academic_year = AcademicYear.new(params[:academic_year])

    if @academic_year.save
      flash[:notice] = t("notice_academic_year_was_created")
      redirect_to @academic_year
    else
      render action: "new"
    end
  end

  def update
    authorize! :manage, AcademicYear
    @academic_year = AcademicYear.find(params[:id])

    if @academic_year.update_attributes(params[:academic_year])
      flash[:notice] = t("notice_academic_year_was_updated")
      redirect_to @academic_year
    else
      render action: "edit"
    end
  end

  def destroy
    authorize! :manage, AcademicYear
    @academic_year = AcademicYear.find(params[:id])
    @academic_year.destroy

    redirect_to academic_years_url
  end
end
