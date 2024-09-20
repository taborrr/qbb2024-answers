#!/usr/bin/env python3

import scipy
import os

# exercise 2
# step 2.1
reads = ['ATTCA', 'ATTGA', 'CATTG', 'CTTAT', 'GATTG', 'TATTT', 'TCATT', 'TCTTA', 'TGATT', 'TTATT', 'TTCAT', 'TTCTT', 'TTGAT']
k = 3
graph = []
graph.append('digraph {')

for i in reads:
    for b in range(len(i)-k):
        mer1 = i[b:(b+k)]
        mer2 = i[(b+1):(b+k+1)] 
        edge = f"{mer1}  ->  {mer2}"
        print(edge)
        graph.append(edge)
graph.append('}')
print(graph)
# write to a file
file_name = "kmer_edges.dot"
with open(file_name, "w") as file:
    for line in graph:
        file.write(line + "\n")  # write each edge to the file
print(f"Output written to {file_name}")