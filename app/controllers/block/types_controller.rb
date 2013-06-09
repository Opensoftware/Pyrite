class Block::TypesController < ApplicationController

  def index
    @block_types = Block::Type.all
  end

  def new
    @block_type = Block::Type.new
  end

  def edit
    @block_type = Block::Type.find(params[:id])
  end

  def create
    @block_type = Block::Type.new(params[:block_type])

    if @block_type.save
      flash[:notice] = t("notice_block_type_created")
      redirect_to block_types_path
    else
      render :new
    end
  end

  def update
    @block_type = Block::Type.find(params[:id])

    if @block_type.update_attributes(params[:block_type])
      flash[:notice] = t("notice_block_type_updated")
      redirect_to block_types_path
    else
      render :edit
    end
  end

  def destroy
    @block_type = Block::Type.find(params[:id])
    @block_type.destroy

    redirect_to block_types_url
  end
end
