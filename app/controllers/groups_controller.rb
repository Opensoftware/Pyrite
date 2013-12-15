class GroupsController < ApplicationController
  include BlocksHelper

  respond_to :html, :js, :only => [:timetable]

  def index
    @groups = Group.all
  end

  def show
    @group = Group.find(params[:id])
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
      redirect_to @group, notice: 'Group was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @group = Group.find(params[:id])

    if @group.update_attributes(params[:group])
      redirect_to @group, notice: 'Group was successfully updated.'
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
    group_ids = params[:group_ids]
    event_id = params[:event_id]
    blocks = []
    groups = []
    begin
      groups << Group.find(group_ids)
    rescue
      # LOG
    end
    groups.flatten!
    # TODO think about what will be the best way of quering blocks with and
    # without event_id, for example without event_id we will query whole
    # academic year? and if event_id is available should we load new events for
    # fullcalendar in case if the end_date will be reached?
    if event_id.empty?
      groups.each do |group|
        blocks << group.blocks
      end
    else
      groups.each do |group|
        blocks << group.blocks.where(:event_id => event_id)
      end
    end

    blocks.flatten!
    @events = convert_blocks_to_events(blocks)
    respond_with @events
  end
end
