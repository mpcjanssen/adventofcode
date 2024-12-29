namespace import tcl::mathop::*
set input [split [string trim [read stdin]] \n]

foreach e $input {lassign $e e1 e2 ; lappend l1 $e1; lappend l2 $e2}
set l1 [lsort -integer $l1]
set l2 [lsort -integer $l2]

set part1 [+ {*}[lmap e1 $l1 e2 $l2 {expr {abs($e1-$e2)}}]]
set part2 [+ {*}[lmap e1 $l1 {* $e1 [llength [lsearch -all -inline $l2 $e1]]}]]

puts $part1,$part2