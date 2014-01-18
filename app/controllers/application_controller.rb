class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  protect_from_forgery
  helper_method :flash_messages

  def flash_messages
    flash[:notice] || flash[:error] || nil
  end

  def after_sign_in_path_for(resource)
    dashboard_index_path
  end

end
