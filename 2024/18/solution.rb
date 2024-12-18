bytes = $stdin.readlines.map {|l|
  l.strip.split(",").map(&:to_i)
}


def solve(bytes,num,target)
  start = [0,0]
  xmax,ymax = target

  corrupted = bytes[0...num]
  grid = Array.new(ymax+1) {Array.new(xmax+1,'.')}
  corrupted.each { |x,y| grid[y][x] = '#' }

  dirs = [[1,0],[-1,0],[0,1],[0,-1]]
  scores = {start => 0}
  heads = Queue.new
  heads.push start
  while scores[target].nil? && heads.size > 0
    head = heads.pop
    x,y = head
    score = scores[[x,y]]
    dirs.each { |dir|
      dx,dy = dir
      nx,ny = [x+dx,y+dy]
      next if nx < 0 || nx > xmax
      next if ny < 0 || ny > ymax
      next if grid[ny][nx] == '#'
      next if scores[[nx,ny]] != nil
      heads.push [nx,ny]
      scores[[nx,ny]] = score+1
    }
  end
  scores[target]

end

# target, bytes1 = [[6,6], 12]
target, bytes1 = [[70,70], 1024]

part1 = solve(bytes, bytes1, target )

bfail = bytes.size-1
bpass = bytes1

# Do a binary search for last failing and last passing

loop do
  bnext = bpass + (bfail - bpass)/2
  result = solve(bytes, bnext, target )

  if result != nil then
    bpass = bnext
  else
    bfail = bnext
  end
  break if bpass == bfail-1
end

# Take the bpass as index because the index of
# the last byte after dropping n bytes is n-1
part2 = bytes[bpass].join(",")

p [part1,part2]
