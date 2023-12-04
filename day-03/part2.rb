schematic = ARGF.readlines.map { _1.chomp.chars }

class Range
  def overlaps?(other)
    cover?(other.first) || other.cover?(first)
  end
end

Number = Data.define(:row, :start, :end, :value)
Gear = Data.define(:row, :col)
numbers = []
gears = []

schematic.each_with_index do |row, row_number|
  row.join.scan(/\d+/) do |number|
    numbers << Number.new(row_number, $~.begin(0), $~.end(0) - 1, number.to_i)
  end
  row.each_with_index do |symbol, column_number|
    gears << Gear.new(row_number, column_number) if symbol == '*'
  end
end


gear_to_numbers = Hash.new { |h,k| h[k] = [] }

gears.each do |gear|
  puts "Checking gear #{gear.inspect}"

  min_row = gear.row.zero? ? 0 : gear.row - 1
  max_row = gear.row + 1 == schematic.size ? gear.row : gear.row + 1
  min_col = gear.col.zero? ? 0 : gear.col - 1
  max_col = gear.col + 1 == schematic.first.size ? gear.col : gear.col + 1
    
  numbers.each do |number|
    if (min_row..max_row).include?(number.row) && (number.start..number.end).overlaps?(min_col..max_col)
      puts [number.start, number.end, min_col, max_col].inspect
      gear_to_numbers[gear] << number
    end
  end

  true
end

puts gear_to_numbers.keep_if { |_, numbers| numbers.size == 2 }.values.map { _1.map(&:value).reduce(:*) }.sum
