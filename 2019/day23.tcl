lappend auto_path [file dirname [info script]]/lib {C:\Users\Mark\Src\site-tcl\libs-windows}
tcl::tm::path add [file dirname [info script]]/modules [file dirname [info script]]/lib/cintcode
package require util
package require cintcode

tcl::tm::path add [file dirname [info script]]/../modules
package require aoc

set program  [split [aoc::read-input 2019 23] ,]
interp alias {} Machine {} CintCode ;

unset -nocomplain queue 
set queue {}
foreach ip [range 0 49] {
    set cpu($ip) [Machine $program]
    $cpu($ip) input $ip
    $cpu($ip) run
    dict set state $ip running
}
set i 0
set onedone 0
set prev {}
while 1 {
    incr i
    set id [expr {$i % 50}]
    if {[lindex [lsort -stride 2 -index 1 -decreasing $state] 1 ] ne "running"} {
        # puts "All idle using NAT $nat"
        lassign $nat x y
        if {$prev eq $y} {
            set ::part2 $y
            return
        } else {
            set prev $y
        }
        set queue [list 0 {*}$nat]
        dict set state 0 running
    }
    
    while {$queue ne {}} {
         set queue [lassign $queue dest x y]
         
         if {$dest == 255} {
             if {!$onedone} {
                 set ::part1 $y
                 set onedone 1
             }
             set nat [list $x $y]
             break
         }
         # puts "$dest <- $x $y "
         $cpu($dest) input $x
         $cpu($dest) input $y
         $cpu($dest) run
         lappend queue {*}[$cpu($dest) outputs]
         $cpu($dest) clearoutputs
    }
    $cpu($id) input -1
    $cpu($id) run
    set outputs [$cpu($id) outputs]
    if {$outputs eq {}} {
        dict set state $id idle
    } else {
        lappend queue {*}[$cpu($id) outputs]
        $cpu($id) clearoutputs
        dict set state $id running
    }
    if {$i % 10000 == 0} {
        puts $i
       
    }
    if {$i == 1000000} break
}

foreach id [array names cpu] {rename $cpu($id) {}}



