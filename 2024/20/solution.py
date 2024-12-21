from collections import deque,Counter

grid = [l.strip() for l in open(0)]
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

# def manh(p1,p2): r1,c1 = p1 ; r2,c2 = p2 ; return abs(r1-r2) + abs(c1-c2)

def scores(start,end):
    dirs = [[0,1],[0,-1],[1,0],[-1,0]]
    scores = {}
    scores[start] = 0
    heads =  deque([start])

    while not end in scores and heads:
        r,c = heads.popleft()
        # print(r,c)
        for dr,dc in dirs:
            nr, nc = r+dr,c+dc
            if nr < 0 or nr >= rows: continue
            if nc < 0 or nc >= cols: continue
            if (nr,nc) in scores: continue
            if grid[nr][nc] == '#': continue
            scores[(nr,nc)] = scores[(r,c)]+1
            heads.append((nr,nc))
       
    return scores

def cheats(cheattime,threshold):
    imps = Counter()
    tracksize = len(racetrack)
    for idx in range(tracksize-1):
        p1 = racetrack[idx]
        x,y = p1
        startscore = sc[p1]
        for dx in range(-cheattime,cheattime+1):
            rest = cheattime - abs(dx)
            for dy in range(-rest,rest+1):
                chp = (x+dx,y+dy)
                if chp in sc:
                    delta_sc = sc[chp]-startscore-abs(dx)-abs(dy)
                    if delta_sc >= threshold: imps[delta_sc]+= 1
    
    return imps

sc = scores(start,end)

# racetrack.sort(key=lambda t: sc[t])

part1 = sum(cheats(2,100).values())
part2 = sum(cheats(20,100).values())

print(part1, part2)


