lappend auto_path [file dirname [info script]]/lib {C:\Users\Mark\Src\site-tcl\libs-windows}
tcl::tm::path add [file dirname [info script]]/modules [file dirname [info script]]/lib/cintcode
package require util
package require cintcode
tcl::tm::path add [file dirname [info script]]/../modules
package require aoc


set program  [split [aoc::read-input 2019 17] ,]
interp alias {} Machine {} CintCode 

proc runresults {program} {

    set machine [Machine $::program]
    $machine run
    set result [$machine output]
    rename $machine {}
    return $result
}

proc toascii data {
     return [binary format c* $data] 
}

proc part1 {} {



set ascii [toascii [runresults $::program]]

set cells [split $ascii ""]
# puts [llength $cells] 
# puts [tcl::mathop::+ {*}[lmap x $cells {expr {$x eq "#"} }]]
unset -nocomplain scaffold
set x 0
set y 0
foreach c $cells {

    if {$c eq "#"} {
        set scaffold($x,$y) 1 
    }
    if {$c eq "\n"} {
        incr y
        set x 0
    } else {
        incr x
    }
    # puts $x,$y
}
set ints {}
foreach coord [array names scaffold] {
    lassign [split $coord ,] x y
    set cx $x
    set cy $y
    incr x
    if {![info exists scaffold($x,$y)]} continue
    incr x -2
    if {![info exists scaffold($x,$y)]} continue
    incr x
    incr y
    if {![info exists scaffold($x,$y)]} continue
    incr y -2
    if {![info exists scaffold($x,$y)]} continue
    lappend ints [list $cx $cy]
}
tcl::mathop::+ {*}[lmap int $ints {lassign $int x y ; expr {$x*$y}}]
}



proc part2 {} {}