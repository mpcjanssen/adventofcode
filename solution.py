files = {}
blanks = []

pos = 0
for idx, c in enumerate(input()):
    size = int(c)
    if idx % 2 == 0:
        fid = idx // 2 
        files[fid] = (pos,size)
    else:
        blanks.append((pos,size))
    pos += size


print(files)
print(blanks)