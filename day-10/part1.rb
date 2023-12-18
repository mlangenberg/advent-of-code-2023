class Maze
  UP = [-1, 0]
  DOWN = [1, 0]
  LEFT =  [0, -1]
  RIGHT = [0, 1]
  MOVES = [UP, DOWN, LEFT, RIGHT]
  NEXT_MOVES = {
    UP => [UP, LEFT, RIGHT],
    DOWN => [DOWN, LEFT, RIGHT],
    LEFT => [LEFT, UP, DOWN],
    RIGHT => [RIGHT, UP, DOWN]
  }

  attr_reader :steps

  def initialize(tiles)
    @tiles = tiles
    @pos_y = tiles.find_index { _1.include?('S') }
    @pos_x = tiles[@pos_y].index('S')
    @direction = MOVES.find { valid_move?(_1) }
    @steps = 0
  end

  def determine_direction
    @direction = NEXT_MOVES[@direction].find { valid_move?(_1) }
  end

  def valid_move?(move)
    next_pos = [[@pos_y, @pos_x], move].transpose.map(&:sum)
    next_value = @tiles[next_pos[0]][next_pos[1]] rescue '.'
    case move
    when UP
      %w[| 7 F].include?(next_value)
    when DOWN
      %w[| L J].include?(next_value)
    when LEFT
      %w[- L F].include?(next_value)
    when RIGHT
      %w[- J 7].include?(next_value)
    else
      false
    end
  end

  def move
    @steps += 1

    p [[@pos_y, @pos_x], @direction]

    @pos_y, @pos_x = [[@pos_y, @pos_x], @direction].transpose.map(&:sum)
  end

  def current_tile
    @tiles[@pos_y][@pos_x]
  end
end

maze = Maze.new(ARGF.readlines.map(&:chomp))
maze.move
until maze.current_tile == 'S'
  print maze.current_tile
  maze.determine_direction
  maze.move
  puts " => #{maze.current_tile}"
end
puts maze.steps
