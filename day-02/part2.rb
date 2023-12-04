Game = Struct.new(:id, :subsets) do
  def bag
    Subset.new(0, 0, 0).tap do |minimal|
      minimal.red = subsets.map(&:red).max
      minimal.green = subsets.map(&:green).max
      minimal.blue = subsets.map(&:blue).max
    end
  end
end
Subset = Struct.new(:red, :green, :blue) do
  def power = red * green * blue
end

def parse(line)
  line =~ /Game (\d+): (.+)/
  Game.new(
    id: Regexp.last_match(1).to_i,
    subsets: Regexp.last_match(2).split('; ').map { parse_subset(_1) }
  )
end

def parse_subset(input)
  Subset.new(0, 0, 0).tap do |subset|
    input.split(', ').each do |cubes|
      cubes =~ /(\d+) (\w+)/
      subset.send("#{Regexp.last_match(2)}=", Regexp.last_match(1).to_i)
    end
  end
end

games = []
ARGF.each_line do |line|
  games << parse(line)
end

puts games.map { _1.bag.power }.sum
