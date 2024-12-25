# frozen_string_literal: true

# rubocop:disable Style/GlobalVars

$items = $stdin.read.strip.split("\n\n").map { |it| it.strip.split("\n").map(&:chars) }
$locks = []
$keys = []

$items.each do |it|
  heights = it.transpose.map { |col| col.count('#') - 1 }
  $locks << heights if it[0][0] == '#'
  $keys << heights if it[0][0] == '.'
end

def fit(key, lock)
  key.zip(lock).each do |kh, lh|
    return false if kh + lh > 5
  end
  true
end

part1 = $keys.map do |k|
  $locks.map do |l|
    fit(k, l)
  end
end.flatten(1).count(true)

p part1

# rubocop:enable Style/GlobalVars
