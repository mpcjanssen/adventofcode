# frozen_string_literal: true

input = File.open('in.txt').readlines.map { |l| l.strip.split.map(&:to_i) }.transpose.map(&:sort)
p input.transpose.map { |x, y| (x - y).abs }.sum
p input[0].map { |x| x * input[1].count(x) }.sum
