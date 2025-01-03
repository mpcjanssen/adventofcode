namespace import tcl::mathop::+

set input [read stdin]
set reports [split [string trim $input] \n]

proc versions report {
    set versions {}
    for {set idx 0} {$idx < [llength $report]} {incr idx} {
        lappend versions [lreplace $report $idx $idx]
    }
    return $versions
}

proc subset {s1 s2} {
    foreach s $s1 {
        if {$s ni $s2} {return 0}
    }
    return 1
}

proc issafe report {
    set deltas [lmap a [lrange $report 0 end-1] b [lrange $report 1 end] {
        expr {$b - $a}
    }]
    if {[lindex $deltas 0] > 0 && [subset $deltas {1 2 3}]} {return 1}
    if {[lindex $deltas 0] < 0 && [subset $deltas {-1 -2 -3}]} {return 1}
    return 0
}

proc issafe2 {report} {
    foreach v [versions $report] {
        if {[issafe $v]} {return 1}
    }
    return 0
}

puts [+ {*}[lmap x $reports {issafe $x}]]
puts [+ {*}[lmap x $reports {issafe2 $x}]]
