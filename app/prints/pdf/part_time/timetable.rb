require 'prawn'
class Pdf::PartTime::Timetable < Prawn::Document
  include PyriteHelper
  include Pyrite::PdfHelper

  def initialize(options = {})
    super({:top_margin => 25, :page_size => "A4"})
    @subtitle = Pyrite::Settings.pdf_subtitle
    @width = bounds.right
    @height = bounds.top
    @timetable_height = @height - 45
    @hours_column_size = 50
    @timetable_width = @width - @hours_column_size
    @title_row_size = 20
    # TODO fetch start_hour and end_hour from settings
    @start_hour = Time.parse("6:00")
    end_hour = Time.parse("22:00")

    diff = end_hour - @start_hour
    @hour_slices = diff / 3600
    @minute_slices = diff / 900 # 15 minute slices

    @timetable_content_height = @timetable_height - @title_row_size
    @hour_row = @timetable_content_height/@hour_slices
    # TODO size of the rows should be much more elastic not tide to 15 minutes
    # blocks, and should be linked with fullcalendar options.
    @minute_row = @hour_row/4
    @columns_positions = {}
  end


  def to_pdf
    set_font_family
    @collection.each_with_index do |object, index|
      @column_size = @timetable_width/@available_days[object.id].count
      blocks = object.blocks
      draw_logo_with_title(object.pdf_title, @subtitle, @height)
      draw_timetable(blocks, object.id)
      if index+1 != @collection.size
        start_new_page
      end
    end
    render
  end

  private

    def draw_timetable(blocks, meeting)
      bounding_box [0, @timetable_height], :width => @width, :height => @timetable_height do
        columns = @available_days[meeting].map { |day| day.strftime("%F") }
        timetable_header(columns)
        timetable_hours_column
        draw_helper_lines
        draw_borders(columns.count)
        draw_blocks(blocks, meeting)
      end
    end

    def timetable_header(columns)
      font_size 9
      bounding_box [0, @timetable_height], :width => @hours_column_size, :height => @title_row_size do
        stroke_bounds
        text_box I18n.t("pyrite.pdf.label.hours"), :align => :center, :valign => :center
      end
      bounding_box [@hours_column_size, @timetable_height], :width => @width do
        columns.each_with_index do |name, index|
          position = index * @column_size
          @columns_positions[name] = position + @hours_column_size
          bounding_box [position, bounds.top], :width => @column_size, :height => @title_row_size do
            stroke_bounds
            text_box name, :align => :center, :valign => :center
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

    def draw_borders(number_of_columns)
      stroke_horizontal_line 0, @width, :at => 0
      number_of_columns.times do |index|
        stroke_vertical_line 0, @timetable_height, :at => @hours_column_size + @column_size * (index+1)
      end
    end

end
