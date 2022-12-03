source setup.tcl

aoc::get-puzzle 2020 2 1

set input [aoc::get-input 2020 2]
jupyter::display text/plain [string range $input 0 100]...

aoc::get-puzzle 2020 2 2

proc parts input {
set data [split [string trim $input] \n]
set valid1 0
set valid2 0
foreach line $data {
    scan $line "%d-%d %1s: %s" low high char chars
    set chars [split " $chars" {}]
    set num [llength [lsearch -all  $chars $char]]
    set count 0
    if {([lindex $chars $low] eq $char) ^
         ([lindex $chars $high] eq $char)} {incr valid2}
    if { $num >= $low && $num <= $high} {
        incr valid1
    }
}
return [list $valid1 $valid2]
}
aoc::results


