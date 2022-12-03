lappend auto_path [file dirname [info script]]/lib
tcl::tm::path add [file dirname [info script]]/modules [file dirname [info script]]/lib/cintcode
package require util
package require cintcode
tcl::tm::path add [file dirname [info script]]/../modules
package require aoc


set program [aoc::read-input 2019 19]
proc value {x y} {
	    set machine [CintCode [split $::program ,]]
	    $machine input $x
	    $machine input $y
	    $machine run
	    set result [lindex [$machine outputs] end]
	    rename $machine {}
	    return $result
}

proc part1 {} {
    set results {}
    foreach x [range 0 49] {
	foreach y [range 0 49] {
	    lappend results [value $x $y]
	}
    }
    return [sum $results]
}


proc fits {y} {
		set x 0
		while {[value $x $y] == 0} {
			incr x
		}
		return [list [value [expr {$x+99}] [expr {$y-99}]] $y $x]
}


proc part2 {} {

	lassign [fits 2164] -> y x
	return [expr {$y-99 + $x*10000}]

    
}

proc visualize {} {
    package require Tk
    wm geometry . 550x550
    canvas .c
    pack .c -expand 1 -fill both
    set program [read-input day19]
    foreach x [range 0 49] {
	foreach y [range 0 49] {
	    set machine [CintCode [split $program ,]]
	    $machine input $x 
	    $machine input $y 
	    $machine run
	    set result [lindex [$machine outputs] end]
	    if {$result == 1} {
		square .c [expr {$x*10+10}]  [expr {$y*10+10}] 10 green
	    }
	    
	}
    }
}


if {$::argv0 eq [info script]} {
  visualize
}
