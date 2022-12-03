lappend auto_path [file dirname [info script]]/lib
tcl::tm::path add [file dirname [info script]]/modules [file dirname [info script]]/lib/cintcode
package require util
package require cintcode
tcl::tm::path add [file dirname [info script]]/../modules
package require aoc

proc newdir {dx dy dir} {
    switch -exact [list $dx $dy $dir] {
        {0 -1 0} {return {-1 0}}
        {0 -1 1} {return {1 0}}
        {0 1 0} {return {1 0}}
        {0 1 1} {return {-1 0}}
        {-1 0 0} {return {0 1}}
        {-1 0 1} {return {0 -1}}
        {1 0 0} {return {0 -1}}
        {1 0 1} {return {0 1}}
        default {error "Invalid combination [list $dx $dy $dir]"}
    }
}

set program [split [aoc::read-input 2019 11] ,]

proc run {program start gridVar} {
    upvar $gridVar colors
    set colors(0,0) $start
    set x 0
    set y 0
    set dx 0
    set dy -1

    set machine [CintCode $program]
    $machine input $start
    $machine run
    while {[$machine state] ne "stopped"} {
        lassign [$machine outputs] colors($x,$y) dir
        $machine clearoutputs
        lassign [newdir $dx $dy $dir] dx dy
        incr x $dx
        incr y $dy
        set input 0
        catch {
            set input $colors($x,$y)
        }
        $machine input $input
        $machine run
    }
}

proc part1 {} {
    run $::program 0 colors
    llength [array names colors]
}


proc visualize {aVar} {
  upvar $aVar colors
  set svg {}
  foreach name [array names colors] {
     if  {$colors($name) == 1} {
         lassign [split $name ,] x y
         lappend svg  [svgpixel  $x $y vis1  0.01 black]
     }
  }
    jupyter::html "<svg viewbox=\"0 0 40 100\">[join $svg \n]</svg>"
}

proc part2 {visualize} {
    run $::program 1 colors
    if {$visualize} {
        visualize colors
    } else {
        return HJALJZFH
    }
    
}