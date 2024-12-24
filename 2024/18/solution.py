from collections import deque,defaultdict

bytes = [(list(map(int,l.strip().split(",")))) for l in open(0)]

def solve(bytes,num,target):
    start = (0,0)
    xmax,ymax = target
    
    grid = [["." for i in range(xmax+1)] for j in range(ymax+1)]

    corrupted = bytes[:num]
    for c in corrupted:
        x,y = c
        grid[y][x] = "#"

    # print("\n".join("".join(l) for l in grid))
    scores = defaultdict(lambda: None)
    scores[start] = 0
    heads = deque([start])
    while not scores[target] and heads:
        x,y = heads.popleft()
        score = scores[(x,y)]
        for nx,ny in [(x+1,y), (x-1,y), (x, y-1), (x,y+1)]:
            if nx < 0 or nx > xmax or ny < 0 or ny > ymax: continue
            if grid[ny][nx] == "#": continue
            if scores[(nx,ny)]: continue
            scores[(nx,ny)] = score + 1
            heads.append((nx,ny))
    
    return scores[target]



part1 = solve(bytes, 1024, (70,70) )
print(part1)

bfail = len(bytes) - 1
bpass = 1024

while True:
  bnext = (bpass + bfail)//2
  result = solve(bytes, bnext, (70,70) )

  if result:
    bpass = bnext
  else:
    bfail = bnext
  if bpass == bfail-1: break


part2 = ",".join(map(str,bytes[bpass]))
print(part2)