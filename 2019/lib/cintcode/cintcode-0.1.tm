set libdir [file dirname [info script]]
switch -glob $tcl_platform(os) {
   Windows* {load [file normalize [file join $libdir cmake-build-debug libcintcode.dll]]}
   Linux {load [file join $libdir bld libcintcode.so ]}
   Darwin {load [file normalize [file join $libdir bld libcintcode.dylib]]}
   default {error "No binary"}
}
