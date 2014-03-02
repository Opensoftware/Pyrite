class RoomsController < ApplicationController
  include BlocksHelper

  respond_to :js, :html, :only => [:timetable, :timetables]

  def show
    @room = Room.find(params[:id])
  end

  def new
    @building = Building.find(params[:building_id])
    @room = @building.rooms.build
  end

  def edit
    @room = Room.find(params[:id])
  end

  def create
    @room = Room.new(params[:room])

    if @room.save
      redirect_to @room.building, notice: t("notice_classroom_was_created")
    else
      render action: "new"
    end
  end

  def update
    @room = Room.find(params[:id])

    if @room.update_attributes(params[:room])
      redirect_to @room.building, notice: t("notice_classroom_updated")
    else
      render action: "edit"
    end
  end

  def destroy
    @room = Room.find(params[:id])
    building = @room.building
    @room.destroy

    redirect_to building, notice: t("notice_room_have_been_deleted")
  end

  def timetable
    @room = Room.find(params[:id])
    @events = convert_blocks_to_events_for_viewing(@room.blocks.for_event(AcademicYear::Event.for_viewing))
    respond_with @events
  end

  def timetables
    @room = Room.find(params[:id])
    @event = AcademicYear::Event.where(:id => params[:event_id]).first
    blocks = @room.blocks.for_event(@event) + @room.blocks.reservations
    @room_name = @room.name
    @events = convert_blocks_to_events(blocks)
    respond_with @events
  end

end
