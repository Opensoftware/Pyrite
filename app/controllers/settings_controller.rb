class SettingsController < ApplicationController

  def edit
    authorize! :edit, Settings
    @settings = Settings.first
  end

  def update
    authorize! :update, Settings
    @settings = Settings.first
    if @settings.update_attributes(params[:settings])
      flash[:notice] = t("notice_settings_updated")
      redirect_to edit_settings_path
    else
      render :edit
    end
  end
end
