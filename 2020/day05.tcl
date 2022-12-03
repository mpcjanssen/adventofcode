source setup.tcl

aoc::get-puzzle 2020 5 1
aoc::get-puzzle 2020 5 2
set input [aoc::get-input 2020 5]
jupyter::display "text/html" "<h2>Input</h2>"
jupyter::display "text/plain" [string range $input 0 100]...;

    proc parts input {
        set result1 0
        set result2 0
        set seats {}
        set data [split [string map [list F 0 B 1 R 1 L 0] [string trim $input]] \n]
        foreach line $data {
            lappend seats [expr 0b$line]
        }
        set result1 [lindex [lsort -dec -int $seats] 0]
        set onplane 0
        set id 0
        while 1 {
            incr id
            if {$result2 !=0} break
            if {[lsearch $seats $id] == -1} {
                if {$onplane} {
                    set result2 $id 
                }
            } {
                set onplane 1
            }
        }
        return [list $result1 $result2]
    }
    aoc::results


