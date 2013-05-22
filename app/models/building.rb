class Building < ActiveRecord::Base
  alias_attribute :name, :nazwa
  has_many :blocks
end
