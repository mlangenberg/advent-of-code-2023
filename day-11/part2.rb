Point = Data.define(:x, :y)
galaxies = []
empty_rows = []
ARGF.each_with_index do |line, y|
  if line.include?('#')
    line.scan('#') { galaxies << Point[Regexp.last_match.begin(0), y] }
  else
    empty_rows << y
  end
end

empty_columns = (0...galaxies.map(&:x).max).reject do |x|
  galaxies.any? { _1.x == x }
end

galaxies.map! do |galaxy|
  Point[
    galaxy.x + (empty_columns.count { _1 < galaxy.x } * 999_999),
    galaxy.y + (empty_rows.count { _1 < galaxy.y } * 999_999)
  ]
end

distance = galaxies.combination(2).sum do |from, to|
  ((from.x - to.x).abs + (from.y - to.y).abs)
end
puts distance
