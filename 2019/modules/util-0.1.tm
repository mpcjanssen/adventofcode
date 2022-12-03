set scriptdir [file dirname [info script]]
package require http


proc iterate-until {f x px} { 
  set res {}
  while {![{*}$px $x]} {
    lappend res $x
    set x [{*}$f $x]
  }
  return $res
}



proc iterate-while {f x px} { 
  set res {}
  while {[{*}$px $x]} {
    lappend res $x
    set x [{*}$f $x]
  }
  return $res
}

proc sum {l} {tcl::mathop::+ {*}$l}

proc neg {x} {return [expr {$x < 0}]}



proc range {start end} {
  set res {}
  for {set i $start} {$i < $end+1} {incr i} {
    lappend res $i
  }
  return $res
}

proc manhattan {p} {
    lassign $p x y
    return [expr {abs($x)+abs($y)}]
}

proc lintersect { a b } {
    set a [lsort $a]
    set result {}
    foreach element $b {
        if { [lsearch -sorted -increasing $a $element] != -1 } {
            lappend result $element
        }
    }
    return $result
}

 proc ldifference {a b} {
        if {[llength $a] == 0} {
            set ret $b
        } elseif {[llength $b] == 0} {
            set ret $a
        } else {
            foreach key $a {set ary($key) ""}
            set ret {}  
            foreach key $b {
                if {[info exist ary($key)]} {
                    unset ary($key)
                } {
                    lappend ret $key
                }
            }
            foreach key [array names ary] {lappend ret $key}
            # AK ?speed: eval lappend ret [array names ary]
        }
        set ret
    }

proc zoomcanvas {c sx sy pad} {
    lassign [$c bbox all] minx miny maxx maxy

    set s [expr {abs(($sx-2.0*$pad)/($maxx-$minx))}]
    set s2 [expr {abs(($sy-2.0*$pad)/($maxy-$miny))}]
    if {$s2 < $s} {set s $s2}

    $c move all [expr {-$minx}]  [expr {-$miny}]
    $c scale all 0 0 $s $s
    $c move all $pad $pad
}
 
 proc dot {c x y size color {tags {}}} {
   set size [expr {$size/2.0}]
    $c create oval [expr {$x-$size}] [expr {$y-$size}]  [expr {$x+$size}] [expr {$y+$size}] -fill $color -tags $tags

}
 proc square {c x y size color {tags {}}} {
   set size [expr {$size/2.0}]
    $c create rectangle [expr {$x-$size}] [expr {$y-$size}]  [expr {$x+$size}] [expr {$y+$size}] -fill $color -tags $tags

}

proc lfilter {l pred} {
  set res {}
  foreach e $l {
    if {[$pred $e]} {
      lappend res $e
    }
  }
  return $res
} 

 # Return a list with all the permutations of elements in list 'items'.
 #      
 # Example: permutations {a b} > {{a b} {b a}}
 proc permutations items {
     set l [llength $items]
     if {[llength $items] < 2} {
        return $items
     } else {
        for {set j 0} {$j < $l} {incr j} {
            foreach subcomb [permutations [lreplace $items $j $j]] {
                lappend res [concat [lindex $items $j] $subcomb]
            }
        }
        return $res
     }
 }
     
 # Like foreach but call 'body' for every permutation of the elements
 # in the list 'items', setting the variable 'var' to the permutation.
 #   
 # Example: foreach-permutation x {a b} {puts $x}
 # Will output:
 # a b          
 # b a
 proc foreach-permutation {var items body} {
     set l [llength $items]
     if {$l < 2} {
        uplevel [list set $var [lrange $items 0 0]]
        uplevel $body
     } else {
        for {set j 0} {$j < $l} {incr j} {
            foreach-permutation subcomb [lreplace $items $j $j] {
                uplevel [list set $var [concat [lrange $items $j $j] $subcomb]]
                uplevel $body
            }
        }
     }
 }

proc freq {s} {
    set freqs {}
    foreach d [split $s {}] {
        dict incr freqs $d 
    }
    return $freqs
}

proc every {ms cmd} {
  coroutine $cmd-co $cmd
  _every $ms $cmd-co
}

proc _every {ms cmd} {
        set res [{*}$cmd]
        if {$res} {
          after $ms [list after idle [namespace code [info level 0]]]
        }
}

proc getdef {dict idx def} {
  if {[dict exists $dict $idx]} {
    return [dict get $dict $idx]
  } {
    return $def
  }
}

proc svgpixel {x y idprefix border color} {
    return "<rect id=\"$idprefix-$x-$y\" x=\"$x\" y = \"$y\" width=\"1\" height=\"1\" style=\"fill:$color;stroke-width:$border;stroke:rgb(255,255,255)\" />"
}

proc timereturn {block} {uplevel 1 [list time [list set res $block]] ; uplevel 1 [list puts $res]}