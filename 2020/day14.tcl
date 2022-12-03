source setup.tcl

aoc::get-puzzle 2020 14 1
aoc::get-puzzle 2020 14 2
set input [aoc::get-input 2020 14]
jupyter::html "<h2>Input</h2>"
jupyter::display "text/plain" [string range $input 0 100]...;

proc setmem {memloc mask value} {
    upvar $memloc mem
    set newvalue {}
    set value [format %036llb $value] 
    foreach d [split $value {}] m [split $mask {}] {
        switch $m {
            0 {append newvalue 0}
            1 {append newvalue 1}
            X {append newvalue $d}
            default {return -code error "invalid part in mask $m"}
        }
    }
    set mem [expr 0b$newvalue]
    
}

proc locations {mem mask} {
    set bitmask [split $mask {}]
    set mem [split [format %036llb $mem]  {}]
    set locations {{}}
    foreach b $bitmask m $mem {
        set newlocations {}
        foreach loc $locations {
            switch $b {
                0 {lappend newlocations $loc$m}
                1 {lappend newlocations ${loc}1}
                X {lappend newlocations ${loc}0 ${loc}1}
            }
        }
        set locations $newlocations
    }
    return [lmap l $locations {expr 0b$l}]
}

proc setmem2 {memvar index mask val} {
    upvar $memvar mem
    foreach loc [locations $index $mask] {
        set mem($loc) $val
    }
}


proc parts input {
    set input [split [string trim $input] \n]
    set mem(0) 0

    foreach line $input {
        scan $line "%s" mode
        if {$mode eq "mask"} {
            scan $line "%s = %s" _ mask
        } else {
            scan $line {mem[%d] = %d} index value
            setmem mem($index) $mask $value
        }
    }
    set result1 0
    array names mem
    array for {loc val} mem {
        incr result1 $val
    }
    array unset mem
     set mem(0) 0
    set result2 0
    foreach line $input {
        scan $line "%s" mode
        if {$mode eq "mask"} {
            scan $line "%s = %s" _ mask
        } else {
            scan $line {mem[%d] = %d} index value
            setmem2 mem $index $mask $value
        }
    }
    set result2 0
    array for {loc val} mem {
        incr result2 $val
    }
    return [list $result1 $result2]
}
aoc::results 


