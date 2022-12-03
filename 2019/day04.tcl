source setup.tcl
package require util

set input [range 231832 767346]

 
proc part1candidates {} {
set input [range 231832 767346];
    set subs [join [lmap x [range 0 9] {list [string repeat  $x 2] {}}]]
    set input [regexp -all -inline  {\m1*2*3*4*5*6*7*8*9*\M} $input]
    set candidates {}
    foreach x $input {
        if {$x ne [string map $subs $x]} {
            lappend candidates $x
        }
    }
    return $candidates 
}

set p1candidates [part1candidates]

proc part1 {} {
    return [llength $::p1candidates]   
}

proc part2 {} {
    set candidates {}
    foreach x $::p1candidates {
        if {[lsearch [dict values [freq $x]] 2] != -1} {
            lappend candidates $x
        }
    }
    return  [llength $candidates]    
}

