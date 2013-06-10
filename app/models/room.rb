class Room < ActiveRecord::Base
  attr_accessible :name, :type, :capacity, :building_id, :comments

  # TODO po zmianie migracji wywalić te metody
  #
  alias_attribute :name, :numer
  alias_attribute :type, :rodzaj
  alias_attribute :capacity, :ilosc_miejsc
  alias_attribute :building_id, :budynek_id
  alias_attribute :comments, :uwagi

  belongs_to :building, :foreign_key => "budynek_id"
  has_many :blocks
end
