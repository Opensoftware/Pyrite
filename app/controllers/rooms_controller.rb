class RoomsController < ApplicationController
  include BlocksHelper

  respond_to :js, :html, :only => [:timetable]

  def index
    @rooms = Room.all
  end

  def show
    @room = Room.find(params[:id])
  end

  def new
    @room = Room.new
  end

  def edit
    @room = Room.find(params[:id])
  end

  def create
    @room = Room.new(params[:room])

    if @room.save
      redirect_to @room, notice: t("notice_classroom_was_created")
    else
      render action: "new"
    end
  end

  def update
    @room = Room.find(params[:id])

    if @room.update_attributes(params[:room])
      redirect_to @room, notice: t("notice_classroom_updated")
    else
      render action: "edit"
    end
  end

  def destroy
    @room = Room.find(params[:id])
    @room.destroy

    redirect_to rooms_url
  end

  def timetable
    blocks = Room.find(params[:id]).blocks.all

    @events = convert_blocks_to_events(blocks)
    respond_with @events
  end

end
