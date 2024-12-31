# frozen_string_literal: true

input = $stdin.read.chars

input = input.map { |c| c == ')' ? -1 : 1 }
accum = input.each_with_object([0]) { |a, acc| acc << acc[-1] + a }.to_a

part1 = accum[-1]
part2 = accum.find_index(-1) + 1

p [part1, part2]
