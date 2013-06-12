class Plan < ActiveRecord::Base
	has_and_belongs_to_many :groups

  attr_accessible :plan_id, :godz, :katedra, :dni, :dlugosc, :sala, :prowadzacy, :czestotliwosc, :przedmiot, :rodzaj, :budynek, :uwagi
end
