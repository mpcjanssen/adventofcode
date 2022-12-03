lappend auto_path [file dirname [info script]]/lib
lappend auto_path /usr/lib/tcltk/x86_64-linux-gnu/
tcl::tm::path add [file dirname [info script]]/modules
tcl::tm::path add [file dirname [info script]]/../modules

source [file dirname [info script]]/aoc.tcl
load [file normalize [file dirname [info script]]/../src/md5/libaocmd5.so] Aocmd5
namespace import tcl::mathop::*
