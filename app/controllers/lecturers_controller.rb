class LecturersController < ApplicationController
  include BlocksHelper

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
    @lecturer = Lecturer.new(params[:lecturer])

    if @lecturer.save
      flash[:notice] = t("notice_lecturer_has_been_created")
      redirect_to lecturers_path
    else
      render action: "new"
    end
  end

  def update
    @lecturer = Lecturer.find(params[:id])

    if @lecturer.update_attributes(params[:lecturer])
      flash[:notice] = t("notice_lecturer_has_been_updated")
      redirect_to lecturers_path
    else
      render action: "edit"
    end
  end

  def destroy
    @lecturer = Lecturer.find(params[:id])
    @lecturer.destroy

    redirect_to lecturers_url
  end

  def timetable
    @lecturer = Lecturer.where(:id => params[:id]).first
    @events = convert_blocks_to_events_for_viewing(@lecturer.blocks.for_event(AcademicYear::Event.for_viewing))
  end
end
