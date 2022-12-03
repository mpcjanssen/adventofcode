lappend auto_path [file dirname [info script]]/lib
tcl::tm::path add [file dirname [info script]]/modules [file dirname [info script]]/lib/cintcode
package forget util
package require util
package forget intcode
catch {rename IntCode {}}
package require cintcode

tcl::tm::path add [file dirname [info script]]/../modules
package require aoc
set program [split [aoc::read-input 2019 15] ,]
# puts $program




set gen 0
set dist 0
# Discover the maze by cloning the robots and
# spreading out to cover the whole field
proc discover {bots worldVar visualize} {
	incr ::gen
	if {[llength $bots] == 0} return
	upvar $worldVar world
	set nextgen {}
	foreach {bot loc} $bots {
		# puts "$bot @ $loc"
	lassign [split $loc ,] x y
	# nloc
	set neighbours [list $x,[expr {$y-1}] 1]
	# sloc
	lappend neighbours $x,[expr {$y+1}] 2
	# wloc
	lappend neighbours [expr {$x-1}],$y 3
	# eloc
	lappend neighbours [expr {$x+1}],$y 4
	# puts $neighbours
	# parray world
	foreach {loc input} $neighbours {
		# puts _________$nextgen
		if {[info exists world($loc)]} {
			# puts done
			continue
		}
		# puts "dicovering $loc"
		set newbot [$bot clone]

		$newbot input $input
		$newbot clearoutputs
		$newbot run
		set out [lindex [$newbot outputs] end]
		# puts "$loc out->$out"
		lassign [split $loc ,]  x y
		set cx [expr {$x*10 + 300}]
		set cy [expr {$y*10 + 300}]
		switch $out {
			0 {
				if {$visualize} { 
					square .c $cx $cy 10 red wall
					update
				}
				set world($loc) X
				rename $newbot {}
			}
			1 {
				set world($loc) .
				if {$visualize} {
					square .c $cx $cy 10 white [list open $loc]
					update
				}
				set ::maxgen [expr {$::gen  + 1}]
				lappend nextgen $newbot $loc
			   }
			2 {
				set world($loc) @
				if {$visualize} {
					square .c $cx $cy 10 blue oxy
					update
				}
				set ::oxygen $::gen
				lappend nextgen $newbot $loc
			}
		}
	}
	rename $bot {}
	}
	tailcall discover $nextgen world $visualize
}

proc part1 {{visualize 0}} {
	upvar w world
	unset -nocomplain world
	set world(0,0) .
	if {$visualize} {
		package require Tk
		wm geometry . 900x900
		canvas .c
		label .l1 -textvariable  ::gen -anchor w
		label .l2 -textvariable  ::dist -anchor w
		grid .l1 -sticky ew
		grid .l2 -sticky ew
		grid .c -sticky nsew 
		grid columnconfigure . .c -weight 1
		grid rowconfigure . .c -weight 1
		square .c 300 300 10 green {open 0,0}
	}
	set bot [CintCode $::program]
	discover [list $bot 0,0] world $visualize
	return $::oxygen
	
}

proc distance {loc1 loc2} {
	lassign [split $loc1 ,] x1 y1
	lassign [split $loc2 ,] x2 y2
	return [expr {abs($x1-$x2)+abs($y1-$y2)}]
}

proc part2 {{visualize 0}} {
	upvar w world
	foreach loc [array names world] {
		switch -exact $world($loc) {
			. {set tofill($loc) 1}
			@ {set filled $loc}
		}
	}
	while {1} {
		if {[llength [array names tofill]] == 0} {
			return $::dist
		}
		incr ::dist
		set newfilled {}
		
			foreach p2 [array names tofill] {
				foreach p1 $filled {
				if {[distance $p1 $p2]==1} {
					if {$visualize} {
						.c itemconfigure $p2 -fill lightblue
						update
						
					}
					lappend newfilled $p2
					unset tofill($p2) 
					break
				}
			}
		
		}
		set filled $newfilled
		# puts [llength [array names tofill]]
	}
}



if {$::argv0 eq [info script]} {
	part1 1
	part2 1
	catch {console show}
}