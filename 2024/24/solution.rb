# frozen_string_literal: true

init, program = $stdin.read.split("\n\n")

regs = {}
init.lines.each do |l|
  name, val = l.strip.split(': ')
  regs[name] = val.to_i
end

program.lines.each do |l|
  inst, reg = l.strip.split(' -> ')
  regs[reg] = inst
end

def calc(reg, regs)
  val = regs[reg]
  return val if [0, 1].include? val

  p1, op, p2 = val.split
  p1 = calc(p1, regs)
  p2 = calc(p2, regs)
  case op
  when 'AND'
    p1 & p2
  when 'OR'
    p1 | p2
  when 'XOR'
    (p1 ^ p2)
  end
end

p regs.keys.filter { |it| it.start_with?('z') }.sort.reverse.map { |it| calc(it, regs) }.join('').to_i(2)
