module BlocksHelper
  def convert_blocks_to_events(blocks)
    events = []
    blocks.each do |block|
      events << { id: block.id, title: block.name, start: block.start, end: block.end, allDay: false}
    end
    return events
  end
end
