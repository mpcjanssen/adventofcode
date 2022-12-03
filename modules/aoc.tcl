set scriptdir [file dirname [info script]]
package require http
source [file join $scriptdir cookie.tcl]

package require tdom

proc cookie year {
    global cookies
    foreach {pat cky} $cookies {
        if {[string match $pat $year]} {
            return session=$cky
        }
    }
    return -code error "No cookie for year $year"
}

catch {
    package require twapi
    http::register https 443 twapi::tls_socket
}

catch {
    package require tls
    http::register https 443 tls::socket
}


# add [dict getdef] on Tcl < 8.7

if {[catch {package require Tcl 8.7}]} {
    proc tcl::dict::getdef {D args} {
        if {[dict exists $D {*}[lrange $args 0 end-1]]} then {
             dict get $D {*}[lrange $args 0 end-1]
         } else {
             lindex $args end
         }
     }

    set nscmds [namespace ensemble configure dict -map]
    lappend nscmds getdef ::tcl::dict::getdef
    namespace ensemble configure dict -map $nscmds
}

if {[info procs ::jupyter::html] eq {}} {
   # Not running in jupyter
   # define dummy jupyter commands
   namespace eval jupyter {}
   proc ::jupyter::display args {}
   proc ::jupyter::html args {}
   set intests 1
   
}

namespace eval aoc {
        proc count {str needle} {
            set l [string length $str]
            set str [string map [list $needle {}] $str]
            set nl [string length $str]
            return [expr {($l - $nl) / [string length $needle]}]
        }
        
        proc showgrid grid {
            puts "\n=========="
            puts [llength [lindex $grid 0]]x[llength $grid]
            puts "=========="
            puts [join [lmap l $grid {join $l ""}] \n]
            return $grid
        }

        
        proc togrid {input} {
            lmap l [split $input \n] {split $l ""}
        }
        
        
        proc todict {input} {
            set y 0
            set dict {}
            foreach r [togrid $input] {
                set x 0
                foreach c $r {
                    dict set dict [list $x $y] $c
                    incr x
                }
                incr y
            }
            return $dict
        }
        proc testresults {} {
               set t1 [time {lassign [part1 $::input] result1}]
               set t2 [time {lassign [part2 $::input] result2}]
               
               puts "Day1\t$result1 ($t1)"
               puts "Day2\t$result2 ($t2)"
               puts ===\n$t1\n$t2\n===
               return [list $result1 $result2]
        }


        proc solve {input body} {
           set t1 [lindex [time {set result1 [coroutine ::aoc::parts apply [list input $body] $input]}] 0]
           puts "Part1\t$result1 ($t1 us)"
           set t2 [lindex [time {set result2 [::aoc::parts]}] 0]
           puts "Part2\t$result2 ($t2 us)"

        }
        

        proc get-puzzle {year day part} {
            set fname [file join .. $year puzzles $day-$part.html]
            file mkdir [file dirname $fname]
    if {[file exists $fname]} {
        set f [open $fname]
        fconfigure $f -encoding utf-8
        set data [read $f]
        close $f
        jupyter::display text/plain (cached)
        jupyter::display text/html $data
        return
    } 
    incr part -1
 

    set tok [http::geturl https://adventofcode.com/$year/day/$day -headers [list Cookie [cookie $year] ]]
    set html [http::data $tok]
    if {[http::ncode $tok] ne 200} {
        http::cleanup $tok
        puts stderr $html
        return
    }
    # puts $html
    dom parse -keepEmpties -html5 $html doc
    set parthtml [lindex [$doc selectNodes //article] $part]
    if {$parthtml eq {}} {
        incr part
        puts stderr "Part $part not available"
        return
    }
    set html [$parthtml asHTML]

    jupyter::html  $html
        set f [open $fname w]
    fconfigure $f -encoding utf-8
    puts -nonewline $f $html
    close $f
    http::cleanup $tok
    }
    

    proc get-input {year day} {
    set fname [file join .. $year input $day.txt]
    file mkdir [file dirname $fname]
    if {[file exists $fname]} {
        jupyter::display text/plain (cached)
        set f [open $fname]
        fconfigure $f -encoding utf-8
        set data [read $f]
        close $f
        return $data
    } 

    set tok [http::geturl https://adventofcode.com/$year/day/$day/input -headers [list Cookie [cookie $year] ]]
    set data [http::data $tok]
        if {[http::ncode $tok] ne 200} {
        http::cleanup $tok
        return -code error $data
    }
    http::cleanup $tok
    set f [open $fname w]
    fconfigure $f -encoding utf-8
    puts -nonewline $f $data
    close $f
    return $data
    }
    
     proc permutations {list} {
    set res [list [lrange $list 0 0]]
    set posL {0 1}
    foreach item [lreplace $list 0 0] {
       set nres {}
       foreach pos $posL {
          foreach perm $res {
             lappend nres [linsert $perm $pos $item]
          }
       }
       set res $nres
       lappend posL [llength $posL]
    }
    return $res
 }
 proc neighbours8 {x y} {
      subst { {[- $x 1] [- $y 1]}
              {[- $x 1] $y}
              {[- $x 1] [+ $y 1]}
              {$x [- $y 1]}
              {$x [+ $y 1]}
              {[+ $x 1] [- $y 1]}
              {[+ $x 1] $y}
              {[+ $x 1] [+ $y 1]}}
}

proc neighbours4 {x y} {
      subst {{[- $x 1] $y} {$x [- $y 1]} {$x [+ $y 1]} {[+ $x 1] $y}}
}

proc manhattan {x y} {
    expr {abs($x) + abs($y)}
}

 proc combinations { list size } {
     if { $size == 0 } {
         return [list [list]]
     }
     set retval {}
     for { set i 0 } { ($i + $size) <= [llength $list] } { incr i } {
         set firstElement [lindex $list $i]
         set remainingElements [lrange $list [expr { $i + 1 }] end]
         foreach subset [combinations $remainingElements [expr { $size - 1 }]] {
             lappend retval [linsert $subset 0 $firstElement]
         }
     }
     return $retval
 }
  proc range args {
    # Check arity
    set l [llength $args]
    if {$l == 1} {
        set start 0
        set step 1
        set end [lindex $args 0]
    } elseif {$l == 2} {
        set step 1
        foreach {start end} $args break
    } elseif {$l == 3} {
        foreach {start end step} $args break
    } else {
        error {wrong # of args: should be "range ?start? end ?step?"}
    }

    # Generate the range
    set rlen [rangeLen $start $end $step]
    if {$rlen == -1} {
        error {invalid (infinite?) range specified}
    }
    set result {}
    for {set i 0} {$i < $rlen} {incr i} {
        lappend result [expr {$start+($i*$step)}]
    }
    return $result
 }
  proc rangeLen {start end step} {
    if {$step == 0} {return -1}
    if {$start == $end} {return 0}
    if {$step > 0 && $start > $end} {return -1}
    if {$step < 0 && $end > $start} {return -1}
    expr {1+((abs($end-$start)-1)/abs($step))}
 }
 
 proc html2md {html} {
     if {[interp exists html2md]} {interp delete html2md}
     interp create html2md
     interp eval html2md {
         package require tdom
        expat aocparser -elementstartcommand estart -elementendcommand eend -characterdatacommand echar -ignorewhitecdata 0
                 set markdown {}
        set ltype {}
        set inpre 0
        set link ""
        proc estart {name attrs} {
            variable markdown
            variable ltype
            variable inpre
            variable link
            switch -exact $name {
                article {}
                a {
                    set link [dict get $attrs href]
                    append markdown {[}
                }
                em { append markdown <b> }
                ul {set ltype ul}
                li { 
                    if {$ltype eq "ul"} {
                        append markdown "\n- " 
                    } else {
                        append markdown "\n1. "
                    }
                }
                p { append markdown \n\n}
                h2 { append markdown "\n## " }
                span {}
                code {if {!$inpre} {append markdown `}}
                pre {
                    append markdown \n```\n
                    set inpre 1
                }
                default {error "start tag $name:$attrs not supported"}
            }
        }
        proc eend {name} {
            variable markdown
            variable ltype
            variable inpre
            variable link

            switch -exact $name {
                article {}
                ul {append markdown \n}
                li {}
                a {
                    append markdown {]}
                    append markdown ($link)
                }
                em { append markdown </b> }
                p { append markdown \n\n}
                h2 { append markdown "\n\n" }
                span {}
                code {if {!$inpre} {append markdown `}}
                pre {
                    append markdown \n```\n
                    set inpre 0
                }
                default {error "end tag $name not supported"}
            }
        }
        proc echar text {
            variable markdown
            append markdown $text
        }

     }
     interp eval html2md [list aocparser parse $html]
     set result [interp eval html2md {set markdown}]
     interp delete html2md
     return $result
 }


}