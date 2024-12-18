from collections import defaultdict

instructions = [line.strip() for line in open(0).readlines()]

keypad1 = [[1,2,3], [4,5,6],[7,8,9]]
keypad2 = [[None, None, 1,None,None],
    [None, 2, 3, 4,None],
    [5, 6, 7, 8 , 9],
    [None, "A", "B","C",None],
    [None, None, "D",None,None]]
    


def solve(keypad):
    rows =len(keypad)
    cols = len(keypad[0])
    code = []
    for r in range(rows):
        for c in range(cols):
            if keypad[r][c] == 5: break
        else:
            continue
        break

    for l in instructions:
        for dir in l:
            nr,nc = r,c
            if dir == 'U' and r > 0: nr -=1 
            if dir == 'D' and r < rows-1: nr +=1 
            if dir == 'L' and c > 0: nc -=1 
            if dir == 'R' and c < cols -1: nc +=1
            if keypad[nr][nc] != None: r,c = nr,nc 
        code.append(str(keypad[r][c]))
    return ("".join(code))
    
print(solve(keypad1))
print(solve(keypad2))