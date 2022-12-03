lappend auto_path [file dirname [info script]]/lib
tcl::tm::path add [file dirname [info script]]/modules
tcl::tm::path add [file dirname [info script]]/../modules
package require aoc
