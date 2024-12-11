from functools import cache

input = list(map(int, open(0).read().split()))
print(input)
@cache
def count(stone,steps):
    # print((stone,steps))
    if steps == 0:
        return 1
    if stone == 0:
        return count(1,steps-1)    
    sstone = str(stone)
    lstone = len(sstone)
    if lstone % 2 == 0:
        left = count(int(sstone[:lstone//2]), steps-1)
        right = count(int(sstone[lstone//2:]), steps-1)
        return left + right
    else:
        return count(stone * 2024, steps-1 )
    
            

print(sum([count(st,25) for st in input]))
print(sum([count(st,75) for st in input]))