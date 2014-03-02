class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  def after_sign_in_path_for(resource)
    dashboard_index_path
  end

end
