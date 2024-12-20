from collections import deque
from collections import defaultdict

grid = [l.strip() for l in open(0).readlines()]
rows = len(grid)
cols = len(grid[0])
start = None
end = None
racetrack = []

for r in range(rows):
    for c in range(cols):
        p = (r,c)
        v = grid[r][c]
        if v == '#': continue
        racetrack.append(p)
        if v == 'E': 
            end = p
        if v == 'S':
            start = p

def manh(p1,p2):
    r1,c1 = p1
    r2,c2 = p2
    return abs(r1-r2) + abs(c1-c2)

def scores(start,end):
    dirs = [[0,1],[0,-1],[1,0],[-1,0]]
    scores = defaultdict(lambda: None)
    scores[start] = 0
    heads =  deque()
    heads.append(start)
    # print(heads)
    while scores[end] == None and heads:
        r,c = heads.pop()
        # print(r,c)
        score = scores[(r,c)]
        for dr,dc in dirs:
            nr, nc = r+dr,c+dc
            if nr < 0 or nr >= rows: continue
            if nc < 0 or nc >= cols: continue
            if grid[nr][nc] == '#': continue
            if scores[(nr,nc)] != None: continue
            scores[(nr,nc)] = score+1
            heads.append((nr,nc))
       
        # print(heads)

    return scores

def cheats(cheattime):
    imps = defaultdict(lambda: 0)
    tracksize = len(racetrack)
    for idx in range(tracksize-1):
        p1 = racetrack[idx]
        options = racetrack[idx+1:]
        startscore = sc[p1]
        for p2 in options:
            dist = manh(p1,p2)
            if dist > cheattime: continue
            endscore = cleanscore-sc[p2]
            newscore = endscore+startscore + dist
            delta = cleanscore-newscore
            if delta > 0: imps[delta]+= 1
    
    return imps

sc = scores(start,end)
cleanscore = sc[end]

racetrack.sort(key=lambda t: sc[t])

part1 = 0
for k,v in cheats(2).items():
    if k >= 100: part1+=v

print(part1)

part2 = 0
for k,v in cheats(20).items():
    if k >= 100: part2+=v


print(part2)

