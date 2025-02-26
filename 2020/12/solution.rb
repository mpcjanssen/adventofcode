# frozen_string_literal: true

$instructions = $stdin.readlines.map(&:strip)

$ship = [Complex(0, 0), 1]

def step(ship, instruction)
  pos, dir = ship
  op = instruction[0]
  arg = instruction[1..].to_i
  # p [pos, dir]
  # p [op, arg]
  case op
  when 'N'
    [pos - Complex::I * arg, dir]
  when 'S'
    [pos + Complex::I * arg, dir]
  when 'E'
    [pos + arg, dir]
  when 'W'
    [pos - arg, dir]
  when 'F'
    [pos + arg * dir, dir]
  when 'R'
    raise "invalid arg #{arg}" if arg % 90 != 0

    pow = arg / 90
    [pos, dir * Complex::I**pow]
  when 'L'
    raise "invalid arg #{arg}" if arg % 90 != 0

    pow = arg / 90
    [pos, dir * (- Complex::I)**pow]
  else
    raise "Invalid op #{op}"

  end
end

$instructions.each do |inst|
  $ship = step($ship, inst)
end
p $ship[0].real.abs + $ship[0].imag.abs

def step2(ship, instruction)
  pos, wp = ship
  op = instruction[0]
  arg = instruction[1..].to_i
  # p [pos, wp]
  # p [op, arg]
  case op
  when 'N'
    [pos, wp - Complex::I * arg]
  when 'S'
    [pos, wp + Complex::I * arg]
  when 'E'
    [pos, wp + arg]
  when 'W'
    [pos, wp - arg]
  when 'F'
    [pos + arg * wp, wp]
  when 'R'
    raise "invalid arg #{arg}" if arg % 90 != 0

    pow = arg / 90
    [pos, wp * Complex::I**pow]
  when 'L'
    raise "invalid arg #{arg}" if arg % 90 != 0

    pow = arg / 90
    [pos, wp * (- Complex::I)**pow]
  else
    raise "Invalid op #{op}"

  end
end
$ship = [Complex(0, 0), Complex(10, -1)]

$instructions.each do |inst|
  $ship = step2($ship, inst)
end
p $ship[0].real.abs + $ship[0].imag.abs
