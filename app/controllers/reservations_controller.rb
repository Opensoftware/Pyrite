class ReservationsController < ApplicationController
  include BlocksHelper

  respond_to :js, :only => [:update]

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
      redirect_to new_reservation_path
    else
      render :new
    end
  end

  private

    def form_params
      params.required(:block).permit(:start_time, :day, :day_with_date,
        :lecturer_id, :comments, :end_time, :event_id, :room_id, :name)
    end

end
