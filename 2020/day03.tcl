source setup.tcl

aoc::get-puzzle 2020 3 1
aoc::get-puzzle 2020 3 2
set input [aoc::get-input 2020 3]
jupyter::display "text/html" "<h2>Input</h2>"
jupyter::display "text/plain" [string range $input 0 100]...;

proc parts input {
set data [split [string trim $input] \n]
set data [lmap line $data {split [string trim $line] {}}]
set w [llength [lindex $data 0]]
set h [llength $data]
set result2 {}
foreach slope {{1 1} {3 1} {5 1} {7 1} {1 2}} {

set x 0
set y 0
set trees 0
lassign $slope dx dy
while {$y < $h} {
    incr x $dx
    incr y $dy
    set xpos [expr {$x % $w }] 
    set loc [lindex $data $y $xpos]
    if {$loc eq "#"} {incr trees}
    
}
if {$dx == 3} {set result1 $trees}
lappend result2 $trees
}

return [list $result1 [* {*}$result2]]
}


aoc::results


