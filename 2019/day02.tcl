lappend auto_path [file dirname [info script]]/lib {C:\Users\Mark\Src\site-tcl\libs-windows}
tcl::tm::path add [file dirname [info script]]/modules [file dirname [info script]]/lib/cintcode
package require util
package require cintcode
package require intcode
tcl::tm::path add [file dirname [info script]]/../modules
package require aoc

set program  [split [aoc::read-input 2019 2] ,]
interp alias {} Machine {} CintCode 

proc runwithinput {program in1 in2} {

    set machine [Machine $::program]
    $machine setmem 1 $in1
    $machine setmem 2 $in2
    $machine run
    set result [$machine mem 0]
    rename $machine {}
    return $result
} 





proc  part1 {} { return [runwithinput $::program 12 2]}

proc part2 {} {
    foreach x [range 0 99] { 
        foreach y [range 0 99] {
            if { [runwithinput $::program $x $y] == 19690720} {
                return [expr {$x*100+$y}]
            }
        }
    }
}



if {$::argv0 eq [info script]} {
  puts [time {puts [part2]}]
  interp alias {} Machine {} IntCode new
  puts [time {puts [part2]}]
}
