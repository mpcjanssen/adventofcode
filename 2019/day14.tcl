lappend auto_path [file dirname [info script]]/lib
tcl::tm::path add [file dirname [info script]]/modules [file dirname [info script]]/lib/cintcode
package require util

tcl::tm::path add [file dirname [info script]]/../modules
package require aoc

set data [split [aoc::read-input 2019 14] \n];

set ex1 [split {10 ORE => 10 A
1 ORE => 1 B
7 A, 1 B => 1 C
7 A, 1 C => 1 D
7 A, 1 D => 1 E
7 A, 1 E => 1 FUEL} \n]
set ex2 [split {9 ORE => 2 A
8 ORE => 3 B
7 ORE => 5 C
3 A, 4 B => 1 AB
5 B, 7 C => 1 BC
4 C, 1 A => 1 CA
2 AB, 3 BC, 4 CA => 1 FUEL} \n];

proc book data {
    set book {}
    foreach line $data {
        set parts [lassign [lreverse [lmap x [split [string map {", " @ " => " @ " "  @ } $line] @] {string trim $x}]] comp amount]
        dict set book $comp [list $amount $parts]
    }
    return $book
}


proc reqs {book comp reqamount stock} {

    lassign [dict get $book $comp] amount parts

    set extra 0
    set times [expr {$reqamount / $amount}]
    set extra [expr {$reqamount % $amount}]
    if {$extra != 0} {
        incr times
        dict incr stock $comp [expr {$amount - $extra}]
    }
    set reqs {}
    foreach {req amount} $parts {
        lappend reqs $req [expr {$amount * $times}]
    }
    return [list $reqs $stock]
}
reqs [book $data] FUEL 1 {}

proc produce {book parts stock} {
    set res {}
    foreach {part reqamount} $parts {
        if {$part eq "ORE"} {
            dict incr res $part $reqamount
            continue
        }
        if {[dict exists $stock $part]} {
        set instock [dict get $stock $part]
        if {$instock > $reqamount } {
            dict incr stock $part -$reqamount
            continue
        } else {
            set stock [dict remove $stock $part]
            incr reqamount -$instock
        }
        }
        lassign [reqs $book $part $reqamount $stock] reqs stock
        foreach {req amount} $reqs {

            dict incr res $req $amount
        } 
    }
    return [list $res $stock]
}


proc part1 {data} {
    set reqs {FUEL 1}
    set stock {}
    while {1} {
        lassign  [produce [book $data] $reqs $stock] reqs stock
        if {[llength $reqs] == 2 } break
    }
    return $reqs
}
part1 $data

set book [book $data];


proc part2 {ores book} {
set upper $ores
set lower 0


while 1 {
    set try [expr {($upper-$lower)/2+$lower}]
    # puts "Trying $try"
    set reqs [list FUEL $try]
    set stock {}
    while {1} {
        lassign  [produce $book $reqs $stock] reqs stock
        if {[llength $reqs] == 2 } break
    }
    set ores [lindex $reqs end]
    if { $ores > 1000000000000} {
        set upper $try
    } else {
        set lower $try
    }
    if {$upper - $lower == 1} {
        # puts "Result $lower"
        break
    }
}
return $lower
}



