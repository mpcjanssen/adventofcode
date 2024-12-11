input = [l.strip() for l in open(0).readlines()]
rows = len(input)
cols = len(input[0])

part1 = 0
for r in range(rows):
    for c in range(cols):
        if input[r][c] != 'X': continue
        for dr,dc in [[1,1],[1,0],[1,-1],[0,1],[0,-1],[-1,-1],[-1,0],[-1,1]]:
            cr, cc = r + dr ,c + dc 
            # print((cc,cr))
            if cr < 0 or cr >= rows or cc < 0 or cc >= cols: continue
            if input[cr][cc] != 'M': continue
            cr, cc = cr + dr ,cc + dc 
            if cr < 0 or cr >= rows or cc < 0 or cc >= cols: continue
            if input[cr][cc] != 'A': continue
            cr, cc = cr + dr ,cc + dc 
            if cr < 0 or cr >= rows or cc < 0 or cc >= cols: continue
            if input[cr][cc] != 'S': continue
            part1 += 1

print(part1)

part2 = 0
for r in range(1,rows-1):
    for c in range(1,cols-1):
        if input[r][c] != 'A': continue
            # print((cc,cr))
        one = input[r-1][c-1]+input[r+1][c+1]
        two = input[r-1][c+1]+input[r+1][c-1]
        # print ((r,c), (one,two))
        if one in ["MS", "SM"] and two in ["MS", "SM"]: part2+= 1

print(part2)