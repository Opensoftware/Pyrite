class Block < ActiveRecord::Base
  belongs_to :room
  belongs_to :lecturer
  belongs_to :building
  belongs_to :event
  belongs_to :block_type
  has_many :dates

  has_and_belongs_to_many :groups

  attr_accessible :name, :start_date, :end_date, :comments, :group_ids, :lecturer_id, :room_id, :event_id, :block_type_id, :day
  attr_accessor :day, :start_date, :end_date
  after_save :populate_dates # we need to have block id before we will create all dates

  def populate_dates
    date_range = (event.start_date.to_date..event.end_date.to_date).select {|date| day.to_i == date.wday }
    date_range.each do |date|
      dates.create(:start_date => date, :end_date => date)
    end
  end

end
