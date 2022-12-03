load cmake-build-debug/libffft.dll

puts [time {set result [ffft {1 2 3 4 5 6 7 8} 1]}]

puts "result: $result"
