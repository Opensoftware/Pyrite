class Group < ActiveRecord::Base
	has_and_belongs_to_many :plans
	has_and_belongs_to_many :reservations
	has_and_belongs_to_many :blocks

  # TODO remove when model will be updated
  def name
    self.nazwa
  end
end
