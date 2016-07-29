
library(picante)


# function to generate a csv file for a given set of treatments with the form:
#,Robillarda,Pestalotiopsis,Seimatosporium,....
#A_1_1,2,3,4,....
#A_1_2,2,3,4,....
#A,2,3,4,....
#D,2,3,4,....
generate_phylocom = function(taxa_column, treatment_column, data, output_file) {

    taxa_names = levels(data[, taxa_column])
    treatments = levels(data[, treatment_column])
    output = data.frame(row.names=treatments)
    # loop through taxa, for each taxa find the frequency for each treatment
    for (i in 1:length(taxa_names)) {
        taxon = taxa_names[i]
        treatment_counts = c()
        for (j in 1:length(treatments)) {
            treatment = treatments[j]
            count = 0
            for (k in 1:length(data[,1])) {
                if (taxon == data[k, taxa_column] && treatment == data[k, treatment_column])
                    count = count + 1
            }
            treatment_counts = c(treatment_counts, count)
        }
        #print(taxon)
        #print(treatment_counts)
        output[taxon] = treatment_counts
    }
    write.csv(output, file=output_file)
    print(paste("Done generating:", output_file))
}

# input file Genera-by-category.csv:
#Sample,Genus,Count,Treatment_leaflet,Treatment_replicate,Treatment_binned,Treatment_binned_early-late
#A_1_1_15,Robillarda,1,A_1_1,A_1,A,A
#A_1_1_3,Pestalotiopsis,1,A_1_1,A_1,A,A
#A_1_1_8,Seimatosporium,1,A_1_1,A_1,A,A
#A_1_2_10,Heliscus,1,A_1_2,A_1,A,A
#A_1_2_12,Cladosporium,1,A_1_2,A_1,A,A

input_genera = read.csv("org/Genera-by-category.csv")
input_species = read.csv("org/Species-by-category.csv")

generate_phylocom(2, 4, input_genera, "output/genera_leaflet.csv")
generate_phylocom(2, 5, input_genera, "output/genera_replicate.csv")
generate_phylocom(2, 6, input_genera, "output/genera_binned.csv")
generate_phylocom(2, 7, input_genera, "output/genera_binned-early-late.csv")

generate_phylocom(2, 4, input_species, "output/species_leaflet.csv")
generate_phylocom(2, 5, input_species, "output/species_replicate.csv")
generate_phylocom(2, 6, input_species, "output/species_binned.csv")
generate_phylocom(2, 7, input_species, "output/species_binned-early-late.csv")


