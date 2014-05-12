class GroupsController < ApplicationController
  include BlocksHelper
  include ApplicationHelper

  skip_before_filter :authenticate_user!, :only => [:timetable, :print]
  respond_to :html, :js, :only => [:timetables, :timetable, :timetables_for_meeting]

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
    @group = Group.new(form_params)

    if @group.save
      flash[:notice] = t("notice_group_has_been_created")
      redirect_to groups_path
    else
      render action: "new"
    end
  end

  def update
    @group = Group.find(params[:id])

    if @group.update_attributes(form_params)
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
    @events = convert_blocks_to_events_for_viewing(@group.blocks.for_event(AcademicYear::Event.for_viewing))
    respond_with @events
  end

  def timetables
    group_ids = params[:group_ids]
    @reset_date = params[:reset_date] || false
    @event = AcademicYear::Event.where(:id => params[:event_id]).first
    # TODO think about what will be the best way of quering blocks with and
    # without event_id, for example without event_id we will query whole
    # academic year? and if event_id is available should we load new events for
    # fullcalendar in case if the end_date will be reached?
    blocks = Block.for_event(@event).for_groups(group_ids)

    @events = convert_blocks_to_events(blocks)
    respond_with @events
  end

  def timetables_for_meeting
    group_ids = params[:group_ids]
    @reset_date = params[:reset_date] || false
    @meeting = AcademicYear::Meeting.where(:id => params[:meeting_id]).first
    blocks = @meeting.blocks.joins(:groups).where("#{Group.table_name}.id in (?)", group_ids)

    @events = convert_blocks_to_events(blocks)
    @current_date = @meeting.start_date.strftime("%F")
    respond_with @events do |format|
      format.js { render :timetables }
    end
  end

  def print_all
    groups = Group.all

    groups_timetable = Pdf::GroupTimetable.new(groups, params[:event_id], available_days)
    data = groups_timetable.to_pdf

    send_data(data, :filename => t(:file_groups_timetable),
              :type => 'application/pdf', :disposition => "inline")
  end

  def print
    group = Group.find(params[:id])
    event_id = params[:event_id]

    data = Rails.cache.fetch(cache_key_for_group_timetable(group, event_id)) do
      timetable = Pdf::GroupTimetable.new([group], event_id, available_days)
      data = timetable.to_pdf
      Rails.cache.write(cache_key_for_group_timetable(group, event_id), data)
      data
    end

    send_data(data, :filename => "#{group.name}.pdf",
              :type => 'application/pdf', :disposition => "inline")
  end


  private

    def form_params
      params.required(:group).permit(:name)
    end

    def cache_key_for_group_timetable(group, event_id)
      count = Block.joins(:groups).where("blocks_groups.group_id = ?", group.id).count
      settings       = Settings.maximum(:updated_at).try(:utc).try(:to_s, :number)
      max_block_updated_at = group.blocks.maximum(:updated_at).try(:utc).try(:to_s, :number)
      "group-timetable/#{event_id}-#{settings}-#{group.name}-#{max_block_updated_at}-#{count}"
    end
end
