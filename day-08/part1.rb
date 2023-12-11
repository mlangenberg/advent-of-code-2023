instructions = ARGF.readline.chomp.chars.map { _1 == 'L' ? 0 : 1 }.cycle
ARGF.readline # skip empty line
nodes = {}
ARGF.readlines.each do |line|
  element, left, right = line.scan(/\w+/)
  nodes[element] = [left, right]
end

steps = 0
current = 'AAA'
until current == 'ZZZ'
  steps += 1
  current = nodes[current][instructions.next]
end
puts steps
