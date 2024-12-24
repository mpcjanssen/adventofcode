from functools import cache, cached_property
from itertools import permutations
init,prog = open(0).read().split("\n\n")

regs = {}

for reg in init.splitlines():
    name,val = reg.split(": ") 
    regs[name] = int(val)

for gates in prog.strip().splitlines():
    inst, name  = gates.split(" -> ")
    regs[name] = inst   

@cache
def calc(reg):
    val = regs[reg]
    if val == 1 or val == 0: return val
    inst = regs[reg]
    p1,op,p2 = inst.split(" ")
    v1 = calc(p1)
    v2 = calc(p2)
    result = None
    if op == "AND":
        result = v1 & v2
    elif op == "OR":
        result = v1 | v2
    elif op == "XOR":
        result = v1 ^ v2
    else:
        raise RuntimeError("Invalid op:", op)
    
    # regs[reg] = result
    return result 


z_regs = [k for k in regs.keys() if k.startswith("z")]
x_regs = [k for k in regs.keys() if k.startswith("x")]
y_regs = [k for k in regs.keys() if k.startswith("y")]

x = int("".join(str(calc(name)) for name in (reversed(sorted(x_regs)))),2)
y = int("".join(str(calc(name)) for name in (reversed(sorted(y_regs)))),2)
z = int("".join(str(calc(name)) for name in (reversed(sorted(z_regs)))),2)

print("part1:" ,z)
print(x+y)

print(len(regs.keys()))
print(312*311/2*310*309/2*308*307/2*306*305/2)
# print(len(list(permutations(regs.keys(),8))))