SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|
    primary.dom_class = 'nav navbar-nav'
    if current_user
      primary.item :pyrite, "<i class='icon-callendar-white'></i> #{t('pyrite.title_system_name')}", main_app.dashboard_path
      primary.item :user_account, "<i class='icon-user-white'></i> #{current_user.verifable.surname_name}", main_app.user_path(current_user) do |primary|
        primary.item :nav, t(:label_account_settings), main_app.edit_user_path(current_user)
        if department_settings
          primary.item :nav, t(:label_thesis_plural_count), main_app.edit_department_setting_path(department_settings), :if => lambda { can?(:manage, DepartmentSettings) }
        end
        primary.item :logout, t(:label_logout), main_app.logout_path, method: :delete
      end
    else
      primary.item :pyrite, "<i class='icon-callendar-white'></i> #{t('pyrite.title_system_name')}", main_app.root_path
      primary.item :login, I18n.t(:label_login), main_app.new_user_session_path
    end
  end
end
