class Settings < ActiveRecord::Base
  attr_accessible :current_plan, :plan_to_edit, :email_contact, :unit_name
end
