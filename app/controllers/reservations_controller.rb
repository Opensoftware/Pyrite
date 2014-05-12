class ReservationsController < ApplicationController
  include BlocksHelper

  skip_before_filter :authenticate_user!, :only => [:show]
  before_filter :check_settings, :except => [:show]

  respond_to :js, :only => [:update, :create]

  def show
    @room = Room.find(params[:room_id])
    # TODO implement with event_id
    @events = convert_blocks_to_events_for_viewing(@room.blocks)
  end

  def new
    @block = Block.new
  end

  def create
    @block = Block.new(form_params)

    if @block.save_reservation
      flash[:notice] = t("notice_block_has_been_created")
      respond_with(@block, :status => :ok)
    else
      respond_with(@block, :status => :unprocessable_entity)
    end
  end

  private

    def form_params
      params.required(:block).permit(:start_time, :day_with_date,
        :lecturer_id, :comments, :end_time, :type_id, :room_id, :name)
    end

    def check_settings
      academic_year_for_editing = AcademicYear.for_editing
      if academic_year_for_editing.blank?
        flash[:notice] = t("notice.missing.academic_year")
        redirect_to dashboard_index_path
      end
    end
end
