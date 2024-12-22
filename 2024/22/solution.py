input = [int(l.strip()) for l in open(0)]

# print(input)

def nextsecret(secret):
    secret = ((secret * 64) ^ secret) % 16777216
    secret = ((secret // 32) ^ secret) % 16777216
    secret = ((secret * 2048) ^ secret) % 16777216
    return secret

total = 0
possible_price_changes = {}

for num in input:
    onesdigits = [num % 10]
    for _ in range(2000):
        num = nextsecret(num)
        onesdigits.append(num % 10)

    # Last secret for part1    
    total += num
    seen = set()
    for i in range(len(onesdigits) - 4):
        a, b, c, d, e = onesdigits[i:i + 5]
        price_changes = (b - a, c - b, d - c, e - d)
        if price_changes in seen: continue
        seen.add(price_changes)
        if price_changes not in possible_price_changes: possible_price_changes[price_changes] = 0
        possible_price_changes[price_changes] += e


print(total)
print(max(possible_price_changes.values()))