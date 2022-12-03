set dir [file dirname [info script]]
switch -exact $tcl_platform(platform) {
   windows {load [file normalize [file join $dir cmake-build-debug libffft.dll]]}
   unix {load [file join $dir bld libffft.so ]}
   default {error "No binary"}
}
