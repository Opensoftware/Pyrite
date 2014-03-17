class BlocksController < ApplicationController

  respond_to :js, :only => [:update, :destroy]

  def new
    @block = Block.new
  end

  def new_part_time
    @block = Block.new
    @meetings = AcademicYear::Meeting.for_editing
    @days = @meetings.first.available_days
  end

  def edit
    @block = Block.find(params[:id])
    render :layout => false
  end

  def update
    @block = Block.find(params[:id])
    @block.update_attributes(params[:block])
    flash[:notice] = t("notice_block_has_been_updated")
    respond_with(@block)
  end

  def create
    @block = Block.new(params[:block])

    if @block.save
      flash[:notice] = t("notice_block_has_been_created")
      redirect_to new_block_path
    else
      render :new
    end
  end

  def create_part_time
    @block = Block.new(params[:block])
    @meetings = AcademicYear::Meeting.for_editing
    @days = @meetings.first.available_days

    if @block.save
      flash[:notice] = t("notice_block_has_been_created")
      redirect_to new_part_time_block_path
    else
      render :new_part_time
    end

  end

  def destroy
    @block = Block.find(params[:id])
    @block.destroy
    respond_with(@block)
  end

end
