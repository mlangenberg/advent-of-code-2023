sum = 0
DIGITS = %w(one two three four five six seven eight nine)
  .map.with_index { |string, index| [string, "#{index+1}"] }.to_h
  .merge(("1".."9").map { [_1, _1] }.to_h)

DIGITS_REGEX = Regexp.new("(#{DIGITS.keys.join("|")})")

ARGF.each_line do |line|
  first_digit = line[DIGITS_REGEX]

  # searches right to left for first match 
  last_digit = nil
  line.length.downto(0) do |i|
    break if last_digit = line[i, line.length][DIGITS_REGEX]
  end

  number = "#{DIGITS[first_digit]}#{DIGITS[last_digit]}".to_i
  sum += number 
end

puts "sum: #{sum}"