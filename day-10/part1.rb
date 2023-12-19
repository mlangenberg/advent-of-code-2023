class Maze
  UP = [-1, 0].freeze
  DOWN = [1, 0].freeze
  LEFT =  [0, -1].freeze
  RIGHT = [0, 1].freeze
  MOVES = [UP, DOWN, LEFT, RIGHT].freeze
  NEXT_MOVES = {
    UP => { '7' => LEFT, 'F' => RIGHT },
    DOWN => { 'L' => RIGHT, 'J' => LEFT },
    LEFT => { 'L' => UP, 'F' => DOWN },
    RIGHT => { 'J' => UP, '7' => DOWN }
  }.freeze
  TILES_FOR_START_MOVE = {
    UP => %w[| 7 F],
    DOWN => %w[| L J],
    LEFT => %w[- L F],
    RIGHT => %w[- J 7]
  }.freeze
  attr_reader :steps

  def initialize(tiles)
    @tiles = tiles
    @pos_y = tiles.find_index { _1.include?('S') }
    @pos_x = tiles[@pos_y].index('S')
    @direction = MOVES.find { TILES_FOR_START_MOVE.fetch(_1, []).include?(next_tile(_1)) }
    @steps = 0
  end

  def move
    @steps += 1
    @pos_y, @pos_x = next_position
    @direction = NEXT_MOVES[@direction].fetch(current_tile, @direction)
  end

  def current_tile
    @tiles.dig(@pos_y, @pos_x)
  end

  def next_tile(move)
    @tiles.dig(*next_position(move))
  end

  def next_position(move = @direction)
    [[@pos_y, @pos_x], move].transpose.map(&:sum)
  end
end

maze = Maze.new(ARGF.readlines.map(&:chomp).map(&:chars))
maze.move
maze.move until maze.current_tile == 'S'
puts maze.steps
