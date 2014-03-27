class Block < ActiveRecord::Base
  belongs_to :room
  belongs_to :lecturer
  belongs_to :event, :class_name => "AcademicYear::Event"
  belongs_to :meeting, :class_name => "AcademicYear::Meeting"
  belongs_to :type, :class_name => "Block::Variant"
  has_many :dates, :dependent => :destroy

  has_many :groups, :through => :blocks_groups
  has_many :blocks_groups, :dependent => :destroy

  attr_accessor :day, :start_time, :end_time, :day_with_date, :start_date, :end_date

  # TODO split saving reservation and standard blocks
  # event_id for block/new is required

  before_create :populate_dates_for_event, :if => Proc.new { |block| block.event_id.present? }
  before_create :populate_dates, :if => Proc.new { |block| block.meeting_id.present? }

  scope :for_groups, ->(group_ids) { joins(:blocks_groups).where("#{BlocksGroup.table_name}.group_id" => group_ids) }
  scope :for_event, ->(event_id) { event_id.present? ? where(:event_id => event_id) : self.scoped }
  scope :reservations, -> { where(:reservation => true).where(:event_id => nil) }
  scope :overlapped, ->(start_date, end_date) {
    joins(:dates).where("block_dates.start_date < ? AND
                         block_dates.end_date > ?", end_date , start_date)
  }

  validates :start_time, :end_time, :presence => true, :on => :create
  validates :name, :room, :presence => true
  validate :validate_times, :on => :create
  validate :validate_day, :on => :create
  validate :check_collisions, :on => :create

  def populate_dates
    begin
      prepare_hours
      block_date = Time.zone.parse(day_with_date)
      block_start_date = block_date.advance(:hours => @start_hour, :minutes => @start_min)
      block_end_date = block_date.advance(:hours => @end_hour, :minutes => @end_min)
      dates.build(:start_date => block_start_date, :end_date => block_end_date)
    rescue => e
      # TODO logger
      return false
    end
  end

  def populate_dates_for_event
    begin
      prepare_hours
      date_range = (event.start_date.to_datetime..event.end_date.to_datetime).select {|date| day.to_i == date.wday }
      date_range.each do |date|
        block_start_date = Time::mktime(date.year, date.month, date.day, @start_hour, @start_min)
        block_end_date = Time::mktime(date.year, date.month, date.day, @end_hour, @end_min)
        dates.build(:start_date => block_start_date, :end_date => block_end_date)
      end
    rescue => e
      # TODO logger
      return false
    end
  end

  def save_reservation
    self.reservation = true
    populate_dates
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

    def prepare_hours
      @start_hour, @start_min = start_time.split(":").map(&:to_i)
      @end_hour, @end_min = end_time.split(":").map(&:to_i)
    end

    def validate_times
      begin
        if Time.zone.parse(start_time) > Time.zone.parse(end_time)
          errors.add(:start_time, I18n.t("error_must_be_lower_then_end_time"))
        end
      rescue => e
        # TODO logger
        return false
      end
    end

    def validate_day
      if day.blank? and day_with_date.blank?
        errors.add(:day, I18n.t("error_day_not_present"))
      end
    end

    def check_collisions
      begin
        prepare_hours
        if event_id.nil?
          # This will happen only for reservation
          block_date = Time.zone.parse(day_with_date)
          block_start_date = block_date.advance(:hours => @start_hour, :minutes => @start_min)
          block_end_date = block_date.advance(:hours => @end_hour, :minutes => @end_min)
          check_blocks_collisions(block_start_date, block_end_date)
        else
          date_range = (event.start_date.to_datetime..event.end_date.to_datetime).select { |date|
            day.to_i == date.wday
          }
          date_range.each do |date|
            block_start_date = Time::mktime(date.year, date.month, date.day,
                                            @start_hour, @start_min)
            block_end_date = Time::mktime(date.year, date.month, date.day,
                                          @end_hour, @end_min)
            return false unless check_blocks_collisions(block_start_date, block_end_date)
          end
        end
      rescue => e
        # TODO logger
        puts e
        errors.add(:base, I18n.t("error_internal_error"))
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

      if room_blocks > 0
        error = I18n.t("error_room_block_collision", :room => room.name)
      elsif lecturer_blocks > 0
        error = I18n.t("error_lecturer_block_collision", :lecturer => lecturer_name)
      elsif group_blocks > 0
        error = I18n.t("error_groups_block_collision", :groups => groups_names)
      end
      if error
        errors.add(:base, I18n.t("error_overlapped_block", block: error))
        return false
      end
    end

end
