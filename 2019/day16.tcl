lappend auto_path [file dirname [info script]]/lib
tcl::tm::path add [file dirname [info script]]/modules [file dirname [info script]]/lib/ffft
package forget util
package require util
package require ffft

tcl::tm::path add [file dirname [info script]]/../modules
package require aoc
set data [string trim [aoc::read-input 2019 16]]



proc part1 {} {
     set digits [split $::data {}]
     return [join [lrange [ffft $digits 100] 0 7] {}]
     
}

proc ex1 {} {
     set digits [split 12345678 {}]
     time {set digits [ffft $digits 4]}
     return [join [lrange $digits 0 7] {}]
}

proc ex2 {} {
     set digits [split 80871224585914546619083218645595 {}]
     time {set digits [ffft $digits 100]}
     return [join [lrange $digits 0 7] {}]
}

proc ex3 {} {
     set digits [split 19617804207202209144916044189917 {}]
     time {set digits [ffft $digits 100]}
     return [join [lrange $digits 0 7] {}]
}

proc ex4 {} {
     set digits [split 69317163492948606335995924319873 {}]
     time {set digits [ffft $digits 100]}
     return [join [lrange $digits 0 7] {}]
}

if {$::argv0 eq [info script]} {
	puts ex1:[ex1]
    puts ex2:[ex2]
    puts ex3:[ex3]
    puts ex4:[ex4]
	puts [time {set res [part1]}]
	puts "part1: $res"

}