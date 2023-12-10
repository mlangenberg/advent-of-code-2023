time, record = ARGF.readlines.map { _1.scan(/\d/).join.to_i }
discriminant = Math.sqrt((time**2) - 4 * record)
t_min = (time - discriminant) / 2
t_max = (time + discriminant) / 2
puts t_max.ceil - t_min.ceil