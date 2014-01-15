class LecturersController < ApplicationController
  include BlocksHelper

  def timetable
    @lecturer = Lecturer.where(:id => params[:id]).first
    @events = convert_blocks_to_events(@lecturer.blocks)
  end
end
