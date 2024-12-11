from functools import cache

input = open(0).read().strip()

floor = 0
idx = 1
cellar = None
for c in input:
    if c =='(':
        floor+=1
    else:
        floor-=1
    
    if floor == -1 and cellar == None:
        cellar = idx
    
    idx += 1 

print(floor)
print(cellar)