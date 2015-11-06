#! /usr/bin/python
"""
Script to BLAST ITS sequences and return top hitting taxon
output: tube_id, top_hitting_taxon, e-value
"""

from Bio.Blast import NCBIWWW
from Bio.Blast import NCBIXML
from Bio import SeqIO
import csv
import sys

input_file = "data/SNK001-019_SameStrand_80MIN_NamesCleaned.fasta"
e_cutoff = 0.0
hitlist_size = 300

records = SeqIO.parse(open(input_file), format="fasta")
for i, record in enumerate(records):
    sys.stdout.write("\rBLASTing record " + str(i + 1) + " out of 1425")
    sys.stdout.flush()
    result_handle = NCBIWWW.qblast("blastn", "nt", record.format("fasta"), hitlist_size=hitlist_size)
    blast_record = NCBIXML.read(result_handle)
    found = False
    binomial = "NA"
    e = "NA"
    for hit in blast_record.alignments:
        if "Fungal" not in hit.title and "Uncultured" not in hit.title:
            temp_binomial = hit.title.split("|")[-1].strip().split(" ")[0:2]
            temp_e = float(hit.hsps[0].expect)
            if "sp." == temp_binomial[1] and not found and temp_e <= e_cutoff:
                found = True
                e = temp_e
                binomial = temp_binomial
            if "sp." != temp_binomial[1] and temp_e <= e_cutoff:
                found = True
                e = temp_e
                binomial = temp_binomial
                break
    with open("top_hits.csv", "a") as csvfile:
        csvwriter  = csv.writer(csvfile, delimiter=",")
        csvwriter.writerow([record.id, " ".join(binomial), e])

sys.stdout.write("\n")
sys.stdout.flush()
print("Done!")
