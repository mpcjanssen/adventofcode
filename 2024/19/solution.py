from functools import cache

patterns, designs = open(0).read().split("\n\n")
patterns = [pat.strip() for pat in  patterns.split(",")]
designs = designs.strip().split("\n")

@cache
def possible(design):
    if design == "": return 1
    ways = 0
    for pat in patterns:
        if not design.startswith(pat): continue
        p =  possible(design[len(pat):]) 
        ways += p

    return ways

results = [p for p in [possible(design) for design in designs] if p > 0]

print(len(results))
print(sum(results))