class UsersController < ApplicationController
  before_filter :authenticate_user!

  def account
    @without_weekends = current_user.preferences[:without_weekends] || false
  end

  def update
    options = {:without_weekends => !!params[:without_weekends] }
    current_user.preferences.merge!(options)
    if current_user.save
      flash[:notice] = t("notice_update_user_preferences_successed")
      redirect_to user_account_path
    else
      flash[:error] = t("error_update_user_preferences_faild")
      render :account
    end
  end
end
