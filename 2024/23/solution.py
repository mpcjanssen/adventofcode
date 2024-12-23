from igraph import Graph

data = [(fr, to) for fr,to in [l.strip().split("-") for l in open(0).readlines()]]
g = Graph.TupleList(data, directed=False)

tcliques = 0
for cand in [g.vs[n]["name"] for n in [q for q in g.cliques(3,3)]]:
    c1,c2,c3 = cand
    if c1.startswith('t') or c2.startswith('t') or c3.startswith('t'): tcliques+=1

print(tcliques)


cliques = [q for  q in (g.cliques(2))]
biggest_clique = (sorted(cliques,key=len)[-1])
print(",".join(sorted([g.vs[n]["name"] for n in list(biggest_clique)])))