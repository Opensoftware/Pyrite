class BlocksController < ApplicationController
  def index
  end

  def new
    @block = Block.new
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

end
