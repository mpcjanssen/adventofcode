import re
input = [l.strip() for l in open(0).readlines()]

def nice1(word):
    if len(re.findall(r'[aeoiu]', word)) < 3 : return False
    if not re.search(r'(.)\1', word): return False
    if (re.search(r'ab|cd|pq|xy',word)): return False
    return True

def nice2(word):
    if not re.search(r'(..).*\1', word) : return False
    if not re.search(r'(.).\1', word) : return False
    
    return True

print(list(map(nice1, input)).count(True))
print(list(map(nice2, input)).count(True))