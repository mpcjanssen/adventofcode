set input [read stdin]

puts $input

set part1 0
proc part1 args {
    lassign $args _ x y
    puts $x,$y
    incr ::part1 [expr {$x * $y}]
}

regsub -all -command {mul\(([0-9]+),([0-9]+)\)} $input part1

puts $part1