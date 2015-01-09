module Pyrite
  class Block < ActiveRecord::Base

    # NOTICE: we have to require it here due to fact how ruby/rails load the files
    # Read more at: http://stackoverflow.com/a/17699275/421860
    # The problem is with the name of the class Date
    require 'pyrite/block/date'

    include UsiLogger
    has_many :blocks_rooms
    has_many :rooms, :through => :blocks_rooms
    has_many :blocks_lecturers
    has_many :lecturers, :through => :blocks_lecturers
    belongs_to :event, :class_name => "AcademicYear::Event"
    belongs_to :meeting, :class_name => "AcademicYear::Meeting"
    belongs_to :variant, :class_name => "Block::Variant"
    has_many :dates, :dependent => :destroy, :autosave => true
    belongs_to :subject

    has_many :groups, :through => :blocks_groups
    has_many :blocks_groups, :dependent => :destroy

    attr_accessor :day, :start_time, :end_time, :day_with_date, :start_date, :end_date,
                  :custom_block_dates, :date_range

    # TODO split saving reservation and standard blocks
    # event_id for block/new is required

    before_validation :generate_date_range
    before_create :populate_dates

    scope :for_groups, ->(group_ids) { joins(:blocks_groups).where("#{BlocksGroup.table_name}.group_id" => group_ids) }
    scope :for_event, ->(event_id) { event_id.present? ? where(:event_id => event_id) : where(nil) }
    scope :for_meeting, ->(meeting_id) { meeting_id.present? ? where(:meeting_id => meeting_id) : where(nil) }
    scope :for_lecturers, ->(lecturer_ids) {
      joins(:blocks_lecturers).where("#{BlocksLecturer.table_name}.lecturer_id" => lecturer_ids)
    }
    scope :for_rooms, ->(room_ids) {
      joins(:blocks_rooms).where("#{BlocksRoom.table_name}.room_id" => room_ids)
    }
    scope :reservations, -> { where(:reservation => true).where(:event_id => nil) }
    scope :overlapped, ->(start_date, end_date) {
      joins(:dates).where("#{Pyrite::Block::Date.table_name}.start_date < ? AND
                          #{Pyrite::Block::Date.table_name}.end_date > ?", end_date , start_date)
    }
    scope :for_day, ->(day) { joins(:dates).where("#{Pyrite::Block::Date.table_name}.start_date > ? AND
                                                  #{Pyrite::Block::Date.table_name}.end_date < ?",
                                                  day.beginning_of_day, day.end_of_day) }
    scope :except_me, ->(block) { where.not(id: block) }

    validates :start_time, :end_time, :presence => true, :on => :create
    validates :room_ids, :presence => true
    validate :validate_times, :on => :create
    validate :validate_day, :on => :create
    validate :validate_custom_dates, :on => :create, :if => Proc.new {|block| block.custom_block_dates.present? }
    validate :check_collisions, :on => :create

    def name
      subject.try(:name).to_s
    end

    def lecturer_name
      lecturers.map(&:full_name).join("<br>")
    end

    def group_names
      groups.map {|g| g.name }.join(" ")
    end

    def rooms_names
      rooms.map {|r| r.name_with_building }.join(" ")
    end

    def variant_name
      variant.try(:short_name).to_s
    end

    def move_to(day_delta, minute_delta)
      # convert days to minutes and create one minute delta
      delta = (minute_delta + day_delta * 1440).minutes
      # set start_time, end_time and day_with_date for check collisions purpose
      self.start_time = (dates.first.start_date + delta).strftime("%H:%M")
      self.end_time = (dates.first.end_date + delta).strftime("%H:%M")
      self.day_with_date = (dates.first.start_date + delta).strftime("%d-%m-%Y")
      dates.each do |date|
        date.start_date += delta
        date.end_date += delta
      end
      self.date_range = dates.map(&:start_date)
      save if check_collisions
    end

    def resize(day_delta, minute_delta)
      # convert days to minutes and create one minute delta
      delta = (minute_delta + day_delta * 1440).minutes
      # set start_time, end_time and day_with_date for check collisions purpose
      self.start_time = dates.first.start_date.strftime("%H:%M")
      self.end_time = (dates.first.end_date + delta).strftime("%H:%M")
      self.day_with_date = dates.first.start_date.strftime("%d-%m-%Y")
      dates.each do |date|
        date.end_date += delta
      end
      self.date_range = dates.map(&:start_date)
      save if check_collisions
    end

    private

      def prepare_hours
        @start_hour, @start_min = start_time.split(":").map(&:to_i)
        @end_hour, @end_min = end_time.split(":").map(&:to_i)
      end

      def populate_dates
        begin
          prepare_hours
          date_range.each do |date|
            block_start_date = Time::mktime(date.year, date.month, date.day, @start_hour, @start_min)
            block_end_date = Time::mktime(date.year, date.month, date.day, @end_hour, @end_min)
            dates.build(:start_date => block_start_date, :end_date => block_end_date)
          end
        rescue => e
          errors.add(:base, I18n.t("pyrite.error.internal_error"))
          params = {:day => day,
                    :date_range => date_range
          }
          usi_logger e, params
          return false
        end
      end

      def prepare_date_range_for_event
        dates = []
        day = Time.zone.parse(day_with_date).wday
        lecture_free = AcademicYear::Event.lecture_free_date_range
        date_range = (event.start_date.to_datetime..event.end_date.to_datetime).select {|date| day == date.wday }
        dates = date_range - lecture_free
        dates
      end

      def prepare_date_range
        dates = []
        dates << Time.zone.parse(day_with_date)
        dates
      end

      def prepare_custom_date_range
        dates = []
        custom_block_dates.split(",").each do |date|
          dates << Time.zone.parse(date)
        end
        dates
      end

      def generate_date_range
        if custom_block_dates.present?
          self.date_range = prepare_custom_date_range
        else
          if event_id.present?
            self.date_range = prepare_date_range_for_event
          else
            self.date_range = prepare_date_range
          end
        end
      end

      def validate_custom_dates
        begin
          custom_block_dates.split(",").each do |date|
            Time.zone.parse(date)
            throw unless /\d{4}\/\d{2}\/\d{2}/ =~ date
          end
        rescue => e
          errors.add(:base, I18n.t("pyrite.error.block.invalid_custom_dates"))
          return false
        end
      end

      def validate_times
        begin
          if Time.zone.parse(start_time) > Time.zone.parse(end_time)
            errors.add(:start_time, I18n.t("error_must_be_lower_then_end_time"))
          end
        rescue => e
          errors.add(:base, I18n.t("pyrite.error.internal_error"))
          params = {:start_time => start_time,
                    :end_time => end_time
          }
          usi_logger e, params
          return false
        end
      end

      def validate_day
        if day_with_date.blank?
          errors.add(:day, I18n.t("error_day_not_present"))
        else
          begin
            Time.zone.parse(day_with_date)
          rescue => e
            errors.add(:base, I18n.t("pyrite.error.internal_error"))
            params = {:day_with_date => day_with_date }
            usi_logger e, params
            return false
          end
        end
      end

      def check_collisions
        begin
          prepare_hours
          date_range.each do |date|
            block_start_date = Time::mktime(date.year, date.month, date.day, @start_hour, @start_min)
            block_end_date = Time::mktime(date.year, date.month, date.day, @end_hour, @end_min)
            return false unless check_blocks_collisions(block_start_date, block_end_date)
          end
        rescue => e
          errors.add(:base, I18n.t("pyrite.error.internal_error"))
          params = {:event_id => event_id,
                    :day_with_date => day_with_date,
                    :day => day
          }
          usi_logger e, params
          return false
        end

      end

      def check_blocks_collisions(block_start_date, block_end_date)
        room_blocks = Block
          .for_rooms(room_ids)
          .except_me(self)
          .overlapped(block_start_date, block_end_date).count
        if lecturer_ids.blank?
          lecturer_blocks = []
        else
          lecturer_blocks = Block
            .for_lecturers(lecturer_ids)
            .except_me(self)
            .overlapped(block_start_date, block_end_date)
        end
        group_blocks = Block
          .for_groups(group_ids)
          .except_me(self)
          .overlapped(block_start_date, block_end_date).count

        if room_blocks > 0
          error = I18n.t("error_room_block_collision", :room => rooms_names)
        elsif lecturer_blocks.count > 0
          rooms = lecturer_blocks.first.rooms_names
          groups = lecturer_blocks.first.group_names
          error = I18n.t("error_lecturer_block_collision", :lecturer => lecturer_name, :room => rooms, :groups => groups )
        elsif group_blocks > 0
          error = I18n.t("error_groups_block_collision", :groups => group_names)
        end
        if error
          errors.add(:base, I18n.t("error_overlapped_block", block: error))
          return false
        else
          return true
        end
      end

  end
end
