#Rscript Heat_map_auto.R MIRNA Significance_0.1 F|T
#install.packages("RColorBrewer")
library(RColorBrewer)
#install.packages("pheatmap")
library(pheatmap)
library(ggplot2)
library("gplots", character.only=TRUE)
#args = commandArgs(trailingOnly=TRUE)
#Dir <- (args[1])
#Dir <- "MIRNA"
#Sig <- (args[2])
#Sig <- "Significance_0.1"
#Re_test <- read.delim(paste("/scratch/aigutierrez/Tesis_Maestria/Mapping_analysis/Statistical_Analysis/Precise_counting/Generalized_code_DENVpatients_lib_sfd/",Dir,
#                            "/Candidates/", Sig, "/Top_table.txt", sep = ""),  header = T, row.names = "name") 
 Re_test <-   read.delim("Top_miRs_best_counts_corrected.txt",   header = T, row.names = "MIRNA") 
#Re_test <- read.delim("/scratch/aigutierrez/Tesis_Maestria/Mapping_analysis/Statistical_Analysis/Precise_counting/Generalized_code_DENVpatients_lib_sfd/MIRNA/Candidates/Significance_0.05/Top_table.txt",
#                    header = T, row.names = "name") 
#row.names(Re_test) <- gsub("_[68]_.*","",row.names(Re_test))

row_sub = apply(Re_test, 1, function(row) all(row !=0 ))
Re_test <- Re_test[row_sub,]

#Re_test <- Re_test[-6,]
Re_test2<- t(Re_test)
print(head(Re_test2))
Re_test2<-cbind.data.frame(Lib = row.names(Re_test2),Re_test2)
#only miR
#Re_test2$Lib<- gsub("R.*","",Re_test2[,1])
#patients 
Re_test2$Lib<- Re_test2[,1]
row.names(Re_test2) <- NULL

Re_test3<- aggregate(Re_test2[,2:length(Re_test2)], list(Re_test2$Lib), mean)
colnames(Re_test3)<- colnames(Re_test2)



Re_test_log2<-cbind.data.frame(Lib= Re_test3[,1],log2(Re_test3[,2:length(Re_test2)]))
row.names(Re_test_log2) <- Re_test_log2[,1]

Numbers <- F
#Numbers <- (args[1]
pdf("Heat_map.pdf", width=12, height=18)
pheatmap(Re_test_log2[,-1],  cluster_cols = T, cluster_rows = T, color = rev(redgreen(75)), display_numbers = Numbers,
         number_color = "white", fontsize_number = 7, main = "Perfil de expresión de miRNAs en LOAD vs Control", fontsize = 4 )#fontsize = 6, 
#	filename = "Heat_map.pdf")
dev.off()

#         filename = paste("/scratch/aigutierrez/Tesis_Maestria/Mapping_analysis/Statistical_Analysis/Precise_counting/Generalized_code_DENVpatients_lib_sfd/",Dir,
#                          "/Candidates/", Sig, "/Top_miRs_heat_map.png", sep = ""))

