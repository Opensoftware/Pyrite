class Group < ActiveRecord::Base
	has_and_belongs_to_many :plans
	has_and_belongs_to_many :reservations
	has_and_belongs_to_many :blocks

  attr_accessible :name
  # TODO remove when model will be updated
  alias_attribute :name, :nazwa
end
