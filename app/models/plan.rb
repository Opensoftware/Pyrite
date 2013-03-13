class Plan < ActiveRecord::Base
	has_and_belongs_to_many :groups
	belongs_to :schedules, :foreign_key => "plan_id", :class_name => "Schedule"

  attr_accessible :plan_id, :godz, :katedra, :dni, :dlugosc, :sala, :prowadzacy, :czestotliwosc, :przedmiot, :rodzaj, :budynek, :uwagi
end
