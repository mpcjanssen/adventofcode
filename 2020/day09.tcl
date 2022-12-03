source setup.tcl

aoc::get-puzzle 2020 9 1
#aoc::get-puzzle 2020 9 2
set input [aoc::get-input 2020 9]
jupyter::html "<h2>Input</h2>"
jupyter::display "text/plain" [string range $input 0 100]...;

proc parts input {
    set nums [split [string trim $input] \n]
    set size [llength $nums]
    for {set i 25} {$i < $size} {incr i} {
        set num [lindex $nums $i]
        set preamble  [lrange $nums $i-25 $i-1]
        #    puts $preamble
        #    puts $num
        set found 0
        foreach x $preamble {
            set target [expr {$num-$x}]
            # puts $target
            if {$target in $preamble} {set found 1 ; break}
        }
        if {$found} continue else break
    }
    set result1 $num
    set chunk 2
    set found 0
    while {!$found} {
        for {set i 0} {$i < $size-$chunk} {incr i} {
            set j [expr {$i+$chunk-1}]
            set candidate [lrange $nums $i $j]
            set sum [+ {*}$candidate]
            if {$sum == $result1} {set result2list $candidate ; set found 1}
        }
        incr chunk
    }
    set weakness [lsort -integer $result2list]
    set result2 [+ [lindex $weakness 0] [lindex $weakness end]]
    return [list $result1 $result2]
}
aoc::results
