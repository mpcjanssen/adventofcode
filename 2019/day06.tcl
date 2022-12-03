lappend auto_path [file dirname [info script]]/lib
tcl::tm::path add [file dirname [info script]]/modules
package forget util
package require util

tcl::tm::path add [file dirname [info script]]/../modules
package require aoc

foreach l [aoc::read-input 2019 6] {
    lassign [split $l )] around this
    set orbs($this) $around
}

proc orbpath {me} {
    set curr $me
    set path {}
    while {$curr ne "COM"} {
        set curr $::orbs($curr)
        lappend path $curr
    } 
    return $path
}

proc part1 {} {
    set lengths {}
    foreach me [array names ::orbs ] {
        lappend lengths [llength [orbpath $me]]
    }
    return [sum $lengths]
}

proc part2 {} {
    return [llength [ldifference [orbpath SAN] [orbpath YOU]]]
}