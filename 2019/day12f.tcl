proc simulate {steps p1 p2 p3 p4 v1 v2 v3 v4}  {
    for {set step 0} {$step < $steps} {incr step} {
        if { $p1 < $p2} {
            incr v1
            incr v2 -1
        } elseif {$p1 > $p2} {
            incr v2
            incr v1 -1
        }      
        if { $p1 < $p3} {
            incr v1
            incr v3 -1
        } elseif {$p1 > $p3} {
            incr v3
            incr v1 -1
        }      
        if { $p1 < $p4} {
            incr v1
            incr v4 -1
        } elseif {$p1 > $p4} {
            incr v4
            incr v1 -1
        }      
        if { $p2 < $p3} {
            incr v2
            incr v3 -1
        } elseif {$p2 > $p3} {
            incr v3
            incr v2 -1
        }      
        if { $p2 < $p4} {
            incr v2
            incr v4 -1
        } elseif {$p2 > $p4} {
            incr v4
            incr v2 -1
        }      
        if { $p3 < $p4} {
            incr v3
            incr v4 -1
        } elseif {$p3 > $p4} {
            incr v4
            incr v3 -1
        }      
        incr p1 $v1
        incr p2 $v2
        incr p3 $v3
        incr p4 $v4
    }
    return [list $p1 $p2 $p3 $p4 $v1 $v2 $v3 $v4]
}

proc period {p1 p2 p3 p4 v1 v2 v3 v4}  {
    for {set step 1} 1 {incr step} {
        if { $p1 < $p2} {
            incr v1
            incr v2 -1
        } elseif {$p1 > $p2} {
            incr v2
            incr v1 -1
        }      
        if { $p1 < $p3} {
            incr v1
            incr v3 -1
        } elseif {$p1 > $p3} {
            incr v3
            incr v1 -1
        }      
        if { $p1 < $p4} {
            incr v1
            incr v4 -1
        } elseif {$p1 > $p4} {
            incr v4
            incr v1 -1
        }      
        if { $p2 < $p3} {
            incr v2
            incr v3 -1
        } elseif {$p2 > $p3} {
            incr v3
            incr v2 -1
        }      
        if { $p2 < $p4} {
            incr v2
            incr v4 -1
        } elseif {$p2 > $p4} {
            incr v4
            incr v2 -1
        }      
        if { $p3 < $p4} {
            incr v3
            incr v4 -1
        } elseif {$p3 > $p4} {
            incr v4
            incr v3 -1
        }      
        incr p1 $v1
        incr p2 $v2
        incr p3 $v3
        incr p4 $v4
        # if {$step % 1000 == 0} {puts $step}
        # Halfway between initial and period all velocities on an axis are 0 again (as in the intial condition)
        if { 
            $v1 == 0 &&
            $v2 == 0 &&
            $v3 == 0 &&
            $v4 == 0 
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

proc part1 {} {
    set x {3 5 -10 8 0 0 0 0}
    set y {15 -1 8 4 0 0 0 0}
    set z {8 -2 2 -5 0 0 0 0}
    set x1000 [simulate 1000 {*}$x]
    set y1000 [simulate 1000 {*}$y]
    set z1000 [simulate 1000 {*}$z]
    lassign $x1000 p1x p2x p3x p4x v1x v2x v3x v4x
    lassign $y1000 p1y p2y p3y p4y v1y v2y v3y v4y
    lassign $z1000 p1z p2z p3z p4z v1z v2z v3z v4z
    set energy [expr {(abs($p1x)+abs($p1y)+abs($p1z)) * (abs($v1x)+abs($v1y)+abs($v1z))}]
    incr energy [expr {(abs($p2x)+abs($p2y)+abs($p2z)) * (abs($v2x)+abs($v2y)+abs($v2z))}]
    incr energy [expr {(abs($p3x)+abs($p3y)+abs($p3z)) * (abs($v3x)+abs($v3y)+abs($v3z))}]
    incr energy [expr {(abs($p4x)+abs($p4y)+abs($p4z)) * (abs($v4x)+abs($v4y)+abs($v4z))}]
}

proc part2 {} {
    namespace import tcl::mathop::*
    set x {3 5 -10 8 0 0 0 0}
    set y {15 -1 8 4 0 0 0 0}
    set z {8 -2 2 -5 0 0 0 0}
    set total_factors {}
    set periods [list [period {*}$x] [period {*}$y] [period {*}$z]]
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
     return [* {*}$factors]
}

if {$::argv0 eq [info script]} {
  puts [part1]
	puts [part2]
}

