class Lecturer < ActiveRecord::Base
  has_many :blocks

  # TODO replace by new migrations
  alias_attribute :name, :lecture
end
