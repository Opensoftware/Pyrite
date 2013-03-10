# encoding: utf-8
class FreedaysController < ApplicationController

  def index
    @freedays = Freeday.find(:all)
  end

  def new
    @freeday = Freeday.new
  end

  def edit
    @freeday = Freeday.find(params[:id])
  end

  def create
    @freeday = Freeday.new(params[:freeday])

    if @freeday.save
      flash[:notice] = t("notice_successfully_saved")
      redirect_to freedays_path
    else
      flash[:error] = @freeday.errors.full_messages #t("error_invalid_data")
      render :action => "new"
    end
  end

  def update
    @freeday = Freeday.find(params[:id])
	if	@freeday.update_attributes(params[:freeday])
     flash[:notice] = 'Freeday was successfully updated.'
     redirect_to freedays_path
    else
      render :action => "edit"
    end
  end

  def destroy
    @freeday = Freeday.find(params[:id])
    @freeday.destroy

    redirect_to freedays_path
  end
end
