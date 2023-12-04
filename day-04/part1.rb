all_numbers = /: ([\d ]+)\|([\d ]+)/

puts ARGF.readlines
         .map { _1.chomp.scan(all_numbers).map { |numbers| numbers.map(&:split) }.flatten(1) }
         .map { |winning, mine| 1 * (2**((winning & mine).size - 1)).floor }.sum
