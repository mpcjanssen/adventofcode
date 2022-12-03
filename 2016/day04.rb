input = File.readlines("./input/4.txt")
# input = ["aaaaa-bbb-z-y-x-123[abxyz]"]
real =  input.map { |x|

  (x.strip.scan /([-a-z]+)-([0-9]+)\[([a-z]+)\]/)[0]
}.select { | name,id,checksum |
  calc = name.chars
      .group_by { |x| x}.to_a.map {|l,freq| [l, freq.length] }
      .reject { |l, y| l == "-" }
      .sort {|i1,i2 |
        l1,v1 = i1
        l2,v2 = i2
        if v2 == v1 then
        l1 <=> l2
        else
          v2 <=> v1
        end
      }.take(5).map(&:first).join("")
  calc == checksum
}

p real.map { |x | x[1].to_i}.sum


decr =  real.select {
  | name,id,checksum |
  decr = name.chars.map { |x|
    if  x == "-" then " "
    else ((((x.ord + id.to_i) - "a".ord) % 26) + "a".ord)
    end

    }.map {|i| i.chr}.join("")
  decr.include?("northpole object storage")

}[0][1].to_i
p decr

