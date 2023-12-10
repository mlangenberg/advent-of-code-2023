numbers = ARGF.readlines.map { _1.scan(/\d+/).map(&:to_i) }.transpose.map do |time, record|
  discriminant = Math.sqrt((time**2) - 4 * record)
  t_min = (time - discriminant) / 2
  t_max = (time + discriminant) / 2

  offset = [t_min, t_max].all? { _1 == _1.to_i } ? 1 : 0
  t_max.ceil - t_min.ceil - offset
end

puts numbers.reduce(:*)
