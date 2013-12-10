module BlocksHelper
  def convert_blocks_to_events(blocks)
    events = []
    blocks.each do |block|
      block.dates.each do |date|
        events << { id: block.id, title: block.name, start: date.start_date, end: date.end_date, allDay: false}
      end
    end
    return events
  end
end
