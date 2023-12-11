instructions = ARGF.readline.chomp.chars.map { _1 == 'L' ? 0 : 1 }
ARGF.readline # skip empty line
nodes = {}
ARGF.readlines.each do |line|
  element, left, right = line.scan(/\w+/)
  nodes[element] = [left, right]
end

steps = nodes.keys.select { _1.end_with?('A') }.map do |current|
  steps = 0
  instructions = instructions.cycle
  until current.end_with?('Z')
    steps += 1
    current = nodes[current][instructions.next]
  end
  steps
end
puts steps.reduce(:lcm)
