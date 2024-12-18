from hashlib import md5
input = open(0).read().strip()
postfix = 0
part1 = part2 = None
while True:
    postfix +=1
    if part1 == None and md5((input+str(postfix)).encode('utf-8')).hexdigest().startswith('00000'): part1 = postfix
    if part2 == None and md5((input+str(postfix)).encode('utf-8')).hexdigest().startswith('000000'): part2 = postfix
    if part1 and part2: break

print((part1, part2))