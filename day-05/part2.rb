class Range
  def overlaps?(other)
    cover?(other.first) || other.cover?(first)
  end
end

MapRange = Data.define(:dest_start, :src_start, :length) do
  def convert(range)
    Range.new(
      dest_start - src_start + range.begin,
      dest_start - src_start + range.end
    ).tap do |output|
      # puts "INPUT: #{range}"
      # puts "OUTPUT: #{output}"
    end
  end

  def begin = src_start
  def end = src_start + length - 1
  def delta
    i = dest_start - src_start
    i.positive? ? "+#{i}" : i.to_s
  end
end

# 20..100
# range 30..150

# 20...30
# 30...100

# 20..200
# range 30..150
#
# 20...30
# 30..150
# 151..200

Map = Struct.new(:ranges) do
  def [](number_range)
    puts "\tCalled with #{number_range}"
    current = number_range
    output = []
    ranges.sort_by(&:begin).each do |range|
      break if current.end < range.begin

      if current.begin < range.begin
        print "H<#{current.begin..range.begin - 1}> "
        output << (current.begin..range.begin - 1)
        current = range.begin..current.end
      end
      overlap = [current.begin, range.begin].max..[current.end, range.end].min
      if overlap.begin <= overlap.end
        output << range.convert(overlap).tap { |output| print "M<#{overlap}> " }
      end
      if range.end >= current.begin
        current = (range.end+1)..current.end
      end
    end
    if current.begin <= current.end
      print "T<#{current}> "
      output << current
    else
      print "X<#{current}>"
    end
    puts
    output.sort_by(&:begin).tap { puts "\tReturning #{_1}" }
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

locations = seed_ranges.map do |seeds|
  puts "***************************"
  lowest_location = Float::INFINITY

  ranges = [seeds]
  categories[...-1].each_with_index do |category, index|
    map = maps["#{category}-to-#{categories[index + 1]}"]
    puts "Using #{category} to #{categories[index + 1]}"
    ranges = ranges.map do |range|
      map[range]
    end.flatten.sort_by(&:begin).tap { puts "> Output for next map: #{_1}\n" }
  end

  lowest_location = ranges.map(&:begin).min if ranges.map(&:begin).min < lowest_location
  lowest_location
end
puts
puts locations.min
puts


# puts maps["light-to-temperature"][(157606391..357109335)].inspect
