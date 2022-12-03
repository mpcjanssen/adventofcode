lappend auto_path [file dirname [info script]]/lib
tcl::tm::path add [file dirname [info script]]/modules
tcl::tm::path add [file dirname [info script]]/../modules
package require util
package require intcode
package require aoc


set data [aoc::read-input 2019 3]



proc line {input name} {
    set line {{0 0}} 
    foreach desc [split $input , ] {
        addsegment line $desc $name
    }
    return $line
}



proc addsegment {lineVar desc name} {
     upvar $lineVar line
    upvar #0 $name dist
     set dir [string index $desc 0]
     set length [string range $desc 1 end]
     set start [lindex $line end]
     lassign $start sx sy
     set dx 0
     set dy 0
     switch -exact $dir {
         U { set dy 1}
         D {set dy -1}
         L {set dx -1}    
         R {set dx 1}
     }

    foreach _ [range 1 $length] {
        incr sy $dy
        incr sx $dx
        lappend line [list $sx $sy]
    }
}

lassign [split $::data \n] in1 in2
set l1 [line $in1 d1] 
set l2 [line $in2 d2] 


set ints [lintersect $l1 $l2]

proc part1 {} {
    
    return [lindex [lsort -integer -index 0 [lmap x $::ints  {list [manhattan $x] $x}]] 1]
}

proc linesum {p} {
    sum [list [lsearch -exact $::l1 $p]  [lsearch -exact $::l2 $p]]
}

proc part2 {} {
    return [lindex [lsort -integer -index 0 [lmap x $::ints {list [linesum $x] $x}]] 1]
}


proc addvisualsegment {start desc} {
     set dir [string index $desc 0]
     set length [string range $desc 1 end]
     lassign $start sx sy
     switch -exact $dir {
         U { set ey [expr {$sy+$length}] ; set ex $sx}
         D { set ey [expr {$sy-$length}] ; set ex $sx}
         R { set ex [expr {$sx+$length}] ; set ey $sy}
         L { set ex [expr {$sx-$length}] ; set ey $sy}
     }
     return [list $ex $ey]            
}

proc visualizeline {c input color name} {
    set current {0 0} 
    set points $current
    foreach desc [split $input , ] {
        set current [addvisualsegment $current $desc]
        lassign $current x y
        lappend points {*}$current
    }
    $c create line {*}$points -fill $color -tags $name
}


proc visualize {} {
    set pad 10
    set sx 800
    set sy 800
    set dotsize 100
    
    package require Tk
    wm geometry . ${sx}x${sy}
    destroy .c
    canvas .c
    after idle {pack .c -expand 1 -fill both}
    lassign [split $::data \n] in1 in2
    visualizeline .c $in1 red in1
    visualizeline .c $in2 green in2
    dot .c 0 0 $dotsize red
    dot .c 248 0 $dotsize blue
    dot .c 367 0 $dotsize orange
    zoomcanvas .c $sx $sy $pad
}

if {$::argv0 eq [info script]} {
  visualize
}



