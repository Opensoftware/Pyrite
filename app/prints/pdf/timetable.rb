class Pdf::Timetable < Prawn::Document

  include ApplicationHelper

  def initialize(options = {})
    super({:top_margin => 25, :page_size => "A4"})
    @subtitle = Settings.pdf_subtitle
    @width = bounds.right
    @height = bounds.top
    @timetable_height = @height - 45
    @hours_column_size = 50
    @timetable_width = @width - @hours_column_size
    @column_size = @timetable_width/@available_days.count
    @title_row_size = 20
    # TODO fetch start_hour and end_hour from settings
    @start_hour = Time.parse("6:00")
    @end_hour = Time.parse("22:00")

    diff = @end_hour - @start_hour
    @hour_slices = diff / 3600
    @minute_slices = diff / 900 # 15 minute slices

    @timetable_content_height = @timetable_height - @title_row_size
    @hour_row = @timetable_content_height/@hour_slices
    # TODO size of the rows should be much more elastic not tide to 15 minutes
    # blocks, and should be linked with fullcalendar options.
    @minute_row = @hour_row/4
  end


  def to_pdf
    set_font_family
    @collection.each_with_index do |object, index|
      blocks = object.blocks.for_event(@event_id)
      draw_logo_with_title(object.pdf_title)
      draw_timetable(blocks)
      if index+1 != @collection.size
        start_new_page
      end
    end
    render
  end

  private

    def draw_logo_with_title(title)
      font_size 14
      bounding_box [bounds.left, bounds.top + 10], :width  => bounds.width do
        image "#{Rails.root}/app/assets/images/pyrite_large.png", :scale => 0.4
      end
      text_box "#{I18n.t("title_system_name")}", :at => [ bounds.left + 45, bounds.top - 5]
      font_size 8
      text_box "#{@subtitle}", :at => [ bounds.left + 45, bounds.top - 22]
      if title.present?
        font_size 11
        text_box "#{title}", :align => :center, :at => [0, @height - 30]
      end
    end

    def set_font_family
      font_families.update("DejaVuSans" => {
          :normal => { :file => "#{Rails.root}/app/assets/fonts/DejaVuSans.ttf" },
          :bold => { :file => "#{Rails.root}/app/assets/fonts/DejaVuSans-Bold.ttf" },
          :italic => { :file => "#{Rails.root}/app/assets/fonts/DejaVuSans-Oblique.ttf" }
      })
      font "DejaVuSans"
    end

    def draw_timetable(blocks)
      bounding_box [0, @timetable_height], :width => @width, :height => @timetable_height do
        timetable_header
        timetable_hours_column
        draw_helper_lines
        draw_borders
        draw_blocks(blocks)
      end
    end

    def timetable_header
      font_size 9
      bounding_box [0, @timetable_height], :width => @hours_column_size, :height => @title_row_size do
        stroke_bounds
        text_box I18n.t("pyrite.pdf.label.hours"), :align => :center, :valign => :center
      end
      bounding_box [@hours_column_size, @timetable_height], :width => @width do
        @available_days.each_with_index do |day, index|
          bounding_box [index * @column_size, bounds.top], :width => @column_size, :height => @title_row_size do
            stroke_bounds
            text_box day, :align => :center, :valign => :center
          end
        end
      end
    end

    def timetable_hours_column
      font_size 5
      @hour_slices.to_i.times do |index|
        bounding_box [0, @timetable_content_height - index*@hour_row], :width => @hours_column_size, :height => @hour_row do
          stroke_bounds
          from_hour = (@start_hour + index.hours).strftime("%H:%M")
          to_hour = (@start_hour + (index+1).hours).strftime("%H:%M")
          text_box "#{from_hour} - #{to_hour}", :align => :center, :valign => :center
        end
      end
    end

    def draw_helper_lines
      transparent(0.3) do
        @minute_slices.to_i.times do |index|
          stroke_horizontal_line @hours_column_size, @width, :at => index* @minute_row
        end
      end
    end

    def draw_borders
      stroke_horizontal_line 0, @width, :at => 0
      @available_days.count.times do |index|
        stroke_vertical_line 0, @timetable_height, :at => @hours_column_size + @column_size * (index+1)
      end
    end

    # return position of the column for the block base on the day
    # Day of the week in 0-6. Sunday is 0; Saturday is 6.
    def column_position(block)
      case block.dates.first.start_date.wday
        when 1
          return @hours_column_size
        when 2
          return @hours_column_size + @column_size
        when 3
          return @hours_column_size + @column_size * 2
        when 4
          return @hours_column_size + @column_size * 3
        when 5
          return @hours_column_size + @column_size * 4
        when 6
          return @hours_column_size + @column_size * 5
        when 0
          return @hours_column_size + @column_size * 6
      end
    end


end
