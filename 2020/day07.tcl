source setup.tcl

aoc::get-puzzle 2020 7 1
aoc::get-puzzle 2020 7 2
set input [aoc::get-input 2020 7]
jupyter::html "<h2>Input</h2>"
jupyter::display "text/plain" [string range $input 0 100]...;

    proc contents bag {
        variable contains
        set count 0
        if {![info exists contains($bag)]} {
            return 0
        } else {
            foreach b $contains($bag) {
                incr count
                incr count [contents $b]
            }
        }
        return $count
    }
        
    proc parts input {
      variable contains

        set data [string map [list contain \f] [string trim $input]]
        unset -nocomplain inbag
        unset -nocomplain contains
        foreach rule [split $data \n] {
            lassign [split $rule \f] bag has
            foreach c [split $has ,] {
                set c [string map {bags {} bag {}} [string trim $c { .} ]]
                set bag [string trim [string map {bags {} bag {}} $bag]]
                set cbag [lassign $c amount]
                if {$amount ne "no"} {
                    lappend contains($bag) {*}[lrepeat $amount  $cbag ]
                }
                lappend inbag($cbag) $bag
            }
        }
        # parray inbag
        set count 0
        set bags  $inbag(shiny gold)
        set workdone 1
        while {$workdone} {
            set workdone 0
            foreach bag $bags {
                if {[info exists inbag($bag)]} {
                    foreach cbag $inbag($bag) {
                        if {[lsearch $bags $cbag] == -1} {
                            lappend bags $cbag
                            set workdone 1 
                        }
                    }

                }
            }
        }


        set result1 [llength $bags]
        set result2 [contents "shiny gold"]
        return [list $result1 $result2]
    }
    aoc::results


