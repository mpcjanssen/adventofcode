from collections import defaultdict

instructions = [step.strip() for step in open(0).read().split(',')]

visited = set()
twice = None
x,y,dx,dy = (0,0,0,1)

for step in instructions:
    turn = step[0]
    dist = int(step[1:])
    if turn == 'L': dx,dy = -dy,dx
    if turn == 'R': dx,dy = dy,-dx
    for i in range(dist):
        x +=dx
        y +=dy
        if (x,y) in visited and twice == None:
            twice = (x,y)        
        visited.add((x,y))
    
print(abs(x)+abs(y))
x,y = twice
print(abs(x)+abs(y))