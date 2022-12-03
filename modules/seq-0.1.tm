# A library for lazy sequences
# heavily inspired by clojure seq's and stdlib

namespace eval seq {
    namespace export filter into peek range do map listseq lineseq take takeseq dup iterate cons first reduce iterate-until drop
    set nameidx 0

    # namespace for the created seq commands
    namespace eval seqs {}
   
    proc first {seq} {
        checkseq $seq
        return [{*}$seq]
    }

    # check if the command seq exists to make clearer errors if seq commands are
    # exhausted and thus removed

    proc checkseq {seq} {
        if {[info commands $seq] eq {}} {
            return -level 2 -code error "Seq $seq is not an existing command"
        }
    }

    proc @ {f args} {
      if {[string index $f 0] eq "&"} {
          return [apply [string range $f 1 end] {*}$args]
      } else {
          return [{*}$f {*}$args]
      }
    }

    # helper to create a unique seq comman name
    proc seqname {} {
        variable nameidx
        incr nameidx
        return ::seq::seqs::$nameidx
    }

    # helper to create a seq command with coro backing
    proc createcoro {impl args} {
        return [coroutine [seqname] $impl {*}$args]
    }

    proc listseqimpl {l} {
        yield [info coroutine]
        foreach i $l {
            yield $i
        }
        return -code break
    }

    # create a sequence from a list
    proc listseq list {
        return [createcoro listseqimpl $list]
    }

    proc lineseqimpl {chan} {
        yield [info coroutine]
        while {[gets $chan line] >= 0} {
            yield $line
        }
        return -code break
    }

    # create a sequence of lines retrieved with [gets] from chan
    proc lineseq chan {
        return [createcoro lineseqimpl $chan]
    }

    # Execute the one argument function f for every seq element 
    # lambdas can be pass as &{}
    proc do {f seq} {
        while 1 {
            @ $f [{*}$seq]
        }
    }

    proc mapimpl {f seq} {
        yield [info coroutine]
        while 1 {
            yield [@ $f [{*}$seq]] 
        }
        return -code break
    }

    # return a new seq with f applied to every element
    proc map {f seq} {
        return [createcoro mapimpl $f $seq]
    }

    # take the {*}count elements from seq
    proc take {count seq} {
        set result {}
        for {set i 0} {$i < $count} {incr i} {
            lappend result [{*}$seq]
        }
        return $result
    }

    # Take the {*}count elements and return them as a seq
    proc takeimpl {count seq} {
        yield [info coroutine]
        for {set i 0} {$i < $count} {incr i} {
            yield [{*}$seq]
        }
        return -code break
    }
    proc takeseq {count seq} {
        return [createcoro takeimpl $count $seq]
    }

    proc dupimpl {count seq} {
        yield [info coroutine]
        for {set i 0} {$i < $count} {incr i} {
            set elem [{*}$seq]
            yield $elem
            yield $elem
        }
        while 1 {
            yield [{*}$seq] 
        }
        return -code break
    }
    # duplicate the {*}count elements and return the new seq
    proc dup {count seq} {
        return [createcoro dupimpl $count $seq]
    }

    proc iterimpl {pred f x} {
        yield [info coroutine]
        yield $x
        while 1 {
            set x [@ $f $x]
            if {$pred ne {} && [@ $pred $x]} {
                return -code break
            } {
                yield $x
            }
        }
        # infinite sequence
    }

    # create an infinite sequence of {x [f x] [f [f x]] ....}
    # where f is expanded
    proc iterate {f x} {
        return [createcoro iterimpl {} $f $x]
    }

    # create an sequence of {x [f x] [f [f x]] ....}
    # where f is expanded
    # stop when pred becomes true
    # the element where pred is true is not included in the sequence
    proc iterate-until {pred f x} {
        return [createcoro iterimpl $pred $f $x]
    }


    proc rangeimpl {start end} {
        yield [info coroutine]
        incr end
        for {set i $start} {$i < $end} {incr i} {
            yield $i
        }
        return -code break
    }

    # create a sequence with items start to end (inclusive)
    proc range {start end} {
        return [createcoro rangeimpl $start $end]
    }

    # realize the seq into an eager tcl string.
    # type = list       -> append all elements to the list and return the result
    # type = listvar    -> append all elements to the list in listvar
    proc into {type arg seq} {
        switch -exact $type {
            list {
                set result $arg
                while {1} {
                    lappend result [{*}$seq]
                }
                return $result
            }
            listvar {
                upvar $arg v
                while {1} {
                    lappend v [{*}$seq]
                }
                return
            }
            default {
                error "unknown type $type"
            }
        }
    }

    proc consimpl {item seq} {
        yield [info coroutine]
        yield $item
        while 1 {
            yield [{*}$seq]
        }
        return -code break
    }

    # prepend item to the seq and return the new seq
    proc cons {item seq} {
       checkseq $seq
       return [createcoro consimpl $item $seq]
    }

    # get the first element of seq without removing it
    # NB: this obviously will realize the first element
    proc peek {seq} {
        checkseq $seq
        set newname [seqname]
        rename $seq $newname
        set value [first $newname]
        set newseq [cons $value $newname]
        puts $newseq
        # save the original seek
        # and swap wit the new on
        rename $newseq $seq
        return $value
    }

    proc drop {seq} {
        $seq
        return $seq
    }

    proc filterimpl {pred seq} {
        yield [info coroutine]
        while 1 {
            set item [$seq]
            if {[@ $pred $item]} {
                yield $item
            }
        }
        return -code break
    }

    # return a seq with all elements for which the predicate is true
    proc filter {pred seq} {
       checkseq $seq
       return [createcoro filterimpl $pred $seq]
    }

    # Reduce the seq with f
    proc reduce {start f seq} {
        checkseq $seq
        set result $start
        while 1 {
            set result [@ $f $result [$seq]]
        }
        return $result
    }
}
