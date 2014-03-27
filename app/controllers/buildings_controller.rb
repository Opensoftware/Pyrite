class BuildingsController < ApplicationController

  def index
    @buildings = Building.all
  end

  def show
    @building = Building.find(params[:id])
    @rooms = @building.rooms
  end

  def new
    @building = Building.new
  end

  def edit
    @building = Building.find(params[:id])
  end

  def create
    @building = Building.new(form_params)

    if @building.save
      redirect_to @building, notice: t("notice_building_has_been_created")
    else
      render action: "new"
    end
  end

  def update
    @building = Building.find(params[:id])

    if @building.update_attributes(form_params)
      redirect_to @building, notice: t("notice_building_has_been_updated")
    else
      render action: "edit"
    end
  end

  def destroy
    @building = Building.find(params[:id])
    @building.destroy

    redirect_to buildings_url, notice: t("notice_building_have_been_deleted")
  end


  def form_params
    params.required(:building).permit(:name, :address, :latitude, :longitude)
  end
end
