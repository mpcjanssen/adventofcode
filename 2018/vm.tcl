proc opr {op regs a1 a2 a3} {
    set v1 [lindex $regs $a1]
    set v2 [lindex $regs $a2]
    lset regs $a3 [expr [list $v1 $op $v2]]
    return $regs
}

proc opi {op regs a1 a2 a3} {
    set v1 [lindex $regs $a1]
    set v2 $a2
    lset regs $a3 [expr [list $v1 $op $v2]]
    return $regs
}

interp alias {} addr {} opr +
interp alias {} addi {} opi +

interp alias {} mulr {} opr *
interp alias {} muli {} opi *

interp alias {} banr {} opr &
interp alias {} bani {} opi &

interp alias {} borr {} opr |
interp alias {} bori {} opi |

proc setr {regs a1 a2 a3} {
    set v1 [lindex $regs $a1]
    lset regs $a3 $v1
    
}

proc seti {regs a1 a2 a3} {
    lset regs $a3 $a1
    
}

proc opir {op regs a1 a2 a3} {
    set v1 $a1
    set v2 [lindex $regs $a2]
    lset regs $a3 [expr [list $v1 $op $v2]]
    return $regs
}

proc opri {op regs a1 a2 a3} {
    set v1 [lindex $regs $a1]
    set v2 $a2
    lset regs $a3 [expr [list $v1 $op $v2]]
}

proc oprr {op regs a1 a2 a3} {
    set v1 [lindex $regs $a1]
    set v2 [lindex $regs $a2]
    lset regs $a3 [expr [list $v1 $op $v2]]
}

proc run {program regs ipreg} {
    set proglen [llength $program]
    set ip 0
    set disp [jupyter::display text/plain Starting....]
    set cmdcount 0
    while {1} {
        if {$ipreg != {}} {
            lset regs $ipreg $ip
        }
        if {$ip < 0 || $ip >= $proglen} {return $regs}

        set cmd [lindex $program $ip]
        set args [lassign $cmd op]
        set regs [$op $regs {*}$args]
        incr runcount($ip)
        incr cmdcount
        if {$cmdcount % 1000000 == 0} {
            set res {} ; foreach {k v} [array get runcount] {lappend res [list $k $v]} 
            jupyter::updatedisplay $disp text/plain "cmdcount: $cmdcount\nregs: $regs\n[join [lsort -integer -index 0 $res ] \n]"
        }
        if {$ipreg != {}} {
            set ip [lindex $regs $ipreg]
        }
        incr ip
    }
}

interp alias {} gtir {} opir >
interp alias {} gtri {} opri >
interp alias {} gtrr {} oprr >

interp alias {} eqir {} opir ==
interp alias {} eqri {} opri ==
interp alias {} eqrr {} oprr ==