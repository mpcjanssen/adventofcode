source setup.tcl
package require struct::set

aoc::get-puzzle 2020 6 1
aoc::get-puzzle 2020 6 2
set input [aoc::get-input 2020 6]
jupyter::display "text/html" "<h2>Input</h2>"
jupyter::display "text/plain" [string range $input 0 100]...;

  proc parts input {
        set result1 0
        set result2 0
        set data [ split [string map [list \n\n \f] [string trim $input]] \f]
        set answers {}
        foreach group $data {
            set answers  [lmap x [split $group \n] {split $x {}}]
            #puts $answers
            incr result1 [llength [struct::set union {*}$answers]]
            incr result2 [llength [struct::set intersect {*}$answers]]
            
        }

        return [list $result1 $result2]
    }
    aoc::results


