class Maze
  UP = [-1, 0]
  DOWN = [1, 0]
  LEFT =  [0, -1]
  RIGHT = [0, 1]
  MOVES = [UP, DOWN, LEFT, RIGHT]
  NEXT_MOVES = {
    UP => { '7' => LEFT, 'F' => RIGHT },
    DOWN => { 'L' => RIGHT, 'J' => LEFT },
    LEFT => { 'L' => UP, 'F' => DOWN },
    RIGHT => { 'J' => UP, '7' => DOWN }
  }

  attr_reader :steps

  def initialize(tiles)
    @tiles = tiles
    @pos_y = tiles.find_index { _1.include?('S') }
    @pos_x = tiles[@pos_y].index('S')
    @direction = MOVES.find { valid_start_move?(_1) }
    @steps = 0
  end

  def valid_start_move?(move)
    next_pos = [[@pos_y, @pos_x], move].transpose.map(&:sum)
    next_value = @tiles.dig(*next_pos) || '.'
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
    @pos_y, @pos_x = [[@pos_y, @pos_x], @direction].transpose.map(&:sum)
    @direction = NEXT_MOVES[@direction].fetch(current_tile, @direction)
  end

  def current_tile
    @tiles.dig(@pos_y, @pos_x)
  end
end

maze = Maze.new(ARGF.readlines.map(&:chomp).map(&:chars))
maze.move
until maze.current_tile == 'S'
  maze.move
end
puts maze.steps
