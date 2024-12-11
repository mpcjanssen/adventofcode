from functools import cmp_to_key

rules,pages = open(0).read().split("\n\n")
rules =  [ list(map(int, l.strip().split('|'))) for l in rules.split('\n')]
pages =  [ list(map(int, l.strip().split(','))) for l in pages.strip().split('\n')]



def valid(p):
    for bef,aft in zip(p,p[1:]):
        if [bef,aft] not in rules: return False
    
    return True

invalid = []
part1 = 0
for p in pages:
    if valid(p): 
        part1 += p[(len(p)-1)//2]
    else:
        invalid += [p]

print(part1)

def rep_sort(a,b):
    if [a,b] in rules:
        return -1
    else:
        return 1


cmp = cmp_to_key(rep_sort)

part2 = 0
for p in invalid:
    np = sorted(p, key=cmp)
    if valid(np): 
        part2 += np[(len(np)-1)//2]

print(part2)