
library(ape)

t = read.nexus("org/MBtree_051916.tre")

input_genera = read.csv("org/Genera-by-category.csv")
genus_names = levels(input_genera[, 2])

input_species = read.csv("org/Species-by-category.csv")
species_names = levels(input_species[, 2])

# trim and relabel the tree with genus names
used_names = c("")
to_drop = c("")
for (i in 1:length(t$tip.label)) {
    tip = t$tip.label[i]
    if (tip %in% input_genera[,1]) {
        row = which(tip == input_genera[,1])
        this_name = as.character(input_genera[row, 2])
        if (this_name %in% used_names) {
            to_drop = c(to_drop, tip)
        } else {
            used_names = c(used_names, this_name)
            t$tip.label[i] = this_name
        }
    } else {
        to_drop = c(to_drop, tip)
    }
}
t = drop.tip(t, to_drop)
write.tree(t, "output/genus.tree")

# trim and relabel the tree with species names
t = read.nexus("org/MBtree_051916.tre")
used_names = c("")
to_drop = c("")
for (i in 1:length(t$tip.label)) {
    tip = t$tip.label[i]
    if (tip %in% input_species[,1]) {
        row = which(tip == input_species[,1])
        this_name = as.character(input_species[row, 2])
        if (this_name %in% used_names) {
            to_drop = c(to_drop, tip)
        } else {
            used_names = c(used_names, this_name)
            t$tip.label[i] = this_name
        }
    } else {
        to_drop = c(to_drop, tip)
    }
}
t = drop.tip(t, to_drop)
write.tree(t, "output/species.tree")
