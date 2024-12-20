input = open(0).read()
print(input)


## two observations
# 1. A cheat needs to be adjacent to the car position 
# next to the current fastest path otherwise the cheat has no effect
#
# A cheat needs to occur within the current fastest time otherwise it
# will not give a reduction

## Observation 1 is incorrect: in the example below the cheat block is not on the current shortest path:

######
#    #
# ## #
# ## #
#S CE#