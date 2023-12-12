def extrapolate(values)
  unless values.all?(&:zero?)
    values.unshift(values.first - extrapolate(values.each_cons(2).map { |a, b| b - a }).first)
  end
  values
end

sum = ARGF.readlines.map do |line|
  values = line.scan(/-?\d+/).map(&:to_i)
  extrapolate(values).first
end.sum

puts sum
