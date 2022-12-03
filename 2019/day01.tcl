lappend auto_path [file dirname [info script]]/lib
tcl::tm::path add [file dirname [info script]]/modules
tcl::tm::path add [file dirname [info script]]/../modules

package require util
package require aoc

set mass [aoc::read-input 2019 1]

proc fuel {mass} {expr {$mass / 3 - 2 }}

proc part1 {} {return [sum [lmap x $::mass {fuel $x}]]}
proc part2 {} {return [sum [lmap x $::mass {sum [lrange [iterate-until fuel $x neg] 1 end] }]]}
