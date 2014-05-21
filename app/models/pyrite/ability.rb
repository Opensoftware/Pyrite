module Pyrite
  class Ability
    include CanCan::Ability

    def initialize(user)
      user ||= Pyrite::User.new # guest user (not logged in)
      if user.pyrite_admin?
        can :read, :dashboard
        can :manage, Settings
        can :manage, Block
        can :manage, Building
        can :manage, Lecturer
        can :manage, AcademicYear
        can :manage, Block::Variant
        can :manage, Group
      else
        can :read, :timetables
      end
    end
  end
end
