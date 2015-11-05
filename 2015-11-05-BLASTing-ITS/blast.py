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
records = SeqIO.parse(open(input_file), format="fasta")

for i, record in enumerate(records):
    sys.stdout.write("\rBLASTing record " + str(i+1) + " out of 1425")
    sys.stdout.flush()
    result_handle = NCBIWWW.qblast("blastn", "nt", record.format("fasta"))
    blast_record = NCBIXML.read(result_handle)
    for hit in blast_record.alignments:
        if "Fungal" not in hit.title and "Uncultured" not in hit.title:
            title = hit.title.split("|")[-1].strip().split(" ")[0:2]
            with open("top_hits.csv", "a") as csvfile:
                csvwriter  = csv.writer(csvfile, delimiter=",")
                csvwriter.writerow([record.id, " ".join(title), hit.hsps[0].expect])
            break

sys.stdout.write("\n")
sys.stdout.flush()
print("Done!")
