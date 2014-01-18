class SettingsController < ApplicationController

  def edit
    authorize! :edit, Settings
    @settings = Settings.fetch_settings
  end

  def update
    authorize! :update, Settings
    if Settings.update_settings(params[:settings])
      flash[:notice] = t("notice_settings_updated")
      redirect_to edit_settings_path
    else
      render :edit
    end
  end
end
