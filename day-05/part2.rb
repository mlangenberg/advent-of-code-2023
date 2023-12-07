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
      puts "INPUT: #{range}"
      puts "OUTPUT: #{output}"
    end
  end

  def cover?(number)
    (src_start...(src_start + length)).cover?(number)
  end

  def begin = src_start
  def end = src_start + length - 1
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
      if current.begin < range.begin
        puts "Unmodified start #{(current.begin...range.begin)}"
        output << (current.begin...range.begin)
        current = range.begin..current.end
      end
      overlap = [current.begin, range.begin].max..[current.end, range.end].min
      if overlap.begin <= overlap.end
        puts "Match with #{range} (#{overlap})"
        output << range.convert(overlap)
      end
      current = (range.end + 1)..current.end if range.end >= current.begin
    end
    output << current if current.begin <= current.end
    output.sort_by(&:begin).tap { puts "\tReturning #{_1}" }
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

# locations = seed_ranges.map do |seeds|
#   puts "***************************"
#   lowest_location = Float::INFINITY

#   ranges = [seeds]
#   categories[...-1].each_with_index do |category, index|
#     map = maps["#{category}-to-#{categories[index + 1]}"]
#     puts "Using #{category} to #{categories[index + 1]}"
#     ranges = ranges.map do |range|
#       map[range]
#     end.flatten
#   end

#   lowest_location = ranges.map(&:begin).min if ranges.map(&:begin).min < lowest_location
#   lowest_location
# end
# puts locations.min
puts
puts maps["humidity-to-location"][1257741823..1384364697].inspect
