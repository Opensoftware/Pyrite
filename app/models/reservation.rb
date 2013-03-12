class Reservation < ActiveRecord::Base
#	has_and_belongs_to_many :groups
  attr_accessible :godz, :prowadzacy, :dlugosc, :rodzaj, :przedmiot, :waznosc, :grupa, :uwagi, :sala, :dni
end
