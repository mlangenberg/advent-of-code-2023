sum = 0
ARGF.each_line do |line|
	number = line.scan(/\d/).then { |digits| "#{digits.first}#{digits.last}".to_i }
  puts "Adding: #{number}"
  sum += number 
end

puts "\nsum: #{sum}"