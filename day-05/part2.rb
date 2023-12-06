MapRange = Data.define(:dest_start, :src_start, :length) do
  def convert(number)
    dest_start - src_start + number
  end

  def cover?(number)
    (src_start...(src_start + length)).cover?(number)
  end
end

Map = Struct.new(:ranges) do
  def [](number)
    if (range = ranges.find { _1.cover?(number) })
      range.convert(number)
    else
      number
    end
  end
end

sections = ARGF.read.split("\n\n")
seed_ranges = sections.shift.split(':').last.split.map(&:to_i)
                      .each_slice(2).map { |start, length| (start...start + length) }

maps = {}
sections.each do |section|
  lines = section.split("\n")
  map_name = lines.shift.gsub(' map:', '')
  maps[map_name] = Map.new(lines.map { MapRange.new(*_1.split.map(&:to_i)) })
end

categories = %w[seed soil fertilizer water light temperature humidity location]

locations = seed_ranges.map do |seeds|
  Ractor.new(seeds, categories, maps) do |seeds, categories, maps|
    lowest_location = Float::INFINITY
    seeds.each do |seed|
      number = seed
      categories.each_with_index do |category, index|
        if (map = maps["#{category}-to-#{categories[index + 1]}"])
          number = map[number]
        end
      end
      lowest_location = number if number < lowest_location
    end
    lowest_location
  end
end
puts locations.map(&:take).min
