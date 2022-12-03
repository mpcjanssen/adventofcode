source setup.tcl

aoc::get-puzzle 2020 1 1

set input [aoc::get-input 2020 1];
jupyter::display text/plain [string range $input 0 100]...

aoc::get-puzzle 2020 1 2

proc parts input {
    set data [split [string trim $input] \n]
    set d1 false
    set d2 false
    foreach x $data {set h([expr 2020-$x]) 1}
    set l [llength $data]
    for {set i 0} {$i < $l} {incr i} {
        if {$d1 && $d2} {return [list $result1 $result2]}
        set x [lindex $data $i]
        if {!$d1 && [info exists h($x)]} {set result1 [expr {$x * (2020-$x)}] ; set d1 true}
         for {set j $i} {$j < $l} {incr j} {
            set y [lindex $data $j]
            set z [+ $x $y]
            if {!$d2 && [info exists h($z)] } {set result2 [expr {$x * $y * (2020 - $z)}]; set d2 true  }
        }
        
    }
}
aoc::results



