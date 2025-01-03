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

proc issafe report {
    set deltas [lmap a [lrange $report 0 end-1] b [lrange $report 1 end] {
        expr {$b - $a}
    }]
    if {[lindex $deltas 0] > 0} {
        foreach d $deltas {
            if {$d ni {1 2 3}} {return 0}
        }
    } else {
        foreach d $deltas {
            if {$d ni {-1 -2 -3}} {return 0}
        }
    }
    return 1
}

proc issafe2 {report} {
    foreach v [versions $report] {
        if {[issafe $v]} {return 1}
    }
    return 0
}

puts [+ {*}[lmap x $reports {issafe $x}]]
puts [+ {*}[lmap x $reports {issafe2 $x}]]
