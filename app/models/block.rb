class Block < ActiveRecord::Base
  belongs_to :room
  belongs_to :lecturer
  belongs_to :building
  belongs_to :event, :class_name => "AcademicYear::Event"
  belongs_to :block_type
  has_many :dates

  has_and_belongs_to_many :groups

  attr_accessible :name, :start_date, :end_date, :comments, :group_ids, :lecturer_id, :room_id, :event_id, :block_type_id, :day
  attr_accessor :day, :start_date, :end_date
  after_save :populate_dates # we need to have block id before we will create all dates TODO should be done in transaction

  # TODO in case if populare_dates  will fail we need fallback
  def populate_dates
    begin
      if event_id.nil?
        # TODO should we add that block to event which fit the dates range?
        dates.create(:start_date => start_date, :end_date => end_date)
      else
        start_hour = Time.parse(start_date).hour
        start_min = Time.parse(start_date).min
        end_hour = Time.parse(end_date).hour
        end_min = Time.parse(end_date).min

        date_range = (event.start_date.to_date..event.end_date.to_date).select {|date| day.to_i == date.wday }
        date_range.each do |date|
          block_start_date = Time::mktime(date.year, date.month, date.day, start_hour, start_min)
          block_end_date = Time::mktime(date.year, date.month, date.day, end_hour, end_min)
          dates.create(:start_date => block_start_date, :end_date => block_end_date)
        end
      end
    rescue => e
      # TODO logger
      # TODO stop transaction
    end
  end

end
