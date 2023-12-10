class Hand
  attr_reader :cards
  def initialize(cards)
    @cards = cards
  end

  TYPES = {
    five_of_a_kind: 7,
    four_of_a_kind: 6,
    full_house: 5,
    three_of_a_kind: 4,
    two_pair: 3,
    one_pair: 2,
    high_card: 1
  }

  def <=>(other)
    compared_type = type <=> other.type
    compared_type.zero? ? cards <=> other.cards : compared_type
  end

  def type
    case cards.tally.values.sort.reverse
    when [5] then TYPES[:five_of_a_kind]
    when [4, 1] then TYPES[:four_of_a_kind]
    when [3, 2] then TYPES[:full_house]
    when [3, 1, 1] then TYPES[:three_of_a_kind]
    when [2, 2, 1] then TYPES[:two_pair]
    when [2, 1, 1, 1] then TYPES[:one_pair]
    when [1, 1, 1, 1, 1] then TYPES[:high_card]
    end
  end

  def inspect
    "<#{type}> " + cards.map(&:label).join
  end
end

Card = Data.define(:label) do
  def <=>(other)
    value <=> other.value
  end

  def value
    case label
    when 'A' then 14
    when 'K' then 13
    when 'Q' then 12
    when 'J' then 11
    when 'T' then 10
    else label.to_i
    end
  end
end

bids = {}
hands = ARGF.readlines.map(&:split).map do |hand, bid|
  Hand.new(hand.chars.map { Card.new(_1) }).tap { bids[_1] = bid.to_i }
end

puts hands.sort.map.with_index { |hand, index| bids[hand] * (index + 1) }.sum
