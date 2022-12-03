load cmake-build-debug/libbreakable.dll

puts [time {set result [breakable {1 2 3 4 5 6 7 8} 1]}]

puts "result: $result"
