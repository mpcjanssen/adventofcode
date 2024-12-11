from functools import cache

input = open(0).readlines()

boxes = [list(sorted(map(int,l.strip().split("x")))) for l in input]

part1 = 0
part2 = 0
for l,w,h in boxes:
    part1 += 2*l*w + 2*w*h + 2*h*l + l*w
    part2 += 2*l + 2*w + l*w*h

print(part1)
print(part2)
