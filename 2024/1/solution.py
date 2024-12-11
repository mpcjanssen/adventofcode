input = open(0).readlines()

data = [list(map(int, l.strip().split())) for l in input]
left, right = list(zip(*data))
part1 = sum([abs(x-y) for x,y in zip(sorted(left),sorted(right))])
print(part1)

part2 = 0
for l in left:
    part2 += l*len([r for r in right if r == l])

print(part2)