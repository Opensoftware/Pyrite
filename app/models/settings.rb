class Settings < ActiveRecord::Base
  attr_accessible :current_plan, :plan_to_edit, :email_contact, :unit_name


  class << self
    # If plan_to_edit is not set, default one is the first found.
    def plan_to_edit
      Settings.first.plan_to_edit || AcademicYear.first.try(:id)
    end

    def plan_to_view
      Settings.first.current_plan
    end

    def email_contact
      Settings.first.email_contact
    end

    def unit_name
      Settings.first.unit_name
    end
  end
end
