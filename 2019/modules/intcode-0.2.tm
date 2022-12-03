oo::class create IntCode {
  variable Mem PC Base State Inputs Outputs
  constructor {program} {
    set Mem(0) 0 
    set idx 0
    foreach val $program {
      set Mem($idx) $val
      incr idx
    }
    # parray Mem
    set PC 0
    set Base 0
    set Inputs {}
    set Outputs {}
    set State idle
  }

  method input {in} {
    lappend Inputs $in
    if {$State eq "input-pending"} {
      set State running
    }
  }

  method outputs {} {
    return $Outputs
  }

  method mem {idx} {
    if {[info exists Mem($idx)]} {
        return $Mem($idx)
      } else {
        set Mem($idx) 0
        return 0
      }
  }

  method setmem {idx val} {
    set Mem($idx) $val
  }

  method getval {param mode} {
    switch -exact $mode {
      0 -
      2 {return $Mem([my getaddress $param $mode])}
      1 {return $param}
      default {error "Unknown mode $mode"}
    }
  }

  method getaddress {param mode} {
    return [expr {$param + ($mode >> 1) * $Base } ]
  }

  method run {} {
    set State running
    while {$State eq "running"} {
    variable Mem


    set inst $Mem($PC)
    # puts Mem($PC)=$Mem($PC)
    set opcode [expr {$inst % 100}]
    set mode [expr {$inst/100}]
    # puts $inst:$opcode:$mode
    set PC2 $PC
    set param1 $Mem([incr PC2])  
    set param2 $Mem([incr PC2])  
    set param3 $Mem([incr PC2])
    set mode1 [expr {$mode % 10}]
    set mode2 [expr {$mode/10 % 10}]
    set mode3 [expr {$mode/100}]
    

    set val1 [my getval $param1 $mode1]
    set val2 [my getval $param2 $mode2]
    # puts "Mem\[$PC\] => $opcode\($param1|$mode1=$val1, $param2|$mode2=$val2, $param3|$mode3\)"
    
    
    switch -exact $opcode {
      1 {
        set Mem([my getaddress $param3 $mode3]) [expr {$val1+$val2}]
        incr PC 4
      }
      2 {
        set Mem([my getaddress $param3 $mode3]) [expr {$val1*$val2}]
        incr PC 4
      }
      3 {
        if {[llength $Inputs] == 0} {
          set State input-pending
        } else {
          set Inputs [lassign $Inputs in]
          set Mem([my getaddress $param1 $mode1]) $in
          incr PC 2
        }
      }
      4 {
        lappend Outputs $val1
        incr PC 2
      }
      5 {
        if {$val1} {
          set PC $val2
        } {
          incr PC 3
        }
      }
      6 {
        if {!$val1} {
          set PC $val2
        } {
          incr PC 3
        }
      }
      7 {
        if {$val1 < $val2} {
          set Mem([my getaddress $param3 $mode3]) 1
        } {
          set Mem([my getaddress $param3 $mode3]) 0
        }
        incr PC 4
      }
      8 {
        if {$val1 == $val2} {
          set Mem([my getaddress $param3 $mode3]) 1
        } {
          set Mem([my getaddress $param3 $mode3]) 0
        }
        incr PC 4
      }
      9 {
        incr Base $val1
        incr PC 2
      }
      99 {
        set State stopped
      }
      default {
        error "Unknown opcode $opcode"
      }

    }
        
  }
}
  method state {} {
    return $State
  }
}


 
