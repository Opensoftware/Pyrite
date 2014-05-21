class PyriteController < ApplicationController
  layout "pyrite/layouts/application"

  check_authorization

  def current_ability
    # TODO
    # For ability we have to ues Pyrite::User not ::User this is why we have to
    # translate current_user to Pyrite::User, maybe there is a better way of doing
    # that?
    user = Pyrite::User.find(current_user.id) || nil
    @current_ability ||= Pyrite::Ability.new(user)
  end

end
