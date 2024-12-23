from igraph import Graph
import collections

data = [(fr, to) for fr,to in [l.strip().split("-") for l in open(0).readlines()]]
g = Graph.TupleList(data, directed=False)


lan3 = [cand for cand in [g.vs[n]["name"] for n in g.cliques(3,3)] if any(c.startswith("t") for c in cand)]

print("ig", len(lan3))

cliques = [q for  q in (g.cliques(2))]
biggest_clique = max(cliques,key=len)
print("ig", ",".join(sorted([g.vs[n]["name"] for n in list(biggest_clique)])))

## With bors kerbosch

def bors_kerbosch_v1(R, P, X, G, C):
    if len(P) == 0 and len(X) == 0:
        if len(R) > 2:
            C.append(sorted(R))
        return 
    
    for v in P.union(set([])):
        bors_kerbosch_v1(R.union(set([v])), P.intersection(G[v]), X.intersection(G[v]), G, C)
        P.remove(v)
        X.add(v)

G = collections.defaultdict(set)
C = []

for (src,dest) in data:
    G[src].add(dest)
    G[dest].add(src)

bors_kerbosch_v1(set([]), set(G.keys()), set([]), G, C)

largestlan = max(C,key=len)
print("bk", ",".join(largestlan))

## With networkx
import networkx as nx
G = nx.Graph()
G.add_edges_from(data)

lan3 = []
for ql in nx.enumerate_all_cliques(G):
    if len(ql) < 3: continue
    if len(ql) > 3: break
    lan3.append(ql)

print("nx", len([lan for lan in lan3 if any(cn.startswith("t") for cn in lan)]))

lans = nx.find_cliques(G)
cliques = max(lans, key=len)
cliques = sorted(largestlan)
print("nx", ",".join(cliques))