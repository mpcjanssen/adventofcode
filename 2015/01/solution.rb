input = $stdin.read.chars

input = input.map { |c| if c == ')' then -1 else 1 end}
start = 0
accum =  input.lazy.map { |a| start += a }.to_a

part1 = accum[-1]
part2 = accum.find_index(-1) + 1

p [part1, part2]
