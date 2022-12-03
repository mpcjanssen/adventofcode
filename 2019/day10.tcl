tcl::tm::path add [file join . modules]
package require util
tcl::tm::path add [file dirname [info script]]/../modules
package require aoc

set data [aoc::read-input 2019 10]
set grid [lmap x [split $data \n]  {split $x {}}]
set size [llength $grid]
incr size -1
set points {} ; foreach y [range 0 $size] {foreach  x [range 0 $size] {if {[lindex $grid $y $x] eq "#"} {lappend points [list $x $y]}}}

proc angles {points} {
    set angles {}
    namespace import tcl::mathfunc::atan2
    lmap p1 $points {
        lassign $p1 x1 y1
        foreach p2 $points {
            if {$p1 eq $p2} continue
            lassign $p2 x2 y2
            set dx [expr {$x2 - $x1}]
            set dy [expr {$y2 - $y1}]
            dict lappend angles $p1 [atan2 $dx $dy]
        }
       
    }
 #   return [lsort -stride 2 -index 1 -decreasing [dict map {p as} $angles {llength [lsort -unique $as]}]]
    return $angles
}


set angles [angles $points]

proc part1 {} {
     return [lrange [lsort -stride 2 -index 1 -decreasing [dict map {p as} $::angles {llength [lsort -unique $as]}]] 0 1]
}


proc part2 {} {
    set p1 {20 19}
    lassign $p1 x1 y1
    foreach p2 $::points {
    if {$p1 eq $p2} continue
            lassign $p2 x2 y2
            set dx [expr {$x2 - $x1}]
            set dy [expr {$y2 - $y1}]
            dict lappend angles [atan2 $dx $dy] $p2
    }
    # atan2 reduces from pi to -pi in one rotation
    set l [lsort -decreasing -real [dict keys $angles]]
    if {[llength $l] < 200} {
        # check if we are lucky
        error "More difficult case sorry"
    }
    set candidates [dict get $angles [lindex $l 199]]
    if {[llength $candidates] != 1} {
        # check if we are lucky again
        error "More difficult case sorry"
    }
    lassign [lindex $candidates 0] x y
    return [expr {$x*100 + $y}]
}
