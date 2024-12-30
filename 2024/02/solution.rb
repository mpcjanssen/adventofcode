# frozen_string_literal: true

input = $stdin.readlines.map { |it| it.strip.split.map(&:to_i) }

def issafe(report)
  incr = [1, 2, 3].to_set
  decr = [-1, -2, -3].to_set
  deltas = report.each_cons(2).map { |a, b| b - a }.to_set
  deltas < incr || deltas < decr
end

def issafe2(report)
  (0..report.size).each do |idx|
    nr = report.dup
    nr.slice!(idx)
    return true if issafe(nr)
  end
  false
end

p input.map { |r| issafe(r) }.count(true)
p input.map { |r| issafe2(r) }.count(true)
