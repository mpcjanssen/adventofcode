init,program = $stdin.read.split("\n\n")

regs = {}
init.lines.each { |l|
  name,val = l.strip.split(": ")
  regs[name] = val.to_i
}

program.lines.each { | l |
  inst,reg = l.strip.split(" -> ")
  regs[reg] = inst
}


def calc(reg,regs)
  val = regs[reg]
  # p ["v", val]
  if val == 0 || val == 1
    return val 
  end
  p1, op , p2 = val.split
  # p [p1,p2]
  p1 = calc(p1,regs)
  p2 = calc(p2,regs)
  # p [op, p1,p2]
  case (op)
  when "AND"
    return p1 & p2
  when "OR"
    return p1 | p2
  when "XOR"
    return (p1 ^ p2)
  end 
end

p regs.keys.filter { |it| it.start_with?('z')}.sort.reverse.map { |it| calc(it,regs) }.join("").to_i(2)
