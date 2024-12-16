data = [l.strip() for l in open(0).read()]
part1 = set()
santa = (0,0)

def step(pos,dir):
    r,c = pos
    if dir == '^':
        r-=1
    elif dir == 'v':
        r+=1
    elif dir == '<':
        c -= 1
    elif dir == '>':
        c += 1
    else:
        raise("Wrong step")
    return (r,c)    

for s in data:
    santa = step(santa,s)    
    part1.add(santa)
    
print(len(part1))

chunked_steps = [data[2*i:2*i+2] for i in range(0,len(data)//2)]
part2 = set()
santa = (0,0)
robo = (0,0)
for s in chunked_steps:
    sdir, rdir = s
    santa = step(santa,sdir)    
    robo = step(robo,rdir)
    part2.add(santa)
    part2.add(robo)

print(len(part2))

