source setup.tcl

aoc::get-puzzle 2020 10 1
#aoc::get-puzzle 2020 9 2
set input [aoc::get-input 2020 10]
jupyter::html "<h2>Input</h2>"
jupyter::display "text/plain" [string range $input 0 100]...;

proc parts input {
    set jolts [lsort -integer [split [string trim $input]]]
    set diffs {}
    set prev 0
    foreach j $jolts {
        dict incr diffs [- $j $prev]
        set prev $j
    }
    # add last 3 to device
    dict incr diffs 3
    set result1 [* {*}[dict values $diffs]]
    set way [lrepeat 167 0 ]
    lset way 0 1
    foreach j $jolts {
        # Some juggling to get a default value for negative indices
        lset way $j [+ {*}[join [list [lindex $way $j-1] [lindex $way $j-2] [lindex $way $j-3]] " "]]
    }

    set result2 [lindex $way end]
    return [list $result1 $result2]
}

aoc::results
