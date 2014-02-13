class GroupsController < ApplicationController
  include BlocksHelper

  respond_to :html, :js, :only => [:timetables, :timetable]

  def index
    @groups = Group.all
  end

  def new
    @group = Group.new
  end

  def edit
    @group = Group.find(params[:id])
  end

  def create
    @group = Group.new(params[:group])

    if @group.save
      flash[:notice] = t("notice_group_has_been_created")
      redirect_to groups_path
    else
      render action: "new"
    end
  end

  def update
    @group = Group.find(params[:id])

    if @group.update_attributes(params[:group])
      flash[:notice] = t("notice_group_has_been_updated")
      redirect_to groups_path
    else
      render action: "edit"
    end
  end

  def destroy
    @group = Group.find(params[:id])
    @group.destroy

    redirect_to groups_url
  end

  def timetable
    @group = Group.find(params[:id])
    # TODO implement with event_id
    @events = convert_blocks_to_events(@group.blocks)
    respond_with @events
  end

  def timetables
    group_ids = params[:group_ids]
    @event = AcademicYear::Event.where(:id => params[:event_id]).first
    # TODO think about what will be the best way of quering blocks with and
    # without event_id, for example without event_id we will query whole
    # academic year? and if event_id is available should we load new events for
    # fullcalendar in case if the end_date will be reached?
    blocks = Block.for_event(@event).for_groups(group_ids) + Block.reservations

    @events = convert_blocks_to_events(blocks)
    respond_with @events
  end
end
