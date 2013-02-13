class Plan < ActiveRecord::Base
	has_and_belongs_to_many :groups
	belongs_to :schedules, :foreign_key => "plan_id", :class_name => "Schedule"
end
