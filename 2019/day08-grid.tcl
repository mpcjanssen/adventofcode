lappend auto_path [file dirname [info script]]/lib
tcl::tm::path add [file dirname [info script]]/modules
tcl::tm::path add [file dirname [info script]]/../modules
package require util
package require aoc

set data [aoc::read-input 2019 8]

set width 25
set height 6
set layersize [expr {$width*$height}]
set pat [string repeat . $layersize]
set layers [regexp -all -inline $pat $data]

proc freq1s {d} {
    dict get $d 1
}

proc part1 {} {
    set min0freqs [lindex [lsort -integer -index 1 [lmap x $::layers {lsort -integer -stride 2 -index 0 [freq $x]}]] 0]
    return [expr {[dict get $min0freqs 1]*[dict get $min0freqs 2]}]
}

proc visualize-step {} {

    package require Tk
    set rows {} 
    foreach y [range 0 5] { 
        set line {}

        foreach x [range 0 24] { 
            lappend line [frame .f-$y-$x -width 20 -height 20]
        }
        lappend rows $line
    }
    set idx 0 ;
    foreach row $rows {grid  {*}$row  -row $idx -sticky nsew; incr idx }
    grid columnconfigure . all -weight 1
    grid rowconfigure . all -weight 1
    

    foreach l [lreverse $::layers] {
        set pixels [split $l {}]
        foreach x [range 0 24] {
            foreach y [range 0 5] {
                set col [lindex $pixels [expr {$y*25+$x}]]
                switch $col {
                    0 {.f-$y-$x configure -bg white}
                    1 {.f-$y-$x configure -bg black}
                }
            }
        }
        # zoomcanvas .c 800 800 10
        update
        
    }
    
}


proc visualize {} {
    puts [time {visualize-step}]
    console show
}

proc part2 {} {
    return YEHEF
}

if {$::argv0 eq [info script]} {
    visualize
}
