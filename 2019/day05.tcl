lappend auto_path [file dirname [info script]]/lib
tcl::tm::path add [file dirname [info script]]/modules [file dirname [info script]]/lib/cintcode
package require util
package require cintcode

tcl::tm::path add [file dirname [info script]]/../modules
package require aoc

proc ex1 {} {
    set machine [CintCode {1002 4 3 4 33}]
    $machine run
    return [$machine mem 4]
}

proc part1 {} {
    set program [aoc::read-input 2019 5]
    set machine [CintCode [split $program , ]]
    $machine input 1
    $machine run
    return [list [$machine state] [$machine outputs]]
}

proc part2 {} {
    set program [aoc::read-input 2019 5]
    set machine [CintCode [split $program , ]]
    $machine input 5
    $machine run
    return [list [$machine state] [$machine outputs]]
}
