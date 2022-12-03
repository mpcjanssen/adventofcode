import strutils
import std/sequtils
import std/sugar
import combinatorics

let f = open("../../inputs/2020/1.txt")


let input =  f.readAll().strip().split("\n").map((x) => parseInt(x))


echo combinations(input,2).filter((a) => a[0]+a[1] == 2020)[0].foldl(a*b)
echo combinations(input,3).filter((a) => a[0]+a[1]+a[2] == 2020)[0].foldl(a*b)