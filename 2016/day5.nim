import md5
import sequtils
import strutils

var validpos = '0'..'7'
var x: seq[string]
var x2 = "--------"
var input = "ugkcyxxp"
var i = 0
while true:
  var md5hash =  $toMD5(input & $i)
  if md5hash[0 .. 4] == "00000":
    if x.len() < 8:
       x.add(md5hash)
    
    var pos = md5hash[5]
    var value = md5hash[6]
    
    if pos in validpos:
        var now =  x2[($pos).parseInt()]
        if now == '-':
            x2[($pos).parseInt()] = value 
            echo x2       


  if not ('-' in x2):
      break
  inc i

echo "result1: " & x.mapIt(it[5]).join("")
echo "result2: " & x2.join("")

