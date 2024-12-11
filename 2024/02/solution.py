input = open(0).readlines()
data = [list(map(int,l.strip().split())) for l in input]

def issafe(report):
    deltas = set(list([y-x for x,y in (list(zip(report,report[1:])))]))
    return deltas.issubset({1,2,3}) or deltas.issubset({-1,-2,-3})
      
      
part1 = 0
for report in data:
    if issafe(report): part1+=1
        
print(part1)

part2 = 0
for report in data:
    if any([issafe(report[:idx] + report[idx+1:] ) for idx in range(len(report))]): part2 += 1

print(part2)

