# frozen_string_literal: true

require_relative '../../lib/aoc'
input = $stdin.read.strip

grid = AOC::Cgrid.new(input)
# puts grid.display

start = grid.find_one 'S'
target = grid.find_one 'E'

def solve(grid, start, target)
  dirs = grid.dir4
  scores = { start => 0 }
  heads = Queue.new
  heads.push start
  while scores[target].nil? && heads.size.positive?
    head = heads.pop
    score = scores[head]
    dirs.each do |dir|
      nexthead = head + dir
      next if grid[nexthead].nil?
      next if grid[nexthead] == '#'
      next unless scores[nexthead].nil?

      heads.push nexthead
      scores[nexthead] = score + 1
    end
  end
  scores
end

def cheats(grid, start, target, cheattime)
  imps = {}
  imps.default = 0
  scores = solve(grid, start, target)
  cleanscore = scores[target]
  racetrack = grid.find_all 'SE.'.chars
  racetrack = racetrack.sort_by { |p| scores[p] }
  racetrack.freeze

  # verify that the racetrack has no dead ends or wider parts
  # also ensure there are no longer paths from S->E
  # This means that every point has a proper score when solving with BFS once
  raise 'Racetrack assumption not correct' if cleanscore != racetrack.size - 1

  (0..racetrack.size - 1).each do |idx|
    p1 = racetrack[idx]

    # Only consider within the maximum cheattime (manhattan) range.
    # Other points are not valid cheats
    diststart = scores[p1]
    (-cheattime..cheattime).each do |r|
      left = cheattime - r.abs
      (-left..left).each do |im|
        p2 = p1 + r + im.i
        next if grid[p2] == '#'

        dist = grid.manh(p1, p2)
        next if dist > cheattime

        distend = cleanscore - scores[p2]
        newdist = diststart + distend + dist
        delta = cleanscore - newdist
        imps[delta] += 1 if delta.positive?
      end
    end
  end
  imps
end

# p cheats(grid,start,target,2)
# p cheats(grid,start,target,20).filter {|k,v| k >= 50}

p [cheats(grid, start, target, 2).filter { |k, _| k >= 100 }.values.sum,
   cheats(grid, start, target, 20).filter { |k, _| k >= 100 }.values.sum]
