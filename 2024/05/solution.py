rules,pages = open(0).read().split("\n\n")
rules =  [ list(map(int, l.strip().split('|'))) for l in rules.split('\n')]
pages =  [ list(map(int, l.strip().split(','))) for l in pages.strip().split('\n')]

def valid(p,rules):
    for bef,aft in zip(p,p[1:]):
        if [bef,aft] not in rules: return False
    
    return True

part1 = 0
for p in pages:
    if valid(p,rules): part1 += p[(len(p)-1)//2]

print(part1)