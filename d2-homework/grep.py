#!/usr/bin/env python3

import sys

# to use this basic grep program run in the directory with this .py file:
# ./grep.py <file to grep> <grep word>

file = open( sys.argv[1] )
grep = sys.argv[2]


for line in file:
    line = line.rstrip("\n")
    if "##" in line:
        continue
    if grep in line:
        print(line)

file.close()