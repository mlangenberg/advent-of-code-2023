schematic = ARGF.readlines.map(&:chomp)

Number = Data.define(:row, :start, :end, :value)
numbers = []

schematic.each_with_index do |row, row_number|
  row.scan(/\d+/) do |number|
    numbers << Number.new(row_number, $~.begin(0), $~.end(0) - 1, number.to_i)
  end
end

part_numbers = numbers.select do |number|
  puts "Checking for #{number.value}"
  min_row = number.row.zero? ? 0 : number.row - 1
  max_row = number.row + 1 == schematic.size ? number.row : number.row + 1
  min_col = number.start.zero? ? 0 : number.start - 1
  max_col = number.end + 1 == schematic.first.size ? number.end : number.end + 1

  is_valid = false
  min_row.upto(max_row).each do |row|
    break if is_valid

    min_col.upto(max_col).each do |col|
      symbol = schematic[row][col]
      next if symbol == '.' || symbol =~ /\d/

      puts "#{number.value} is parts number, adjacent to '#{schematic[row][col]}'"
      is_valid = true
      break
    end
  end
  is_valid
end

puts "Sum: #{part_numbers.sum(&:value)}"
