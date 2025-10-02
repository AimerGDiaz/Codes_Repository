# Run all this lines to laod / install the packages need it

my_packages <- c("org.At.tair.db","enrichplot","GOSemSim","clusterProfiler","ggplot2")


not_installed <- my_packages[!(my_packages %in% installed.packages()[ , "Package"])]
if(length(not_installed)) install.packages(not_installed, repos='http://cran.us.r-project.org')

lapply(my_packages, library, character.only = TRUE)



######################################################## Load your data 

GWAS_Gesa <- read.csv("./GWAS_CaMV_TooProts.bed", sep = "\t", header = F)
GWAS_Gesa$V8 # In this column is saved the TAIR id 
# Get the entrez value
GWAS_Gesa$entrez  <- mapIds(x =org.At.tair.db  ,
                      keys = GWAS_Gesa$V8, 
                      column =  "ENTREZID", 
                      keytype = "TAIR",
                      multiVals = "first")

# Get gene descriptions and gene name
GWAS_Gesa$description <- mapIds(x =org.At.tair.db  ,
                                        keys = GWAS_Gesa$entrez,
                                        keytype =  "ENTREZID", 
                                        column =  "GENENAME", 
                                        multiVals = "first")


GWAS_Gesa$Symbol <- mapIds(x =org.At.tair.db  ,
                                keys = GWAS_Gesa$entrez,
                                keytype =  "ENTREZID", 
                                column =  "SYMBOL", 
                                multiVals = "first")

write.csv(Whole_table, "./GO_total_Gesa_CaMV.csv") 


ego <- enrichGO(gene  = GWAS_Gesa$entrez,
                OrgDb         = org.At.tair.db,
                ont           = "BP",
                pAdjustMethod = "BH",
                pvalueCutoff  = 0.05,
                qvalueCutoff  = 0.05,
                readable      = TRUE)

ego_at <- attributes(ego )
Whole_table <- ego_at$result

# Save the GO terms enrich table
 write.csv(Whole_table, "./GO_total_Gesa_CaMV.csv") 
d <- godata('org.At.tair.db', ont="BP")

gos_clustered <- pairwise_termsim(ego, method="Wang", semData = d)
gos_clustered <- treeplot(ego2 ) 
gos_clustered
ggsave(plot = gos_clustered,filename = "./GO_total_GWAS.svg", device = "svg",  width=12, height=8)