source setup.tcl
tcl::tm::path add [file normalize ./lib/speak]
package require speak

aoc::get-puzzle 2020 15 1
aoc::get-puzzle 2020 15 2
set input [aoc::get-input 2020 15]
jupyter::html "<h2>Input</h2>"
jupyter::display "text/plain" [string range $input 0 100]...;

proc part {input count} {
    array default set ll ""
    set turn 1
    foreach in [lrange $input 0 end-1] {
       set ll($in) $turn
       incr turn
    }

    set speak [lindex $input end]


    while {$turn < $count} {
        set prevturn $turn
        incr turn
        set last  $ll($speak)
        # puts "=== Turn $turn\nSpoke $speak\n\tSpoken before at $last\n\t$prevturn - $last"
        set ll($speak) $prevturn
        
        # puts  "Turn $turn: last spoken $speak. Last before that $llast-> $prevturn - $llast = "
        
        # puts $curr->$last-$llast
        switch $last {
            "" {
                set speak 0
            }
            default {
                set speak [- $prevturn $last]
            }
        }
        # puts $turn:$curr
        # parray ll
    }
    return $speak
}

# time {puts [ part {0 3 6} 2020 ]}


proc parts input {
    set input [split [string trim $input] ,]
    set result1 [speak $input 2020]
    set result2 [speak $input 30000000]
    return [list $result1 $result2]
}
aoc::results 


