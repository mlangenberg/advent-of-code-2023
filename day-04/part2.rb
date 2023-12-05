all_numbers = /: ([\d ]+)\|([\d ]+)/

cards = ARGF.to_a
            .map do |line|
              line.scan(all_numbers)
                  .map { |numbers| numbers.map(&:split) }.flatten(1)
            end

card_copies = Array.new(cards.size, 0)

cards.each_with_index do |(winning, mine), index|
  (winning & mine).size.times do |i|
    card_copies[index + i + 1] += card_copies[index] + 1
  end
end

puts cards.size + card_copies.sum
