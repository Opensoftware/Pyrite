class ReservationsController < ApplicationController
  include BlocksHelper

  def show
    @room = Room.find(params[:room_id])
    # TODO implement with event_id
    @events = convert_blocks_to_events(@room.blocks)
  end

  def new
    @block = Block.new
  end

  def create
    @block = Block.new(params[:block])

    if @block.save_reservation
      flash[:notice] = t("notice_block_has_been_created")
      redirect_to new_reservation_path
    else
      render :new
    end
  end
end
