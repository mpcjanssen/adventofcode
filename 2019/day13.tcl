lappend auto_path [file dirname [info script]]/lib
tcl::tm::path add [file dirname [info script]]/modules [file dirname [info script]]/lib/cintcode
package forget util
package require util
package forget intcode
catch {rename IntCode {}}
package require cintcode

tcl::tm::path add [file dirname [info script]]/../modules
package require aoc

set program [split [aoc::read-input 2019 13] ,]


proc part1 {} {
	set m [CintCode $::program]
	$m run
	foreach {x y t} [$m outputs] {
		if {$t == 2} {
			incr blocks
		}
	}
	return $blocks
}

proc part2 {{visualize 0}} {
	if {$visualize} {
		package require Tk
		set pad 10
    	set sx 600
    	set sy 600
    	package require Tk
    	wm geometry . ${sx}x${sy}
    	canvas .c
    
    	set ::e "Score: 0"
		set ::delay 40
    	label .l -textvariable  ::score -anchor w
		scale .s -from 0 -to 100 -label "Delay" -variable ::delay -orient horizontal
		grid .s -sticky ew
		grid .l -sticky ew
    	grid .c -sticky nsew  
    	grid rowconfigure . .c -weight 1
    	grid columnconfigure . 0 -weight 1
	}
	set m [CintCode $::program]
	$m setmem 0 2
	set ::score 0
	while {[$m state] ne "stopped"} {
		$m run
		# puts [$m state]
		set outputs [$m outputs]
		set paddle {}
		foreach {x y t} $outputs {
			if {$t == 4 && $x != -1} {
				set ballx $x
				set bally $y
			}
			if {$t == 3 && $x != -1} {
				set paddlex  $x 
				set paddley $y
			}
			if {$x == -1} {
				set ::score "Score: $t"
			}
			if {$visualize && $x != -1} {
				if {$t == 4} {set cmd dot} else {set cmd square}
				.c delete $x:$y
				if {$t == 0} continue
				set color [lindex {_ red blue black orange} $t]
				$cmd .c [expr {$x*10+10}] [expr {$y*10+10}] 10 $color $x:$y
			}

		}
		if {$ballx > $paddlex} {
			$m input 1
		} elseif {$ballx == $paddlex} {
			$m input 0
		} else {
			$m input -1
		}
		if {$visualize} {
			update
			after $::delay
		}
		# puts "Ball $ballx , $bally"
		# puts "Paddel $paddlex, $paddley"
		$m clearoutputs
		# gets stdin
	}
	return $::score
}

if {$::argv0 eq [info script]} {
    part2 1
}
