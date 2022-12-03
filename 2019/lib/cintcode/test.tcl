load bld/libcintcode.so

catch {CintCode}

set x [CintCode "12 31 12"]
puts $x
set x [CintCode "12 31 12"]
puts $x
catch $x result
puts $result
$x input 12
