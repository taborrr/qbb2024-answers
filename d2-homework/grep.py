#!/usr/bin/env python3

import sys

# to use this basic grep program run in the directory with this .py file:
# ./grep.py <grep word> <file to grep> 

file = open( sys.argv[2] )
grep = sys.argv[1]


for line in file:
    line = line.rstrip("\n")
    if "##" in line:
        continue
    if grep in line:
        print(line)

file.close()