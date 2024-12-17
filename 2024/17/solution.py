import re

ra,rb,rc, *program = [int(d) for d in re.findall('\d+', open(0).read())]

def computer(ra,rb,rc):
    ptr = 0
    output = []
    while ptr < len(program):
        opcode,operand = program[ptr:ptr+2]
        if  0<=operand<=3:  combo = operand
        elif operand == 4:  combo = ra
        elif operand == 5:  combo = rb
        elif operand == 6:  combo = rc

        if   opcode == 0: ra = ra>>combo
        elif opcode == 1: rb = rb^operand
        elif opcode == 2: rb = combo%8
        elif opcode == 3: ptr = ptr+2 if ra == 0 else operand-2
        elif opcode == 4: rb = rb^rc
        elif opcode == 5: output.append(combo%8)
        elif opcode == 6: rb = ra>>combo
        elif opcode == 7: rc = ra>>combo
        ptr += 2
    return output

print(','.join([str(i) for i in computer(ra,rb,rc)]))

def solve(n=0,d=15):
    res = [1E20]
    if d == -1: return n
    for i in range(8):
        nn = n+i*8**d
        output = computer(nn,0,0)
        if len(output) != len(program):continue
        if output[d] == program[d]: res.append(solve(nn,d-1))
    return min(res)

print(solve())
