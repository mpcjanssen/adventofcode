
robots = File.open(ARGV[0]).readlines().map { |l|
  nums = l.scan /-?\d+/
  nums.map { |n| n.to_i}
}

wx = 101
wy = 103

# wx = 11
# wy = 7

def step(robots,wx,wy) 
  robots.map { | robot |
    x,y,dx,dy = robot
    x = (x + dx) % wx
    y = (y + dy) % wy
    [x,y,dx,dy]
  }
end
def display(robots,wx,wy) 
  g = Array.new(wy) { Array.new(wx,'.') }
  robots.each { |x,y,_,_|
    # p [x,y]
    g[y][x] = 'X'
  }
  puts g.map { | l | l.join("")}.join("\n") 
end

def safety(robots,wx,wy)
  midx = (wx-1)/2
  midy = (wy-1)/2
  # p [midx, midy]
  q1 = robots.filter { |x,y,_,_|
    # p [x,y]
    x < midx && y < midy
  }.count
  q2 = robots.filter { |x,y,_,_|
  # p [x,y]
  x < midx && y > midy
}.count
  q3 = robots.filter { |x,y,_,_|
  # p [x,y]
  x > midx && y < midy
  }.count
  q4 = robots.filter { |x,y,_,_|
  # p [x,y]
  x > midx && y > midy
  }.count
  q1*q2*q3*q4
end
# p robots
# print robots, wx,wy
min_safe = safety robots,wx,wy
seconds = 0
loop do
  robots = step(robots,wx,wy)
  seconds += 1
  p seconds if seconds % 100 == 0
  # print robots,wx,wy
  s = safety robots,wx,wy
  if s <= min_safe
    display robots,wx,wy
    p seconds
    $stdin.gets "Press key"
    min_safe = s
  end
end

p safety(robots,wx,wy)

# print robots, wx,wy