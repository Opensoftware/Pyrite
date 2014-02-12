class Block < ActiveRecord::Base
  belongs_to :room
  belongs_to :lecturer
  belongs_to :building
  belongs_to :event, :class_name => "AcademicYear::Event"
  belongs_to :type, :class_name => "Block::Type"
  has_many :dates, :dependent => :destroy

  has_many :groups, :through => :blocks_groups
  has_many :blocks_groups, :dependent => :destroy

  attr_accessible :name, :start_time, :end_time, :comments, :group_ids,
                  :lecturer_id, :room_id, :event_id, :type_id, :day,
                  :day_with_date, :start_date, :end_date
  attr_accessor :day, :start_time, :end_time, :day_with_date, :start_date, :end_date

  # TODO split saving reservation and standard blocks
  # event_id for block/new is required
  before_save :populate_dates

  scope :for_groups, ->(group_ids) { joins(:blocks_groups).where("#{BlocksGroup.table_name}.group_id" => group_ids) }
  scope :for_event, ->(event_id) { event_id.present? ? where(:event_id => event_id) : self.scoped }
  scope :overlapped, ->(start_date, end_date) {
    joins(:dates).where("block_dates.start_date < ? AND
                         block_dates.end_date > ?", end_date , start_date)
  }

  validates :start_time, :end_time, :name, :presence => true
  validate :validate_times
  validate :validate_day
  validate :check_collisions

  def populate_dates
    begin
      start_hour = Time.parse(start_time).hour
      start_min = Time.parse(start_time).min
      end_hour = Time.parse(end_time).hour
      end_min = Time.parse(end_time).min

      if event_id.nil?
        # This will happen only for reservation
        block_date = Time.parse(day_with_date)
        block_start_date = block_date.advance(:hours => start_hour, :minutes => start_min)
        block_end_date = block_date.advance(:hours => end_hour, :minutes => end_min)
        dates.build(:start_date => block_start_date, :end_date => block_end_date)
      else
        date_range = (event.start_date.to_date..event.end_date.to_date).select {|date| day.to_i == date.wday }
        date_range.each do |date|
          block_start_date = Time::mktime(date.year, date.month, date.day, start_hour, start_min)
          block_end_date = Time::mktime(date.year, date.month, date.day, end_hour, end_min)
          dates.build(:start_date => block_start_date, :end_date => block_end_date)
        end
      end
    rescue => e
      # TODO logger
      return false
    end
  end

  def save_reservation
    reservation = true
    save
  end

  def lecturer_name
    lecturer.try(:name_with_title).to_s
  end

  def groups_names
    groups.map {|g| g.name }.join(" ")
  end

  def type_name
    type.try(:short_name).to_s
  end

  private

    def validate_times
      begin
        if Time.parse(start_time) > Time.parse(end_time)
          errors.add(:start_time, I18n.t("error_must_be_lower_then_end_time"))
        end
      rescue => e
        # TODO logger
        errors.add(:base, I18n.t("error_internal_error"))
      end
    end

    def validate_day
      if day.blank? and day_with_date.blank?
        errors.add(:day, I18n.t("error_day_not_present"))
      end
    end


  private

    def check_collisions
      begin
        start_hour = Time.parse(start_time).hour
        start_min = Time.parse(start_time).min
        end_hour = Time.parse(end_time).hour
        end_min = Time.parse(end_time).min

        if event_id.nil?
          # This will happen only for reservation
          block_date = Time.parse(day_with_date)
          block_start_date = block_date.advance(:hours => start_hour, :minutes => start_min)
          block_end_date = block_date.advance(:hours => end_hour, :minutes => end_min)
          return false unless check_blocks_collisions(block_start_date, block_end_date)
        else
          date_range = (event.start_date..event.end_date).select { |date|
            day.to_i == date.wday
          }
          date_range.each do |date|
            block_start_date = Time::mktime(date.year, date.month, date.day,
                                            start_hour, start_min)
            block_end_date = Time::mktime(date.year, date.month, date.day,
                                          end_hour, end_min)
            return false unless check_blocks_collisions(block_start_date, block_end_date)
          end
        end
      rescue => e
        # TODO logger
        return false
      end

    end


    def check_blocks_collisions(block_start_date, block_end_date)
      room_blocks = Block
        .where(:room_id => room_id)
        .overlapped(block_start_date, block_end_date).count
      lecturer_blocks = Block
        .where(:lecturer_id => lecturer_id)
        .overlapped(block_start_date, block_end_date).count
      group_blocks = Block
        .for_groups(group_ids)
        .overlapped(block_start_date, block_end_date).count
      blocks_count = room_blocks + lecturer_blocks + group_blocks
      if blocks_count > 0
        errors.add(:base, I18n.t("error_overlapped_block",
          block_date_range: "#{block_start_date.strftime("%D %R")}
          - #{block_end_date.strftime("%R")}"))
        return false
      end
    end

end
