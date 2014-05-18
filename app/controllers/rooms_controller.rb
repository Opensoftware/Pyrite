class RoomsController < ApplicationController
  include BlocksHelper
  include ApplicationHelper

  skip_before_filter :authenticate_user!, :only => [:timetable]
  respond_to :js, :html, :only => [:timetable, :timetables, :timetables_for_meeting]

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
    @room = Room.new(form_params)

    if @room.save
      redirect_to @room.building, notice: t("notice_classroom_was_created")
    else
      render action: "new"
    end
  end

  def update
    @room = Room.find(params[:id])

    if @room.update_attributes(form_params)
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
    @reset_date = params[:reset_date] || false
    if @event
      blocks = @room.blocks.for_event(@event) + @room.blocks.reservations
    else
      # TODO (fullCalendar2) this is heavy we need to reduce amount of blocks to
      # read max +/- 3 weeks and rest will be loaded when user will change the
      # date.  for reservations we taking all blocks for given room
      blocks = @room.blocks
    end
    @room_name = @room.name
    @events = convert_blocks_to_events(blocks)
    respond_with @events
  end

  def timetables_for_meeting
    @room = Room.find(params[:id])
    @reset_date = params[:reset_date] || false
    blocks = @room.blocks.reservations
    @meeting = AcademicYear::Meeting.where(:id => params[:meeting_id]).first
    blocks += @meeting.blocks.where(:room_id => @room.id) if @meeting
    @room_name = @room.name
    @events = convert_blocks_to_events(blocks)
    @current_date = @meeting.start_date.strftime("%F")
    respond_with @events do |format|
      format.js { render :timetables }
    end
  end

  def print_all
    rooms = Room.all

    rooms_timetable = Pdf::RoomTimetable.new(rooms, params[:event_id], swap_monday(available_days))
    data = rooms_timetable.to_pdf

    send_data(data, :filename => t("pyrite.filename.rooms_timetable"),
             :type => "application/pdf", :disposition => "inline")
  end

  def print
    room = Room.find(params[:id])
    event_id = params[:event_id]

    data = Rails.cache.fetch(cache_key_for_room_timetable(room, event_id)) do
      timetable = Pdf::RoomTimetable.new([room], event_id, swap_monday(available_days))
      data = timetable.to_pdf
      Rails.cache.write(cache_key_for_room_timetable(room, event_id), data)
      data
    end

    send_data(data, :filename => "#{room.name}.pdf", :type => "application/pdf",
              :disposition => "inline")
  end

  private

    def form_params
      params.require(:room).permit(:name, :capacity, :building_id, :comments, :room_type_id)
    end

    def cache_key_for_room_timetable(room, event_id)
      count = room.blocks.count
      settings = Settings.maximum(:updated_at).try(:utc).try(:to_s, :number)
      max_block_updated_at = room.blocks.maximum(:updated_at).try(:utc).try(:to_s, :number)
      "room-timetable/#{event_id}-#{settings}-#{room.name}-#{max_block_updated_at}-#{count}"
    end
end
