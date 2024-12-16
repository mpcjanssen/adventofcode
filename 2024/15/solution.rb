data, instructions = $stdin.read.split("\n\n")
grid = data.lines.map { |l| l.strip.chars}
wy = grid.count
wx = grid[0].count
cgrid = {}
cgrid.default = "#"

def pcgrid(cgrid,wx,wy)
  (0...wy).map { |y|
    (0...wx).map { |x|
      cgrid[Complex(x,y)]
    }.join("")
  }.join("\n")

end



puts grid.map {|l| l.join("")}.join("\n")
instructions =  instructions.split("\n").join("").chars

grid.each.with_index { |l, r|
  l.each.with_index { |v, c|
    cgrid[Complex(c,r)] = v
  }
}

robot = cgrid.find { |pos, val| val == '@'}.first

p robot

def step(cgrid, robot, inst)
  delta = case(inst)
  when '^'
    Complex(0,-1)
  when 'v'
    Complex(0,1)
  when '<'
    Complex(-1,0)
  when '>'
    Complex(1,0)
  end
  # p [robot, delta]
  newpos = robot + delta
  return robot if cgrid[newpos] == '#'
  if cgrid[newpos] == '.'
    cgrid[robot] = '.'
    cgrid[newpos] = '@'
    return newpos
  end
  boxpos = newpos
  while cgrid[boxpos] == 'O'
     boxpos += delta
  end
  return robot if cgrid[boxpos] == '#'
  while cgrid[boxpos] != '@'
    cgrid[boxpos] = 'O'
    boxpos -= delta
  end
  cgrid[robot] = '.'
  cgrid[newpos] = '@'
  return newpos
end






# puts robot
puts pcgrid(cgrid,wx,wy)
instructions.each { |inst |
  robot = step(cgrid, robot,inst)
  # puts pcgrid(cgrid,wx,wy)
}

part1 = cgrid.map { |c, val|
  if val == 'O'
    c.imag*100+c.real
  else
    0
  end
}
puts pcgrid(cgrid,wx,wy)
p part1.sum
