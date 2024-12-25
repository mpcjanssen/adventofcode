input = $stdin.read.strip.chars.map(&:to_i)

part1 = [*input, input[0]].each_cons(2).map { |curr,foll|
  if curr == foll then curr else 0 end
}.sum

p part1

part2 = (0..input.size).map { |idx|
  other_idx = (idx + (input.size/2)) % input.size
  curr = input[idx]
  foll = input[other_idx]
  if curr == foll then curr else 0 end
  }.sum

p part2