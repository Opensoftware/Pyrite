DashboardController.class_eval do

  before_filter :pyrite_dashboard, :only => :index, :if => :pyrite_check_permission

  def pyrite_dashboard
    pyrite_ability
    can? :read, :pyrite_dashboard
  end

  private

    def pyrite_check_permission
      pyrite_ability
      can? :read, :pyrite_dashboard
    end

    def pyrite_ability
      # Override current_ability to use engine abilities instead of usi
      user = Pyrite::User.where(:id => current_user.try(:id)).first
      @current_ability = Pyrite::Ability.new(user)
    end
end
