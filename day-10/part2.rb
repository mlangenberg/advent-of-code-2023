class Maze
  UP = [-1, 0].freeze
  DOWN = [1, 0].freeze
  LEFT =  [0, -1].freeze
  RIGHT = [0, 1].freeze
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

  def initialize(tiles)
    @tiles = tiles
    @pos_y = tiles.find_index { _1.include?('S') }
    @pos_x = tiles[@pos_y].index('S')
    @direction, = TILES_FOR_START_MOVE.find { |move, tiles| tiles.include?(next_tile(move)) }
    @steps = [] << [@pos_x, @pos_y]
  end

  def move
    @pos_y, @pos_x = next_position
    @steps << [@pos_x, @pos_y]
    @direction = NEXT_MOVES[@direction].fetch(current_tile, @direction)
  end

  def current_tile = @tiles.dig(@pos_y, @pos_x)

  def next_tile(move) = @tiles.dig(*next_position(move))

  def next_position(move = @direction) = [[@pos_y, @pos_x], move].transpose.map(&:sum)

  # Shoelace formula
  def enclosed_tiles_count
    sum = @steps.each_cons(2).sum do |(x1, y1), (x2, y2)|
      (x1 * y2) - (x2 * y1)
    end
    (sum / 2) - ((@steps.size / 2) - 1)
  end
end

maze = Maze.new(ARGF.readlines.map(&:chomp).map(&:chars))
maze.move
maze.move until maze.current_tile == 'S'
puts maze.enclosed_tiles_count
