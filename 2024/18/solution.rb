require 'set'

bytes = $stdin.readlines.map {|l|
  l.strip.split(",").map(&:to_i)
}


def solve(bytes,num,target)
  start = [0,0]
  xmax,ymax = target
  # p [xmax,ymax]
  corrupted = bytes[0...num]
  grid = Array.new(ymax+1) {Array.new(xmax+1,'.')}
  corrupted.each {|x,y|
    grid[y][x] = '#'
  }
  dirs = [[1,0],[-1,0],[0,1],[0,-1]]
  scores = {start => 0}
  heads = [start].to_set
  while scores[target].nil? && heads.size > 0
    # p heads
    newheads = Set.new
    heads.each { |head|
      x,y = head
      score = scores[[x,y]]
      dirs.each { |dir|
        dx,dy = dir
        nx,ny = [x+dx,y+dy]
        # p [nx,ny]
        next if nx < 0 || nx > xmax
        next if ny < 0 || ny > ymax
        next if grid[ny][nx] == '#'
        next if scores[[nx,ny]] != nil
        newheads << [nx,ny]
        scores[[nx,ny]] = score+1
      }
      # p newheads.size
      heads = newheads
    }
  end
  scores[target]

end

bpart1 = 1024
# part1 = solve(bytes, bpart1, [6, 6] )
part1 = solve(bytes, bpart1, [70, 70] )

bfail = bytes.size-1
bpass = bpart1

# Do a binary search for last failing and last passing

loop do
  bnext = bpass + (bfail - bpass)/2
  # result = solve(bytes, bnext, [6, 6] )
  result = solve(bytes, bnext, [70, 70] )
  # p [bnext, result]
  if result != nil then
    bpass = bnext
  else
    bfail = bnext
  end
  break if bpass == bfail-1
end


part2 = bytes[bpass].join(",")

p [part1,part2]
