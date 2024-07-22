with open('2015/input/1.txt', 'r') as file:
    input = file.read().rstrip()

floor = 0
idx = 0
basementidx = []
for c in input:
    idx = idx + 1
    if c == '(':
        floor = floor + 1
    else:
        floor = floor - 1
    
    if floor == -1:
        basementidx.append(idx)


print(f'Part 1: {floor}')
print(f'Part 2: {basementidx[0]}')

def delta(c):
    if c == '(':
        return 1
    else: 
        return -1
    
def addfloor(floors, c):
    floors.append(floors[-1] + delta(c))
    return floors
    
import functools

floors = functools.reduce(lambda a, b : addfloor(a,b),input,[0])

print(f'Part 1: {floors[-1]}')
print(f'Part 2: ')
