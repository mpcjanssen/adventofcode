source setup.tcl

aoc::get-puzzle 2020 4 1
aoc::get-puzzle 2020 4 2
set input [aoc::get-input 2020 4]
jupyter::display "text/html" "<h2>Input</h2>"
jupyter::display "text/plain" [string range $input 0 100]...

proc validhgt {hgt} {
    if {[regexp {^([0-9]+)(cm|in)$} $hgt -> size unit]} {
        switch $unit {
            in {return [expr {$size >= 59 && $size <=76}]}
            cm {return [expr {$size >= 150 && $size <=193}]}
        }

    }
    return false
}

proc parts input {
    set result1 0
    set result2 0
    set data [split [string map [list \n\n \f \n { }] $input] \f]
    foreach line $data {
        set pass {}
        set fields {}
        set dict [lsearch -all -inline -not  [lsort [lmap l $line {split $l : }]] cid]

        foreach field  $dict  {
            lappend fields [lindex $field 0]
            lappend pass {*}$field
        }
        array set apass $pass
        if {$fields ne [lsort {byr iyr eyr hgt hcl ecl pid}] && $fields ne [lsort {byr iyr eyr hgt hcl ecl pid cid}] } {
            continue
        }
        incr result1
        dict with pass {
            if {$byr < 1920 || $byr > 2002} continue
            if {$iyr < 2010 || $iyr > 2020} continue
            if {$eyr < 2020 || $eyr > 2030} continue
            if {![regexp {^#[0-9a-f]{6}$} $hcl]} continue
            if {![validhgt $hgt]} continue
            if {$ecl ni {amb blu brn gry grn hzl oth}} continue
            if {![regexp {^[0-9]{9}$} $pid]} continue
        }
        incr result2
    }
    return [list $result1 $result2]
}
aoc::results


