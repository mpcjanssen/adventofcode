import md5
import std/strutils

const secret = "iwrupvqb"
var idx = 0
var found5 = false
var found6 = false
while (not found5) or (not found6):
  if (not found6) and getMD5(secret & $start).startsWith("000000"):
    echo $idx
    found6 = true
  if (not found5) and getMD5(secret & $start).startsWith("00000"):
    echo $idx
    found5 = true
  
  start+=1
