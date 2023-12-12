def extrapolate(values)
  unless values.all?(&:zero?)
    values << (values.last + extrapolate(values.each_cons(2).map { |a, b| b - a }).last)
  end
  values
end

sum = ARGF.readlines.map do |line|
  values = line.scan(/-?\d+/).map(&:to_i)
  extrapolate(values).last
end.sum

puts sum
