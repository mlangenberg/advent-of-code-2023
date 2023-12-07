MapRange = Data.define(:dest_start, :src_start, :length) do
  def convert(numbers)
    Range.new(
      dest_start - src_start + numbers.begin,
      dest_start - src_start + numbers.end
    )
  end

  def begin = src_start
  def end = src_start + length - 1
end

Map = Struct.new(:ranges) do
  def [](numbers)
    output = []
    ranges.sort_by(&:begin).each do |range|
      break if numbers.end < range.begin

      if numbers.begin < range.begin
        output << (numbers.begin..range.begin - 1)
        numbers = range.begin..numbers.end
      end
      overlap = [numbers.begin, range.begin].max..[numbers.end, range.end].min
      output << range.convert(overlap) if overlap.begin <= overlap.end
      numbers = (range.end + 1)..numbers.end if range.end >= numbers.begin
    end
    output << numbers if numbers.begin <= numbers.end
    output
  end
end

sections = ARGF.read.split("\n\n")
seed_ranges = sections.shift.split(':').last.split.map(&:to_i)
                      .each_slice(2).map { |start, length| (start..start + length - 1) }

maps = {}
sections.each do |section|
  lines = section.split("\n")
  map_name = lines.shift.gsub(' map:', '')
  maps[map_name] = Map.new(lines.map { MapRange.new(*_1.split.map(&:to_i)) })
end

categories = %w[seed soil fertilizer water light temperature humidity location]

seed_ranges.map do |seeds|
  ranges = [seeds]
  categories[...-1].each_with_index do |category, index|
    map = maps["#{category}-to-#{categories[index + 1]}"]
    ranges = ranges.map do |range|
      map[range]
    end.flatten
  end

  ranges.min_by(&:begin).begin
end.min.then { puts "Lowest location: #{_1}" }
