lappend auto_path [file dirname [info script]]/lib
tcl::tm::path add [file dirname [info script]]/modules [file dirname [info script]]/lib/cintcode
package require util
tcl::tm::path add [file dirname [info script]]/../modules
package require aoc


proc init {varname} {
    upvar #0 $varname moon
    set moon(1,x) 3
    set moon(1,y) 15
    set moon(1,z) 8
    set moon(1,vx) 0
    set moon(1,vy) 0 
    set moon(1,vz) 0
    
    set moon(2,x) 5
    set moon(2,y) -1
    set moon(2,z) -2
    set moon(2,vx) 0
    set moon(2,vy) 0 
    set moon(2,vz) 0
    
    set moon(3,x) -10
    set moon(3,y) 8
    set moon(3,z) 2
    set moon(3,vx) 0
    set moon(3,vy) 0 
    set moon(3,vz) 0
    
    set moon(4,x) 8
    set moon(4,y) 4
    set moon(4,z) -5
    set moon(4,vx) 0
    set moon(4,vy) 0 
    set moon(4,vz) 0
}

proc gravity {ax}  {
    variable moon
    foreach {id1 id2} {1 2 1 3 1 4 2 3 2 4 3 4} {
        if {$moon($id1,$ax) < $moon($id2,$ax)} {
            incr moon($id1,v$ax)
            incr moon($id2,v$ax) -1
        } elseif {$moon($id1,$ax) > $moon($id2,$ax)} {
            incr moon($id2,v$ax)
            incr moon($id1,v$ax) -1
        }      
    }
}
proc velocity {ax} {
    variable moon
    incr moon(1,$ax) $moon(1,v$ax)
    incr moon(2,$ax) $moon(2,v$ax)
    incr moon(3,$ax) $moon(3,v$ax)
    incr moon(4,$ax) $moon(4,v$ax)
}

namespace import tcl::mathfunc::abs
proc energy {} {
    variable moon
    set total 0
    foreach id {1 2 3 4} {
        set kin 0
        set pot 0
        foreach ax {x y z} {
            incr pot [abs $moon($id,$ax)]
            incr kin [abs $moon($id,v$ax)]
        }
        incr total [expr {$kin*$pot}]
    }
    return $total
}

proc part1 {} {
    init moon
    for {set i 0} {$i < 1000} {incr i} {
        gravity x ; velocity x
        gravity y ; velocity y
        gravity z ; velocity z
    }
    energy
}

proc period {ax} {
    variable moon
    for {set step 1} 1 {incr step} {
        gravity $ax
        velocity $ax
        # if {$step % 1000 == 0} {puts $step}
        # Halfway between initial and period all velocities on an axis are 0 again (as in the intial condition)
        if { 
            $moon(1,v$ax) == 0 &&
            $moon(2,v$ax) == 0 &&
            $moon(3,v$ax) == 0 &&
            $moon(4,v$ax) == 0
        } {
            return [expr {$step * 2}]
        }
    }
}


proc factors {n} {
    set top [expr {int(sqrt($n))+1}]
    set factor 2
    set factors {}
    # puts "########## $n"
    while {$factor <= $top && $n != 1} {
        # puts "$n : $factor < $top"
        if {$n % $factor == 0} {
            dict incr factors $factor
            set n [expr {$n / $factor}]
        } else {
            incr factor
        }
    }
    if {$n != 1} {
        dict incr factors $n
    }
    # puts "<<<<<<<<< $factors"
    return $factors
}

proc part2 {} {
    namespace import tcl::mathop::*
    puts [time {
    init moon
    set total_factors {}
    set periods [list [period x] [period y] [period z]]
    foreach period $periods {
        set f [factors $period]
        # puts $f
        dict for {k val} $f {
            # puts $k
            if {![dict exists $total_factors $k] || $val > [dict get $total_factors $k]} {
                dict set total_factors $k $val
            }
        }
    }
    set factors {}
    # puts $total_factors
     foreach {factor count} $total_factors {
        lappend factors {*}[lrepeat  $count $factor]
     }
    }]
     return [* {*}$factors]
}

proc visualize {} {
    init moon
    upvar #0 moon space

    set pad 10
    set sx 800
    set sy 800
    package require Tk
    wm geometry . ${sx}x${sy}
    canvas .c
    
    set ::e ""
    label .l -textvariable  ::e
    label .p1 -textvariable  ::p1
    grid .p1 -sticky ew
    grid .l -sticky ew
    grid .c -sticky nsew  
    grid rowconfigure . .c -weight 1
    grid columnconfigure . 0 -weight 1
    
    set dotsize 10
    set cols {_ red blue orange green}
    foreach id [range 1 4] {
    	dot .c [expr {$space($id,x)+400}] [expr {$space($id,y)+400}] $dotsize [lindex $cols $id] id$id
    }
    set i 0
    while {1} {
        gravity x
        gravity y
        gravity z
      #   foreach id [range 1 4] {
    		# .c move id$id $space($id,vx) $space($id,vy)
      #   }
      .c delete all
      foreach id [range 1 4] {
        dot .c [expr {$space($id,x)+400}] [expr {$space($id,y)+400}] $dotsize [lindex $cols $id] id$id
    }
    velocity x
    velocity y
    velocity z
    incr i
    set ::e "Energy: [energy]"
    if {$i == 1000} {set ::p1 "Part1: $::e"}

        # if {$i % 500 == 0 } {
        #     .c delete checks
        #     foreach id [range 1 4] {
        #         dot .c [expr {$space($id,x)+400}] [expr {$space($id,y)+400}] $dotsize black checks
        #     }
        # }
        after 30	
        update
    }
    
}

if {$::argv0 eq [info script]} {
    visualize
}

