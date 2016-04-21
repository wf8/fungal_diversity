#! /usr/bin/python
"""
Replace all occurences in input file of first column of csv file 
with second column and write output file.
"""

input_file = "RAxML_tree_rooted.nex"
output_file = "RAxML_tree_rooted_named.nex"
csv_file = "top_hits.csv" 

import csv

with open(input_file, "r") as f:
    s = f.read()
    with open(csv_file, "rb") as f:
        csvreader = csv.reader(f)
        j = 1
        for row in csvreader:
            old_name = row[0].replace("-","_")
            new_name = row[1].replace(" ","_")
            i = 1
            while (old_name in s):
                s = s.replace(old_name, new_name + str(j) + "_" + str(i), 1)
                i += 1
                j += 1
        with open(output_file, "w") as o:
            o.write(s)


