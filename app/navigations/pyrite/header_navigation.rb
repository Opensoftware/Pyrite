SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|
    primary.dom_class = 'nav navbar-nav'
    if current_user
      primary.item :user_account, "<i class='icon icon-white icon-user'></i> #{current_user.verifable.surname_name}", main_app.user_path(current_user) do |primary|
        primary.item :nav, t(:label_account_settings), main_app.edit_user_path(current_user)
        primary.item :logout, t(:label_logout), main_app.logout_path, method: :delete
      end
    else
      primary.item :login, I18n.t(:label_login), main_app.new_user_session_path
    end
  end
end
