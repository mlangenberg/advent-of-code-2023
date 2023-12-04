Game = Struct.new(:id, :subsets) do 
  def possible?(bag)
    subsets.all? { _1.possible?(bag) }
  end
end
Subset = Struct.new(:red, :green, :blue) do
  def possible?(bag)
    red <= bag.red && green <= bag.green && blue <= bag.blue
  end
end

bag = Subset.new(12, 13, 14)

def parse(line)
  line =~ /Game (\d+): (.+)/ 
  Game.new(
    id: $1.to_i,
    subsets: $2.split('; ').map { parse_subset(_1) }
  )
end

def parse_subset(input)
  Subset.new(0, 0, 0).tap do |subset|
    input.split(', ').each do |cubes|
      cubes =~ /(\d+) (\w+)/
      subset.send("#{$2}=", $1.to_i)
    end
  end
end

games = []
ARGF.each_line do |line|
  games << parse(line)
end
puts games.select { _1.possible?(bag) }.map(&:id).sum