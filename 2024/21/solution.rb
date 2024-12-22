

$doorkeys = {
  "7" => 0,
  "8" => 1,
  "9" => 2,
  "4" => 0 + Complex::I,
  "5" => 1 + Complex::I,
  "6" => 2 + Complex::I,
  "1" => 0 + 2*Complex::I,
  "2" => 1 + 2*Complex::I,
  "3" => 2 + 2*Complex::I,
  "0" => 1 + 3*Complex::I,
  "A" => 2 + 3*Complex::I,
}

$robotkeys = {
  "^" => 1,
  "A" => 2,
  "<" => 0 + Complex::I,
  "v" => 1 + Complex::I,
  ">" => 2 + Complex::I,
}

test1 = "029A"

def sequence(keypad,target)
  sequence = []
  cpos = keypad["A"]
  target.each { |nk|
    nkpos = keypad[nk]
    delta =  nkpos - cpos
    realdis = delta.real
    imagdis = delta.imag
    # p [realdis,imagdis]
    if realdis >= 0
      sequence << [">"] * realdis
    else
      sequence << ["<"] * realdis.abs
    end
    if imagdis >= 0
      sequence << ["v"] * imagdis
    else
      sequence << ["^"] * imagdis.abs
    end
    cpos = nkpos
    sequence << "A"
  }
  sequence.flatten
end

def part1(target)
  p target
  target = target.chars
  keyres = sequence($doorkeys,target)
  robot1keys = sequence($robotkeys,keyres)
  p robot1keys
  robot2keys = sequence($robotkeys,robot1keys)
  num = target[0..-2].join("").to_i
  # p [num, robot2keys.size]
  return num*robot2keys.size
end

part1 = $stdin.readlines.map(&:strip).map {|t|
  part1(t)
}.sum


p part1