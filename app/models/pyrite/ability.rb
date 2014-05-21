module Pyrite
  class Ability
    include CanCan::Ability

    def initialize(user)
      user ||= Pyrite::User.new # guest user (not logged in)
      if user.new_record?
        user.role = Role.where(const_name: 'anonymous').first
      else
        can :manage, :my
      end

      if user.pyrite_admin?
        can :read, :dashboard
        can :manage, Settings
        can :manage, Block
        can :manage, Building
        can :manage, Lecturer
        can :manage, AcademicYear
        can :manage, AcademicYear::Event
        can :manage, AcademicYear::Meeting
        can :manage, Block::Variant
        can :manage, Group
        can :read, :timetables
        can :manage, :reservations
        can :print, :timetables

        can :manage, :own_settings
      else
        can :read, :timetables
        can :print, :timetables
      end
    end
  end
end
