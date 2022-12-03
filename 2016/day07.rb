input = File.readlines('./input/7.txt').map do |line| 
  line.strip
end

# reject xyyx's in hypernet sequence (between [])
input1 = input.reject { |x| x.scan(/\[[a-z]*([a-z])(?!\1)(.)\2\1[a-z]*\]/).length != 0 }
input1 = input1.select { |x| x.scan(/([a-z])(?!\1)(.)\2\1/).length != 0}

puts "part1: #{input1.length}"

@patterns = ('a'..'z').inject([]) do |pat, x|
  ('a'..'z').each do | y |
      pat << "#{x}#{y}#{x}" unless y == x 
  end
  pat
end


def matches(line)
  # p @patterns
  hyper = line.scan(/\[[a-z]+\]/)
  ips = hyper.inject(line) do | l, rep |
    # p rep[1..-2]
    l.gsub(rep[1..-2], "-")
  end.split("[-]")
  # p hyper,ips
  hyper.each do |x|
    @patterns.each do |pat| 
      # p x,pat
      if x =~ /#{pat}/ then
        rot =  "#{pat[1]}#{pat[0]}#{pat[1]}"
        # p rot
        ips.each do |ip|
          return true if ip =~ /#{rot}/
        end
      end
    end
  end
  return nil
end

# input = ["aba[bab]xyz"]

input2 = input.select do | line |
  matches(line)
end

puts "part2: #{input2.length}"