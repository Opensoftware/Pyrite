class AccountController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  # If you want "remember me" functionality, add this before_filter to Application Controller
  before_filter :login_from_cookie
  layout "main"

  # say something nice, you goof!  something sweet.
  def index
    redirect_to(:controller => 'main')
  end

  def login
    return unless request.post?
    self.current_user = User.authenticate(params[:login], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        self.current_user.remember_me
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
	  if !(current_user.has_role? 'user')
        current_user.has_role 'user'
	  end
      redirect_back_or_default(:controller => '/siatka', :action => 'index')
      session[:uid] = current_user.id
      flash[:notice] = t("notice_successfully_login")
    end
  end

  def signup
    permit "kierownik"
    @user = User.new(params[:user])
    return unless request.post?
    @user.save!
    self.current_user = @user
    redirect_back_or_default(:controller => '/account', :action => 'index')
    flash[:notice] = t("notice_successfully_registered")
  rescue ActiveRecord::RecordInvalid
    render :action => 'signup'
  end

  def logout
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    session[:uid] = nil
    flash[:notice] = t("notice_successfully_logout")
    redirect_back_or_default(:controller => '/account', :action => 'index')
  end
end
