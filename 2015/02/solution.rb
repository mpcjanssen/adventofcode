# frozen_string_literal: true

input = $stdin.readlines
boxes = input.map { |l| l.scan(/\d+/).map(&:to_i).sort }

part1 = boxes.map do |x, y, z|
  2 * (x * y + x * z + y * z) + x * y
end.sum

part2 = boxes.map do |x, y, z|
  2 * (x + y) + x * y * z
end.sum

p [part1, part2]
