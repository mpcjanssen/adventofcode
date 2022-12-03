package require tcltest
namespace import ::tcltest::*
puts [time {set result [runAllTests]}]

exit $result
