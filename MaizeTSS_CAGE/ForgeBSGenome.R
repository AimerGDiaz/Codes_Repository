source("https://bioconductor.org/biocLite.R")
library("Biostrings")
library("BSgenome")
args = commandArgs(trailingOnly=TRUE)
setwd("/home/aimer/Maize_TSS/Maize_Genomes/Fasta/BSGenome/")
getwd()
forgeBSgenomeDataPkg(args[1])


