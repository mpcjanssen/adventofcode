input = File.readlines('./input/8.txt').map do |line| 
  line.strip.split(" ")
end

p input
input.inject([]) do | points, line |
  cmd, *rest = line 
  p rest
  case cmd
  when "rect"
    points
  else
    throw Exception.new("Invalid cmd #{cmd}")
  end

end