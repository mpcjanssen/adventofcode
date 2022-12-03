input = File.readlines('./input/6.txt').map do |line| 
  line.strip.chars
end

#  input = "eedadn
#  drvtee
#  eandsr
#  raavrd
#  atevrs
#  tsrnev
#  sdttsa
#  rasrtv
#  nssdts
#  ntnada
#  svetve
#  tesnvt
#  vntsnd
#  vrdear
#  dvrsen
#  enarar".lines.map do |line| 
#  line.strip.chars
# end


input = input.transpose.map do | col |
  gb = col.group_by {|x| x}
  gb.map do | c, cs | 
    [c, cs.length]
  end.sort do | x1, x2 |
    c1, n1 = x1
    c2, n2 = x2
    n2 <=> n1
  end
end.to_a


input1 = input.map do | l |
  l[0][0]
end
p input1.join("")

input2 = input.map do | l |
  l[-1][0]
end
p input2.join("")