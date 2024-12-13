machines = $stdin.read().split("\n\n").map { |mach|
  a,b,p = mach.split("\n")
  bb = (b.scan /[0-9]+/).map(&:to_f)
  bb = (b.scan /[0-9]+/).map(&:to_f)
  ba = (a.scan /[0-9]+/).map(&:to_f)
  bp = (p.scan /[0-9]+/).map(&:to_f)
  [ba,bb,bp]
}

def solve(machine, offset)
  ba, bb, bp = machine
  ax, ay = ba
  bx, by = bb
  px, py = bp
  px += offset
  py += offset
  # ax*pa + bx*pb = tx
  # ay*pa + by*pb = ty


  s =  (bx*py - by*px)/ (ay*bx-ax*by)
  t = (px - s*ax)/bx
  # p [s,t]
  [s,t]
end

p machines.map { |m| solve(m,0) }.filter { |s,t| s % 1 == 0 && t % 1 == 0}.map { |t,s| 3*t+s}.sum.to_i
p machines.map { |m| solve(m,10000000000000) }.filter { |s,t| s % 1 == 0 && t % 1 == 0}.map { |t,s| 3*t+s}.sum.to_i
