#!/usr/bin/env python3

import sys

# to use this basic grep program run in the directory with this .py file:
# ./grep.py <grep word> <file to grep> 


# optional inverse grep -v function
if sys.argv[1] == "-v":
    grep = sys.argv[2]
    file = open( sys.argv[3] )
    for line in file:
        line = line.rstrip("\n")
        if grep not in line:
            print(line)

if sys.argv[1] != "-v":
    grep = sys.argv[1]
    file = open( sys.argv[2] )
    for line in file:
        line = line.rstrip("\n")
        if grep in line:
            print(line)

file.close()