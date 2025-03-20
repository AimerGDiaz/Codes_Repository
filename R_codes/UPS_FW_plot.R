my_packages <- c("ggpubr","ggplot2","plyr","pheatmap","pak")


 not_installed <- my_packages[!(my_packages %in% installed.packages()[ , "Package"])]
 if(length(not_installed)) install.packages(not_installed, repos='http://cran.us.r-project.org')

lapply(my_packages, library, character.only = TRUE)


UBA1_UBC3536 <- read.csv("! YOUR PATH TO THE FILE ! :UPS_FW.txt", sep = "\t", header = T)

#dcls_FW$Treatment <- factor(dcls_FW$Treatment, levels = c("Mock", "CaMV", "ORMV", "CMV", "TyMV", "TRoV", "TCV", 
#                                                         "TuMV","TuMV-GFP", "TuMV-DHCpro", "TuMV-KITS"))
UBA1_UBC3536$Infection <- factor(UBA1_UBC3536$Infection, levels = c("Mock", "CaMV","CMV", "TuMV"))
#dcls_FW<-dcls_FW[!grepl("Gesa[12]Set",dcls_FW$Dataset),]

average_weights <- ddply(UBA1_UBC3536, .(Genotype, Infection), summarize, Avg_Weight = mean(RFW))
average_weights <- subset(average_weights, Infection == "Mock")

UBA1_UBC3536_FW_avg <- merge(UBA1_UBC3536, average_weights[,c("Genotype", "Avg_Weight","Infection")], by = c("Genotype"))

UBA1_UBC3536_FW_avg$Relative_Weight <- UBA1_UBC3536_FW_avg$RFW / UBA1_UBC3536_FW_avg$Avg_Weight
colors <- c("Col-0" = "#29614D", "uba1" = "#601831")
#table(UBA1_UBC3536_FW_avg$Genotype)
UBA1_FW_avg <- UBA1_UBC3536_FW_avg[UBA1_UBC3536_FW_avg$Genotype != "ubc35/36", ]
UBA1_FW_avg_plot <- ggplot(UBA1_FW_avg, aes(x=Infection.x      , y=Relative_Weight,fill = Genotype)) +
  geom_bar(position = position_dodge(width = 0.9), stat = 'summary' ) +
  geom_errorbar(position = position_dodge(width = 0.9),stat = 'summary', width = 0.4,alpha = 0.5) + 
  geom_jitter( stat = 'identity', shape = 16, position = position_jitterdodge(0.15), size = 1, alpha = 0.5) +
  scale_fill_manual(values = colors ) +
  labs(y = "Relative Fresh weight", x = "Infection treatment" ) + facet_wrap(.~Genotype) +
  theme_classic(base_size = 20) +
  theme(axis.text.x = element_text(angle = 90),legend.position = "bottom") 
ggsave(filename = "C:/Users/Slaym/Downloads/UPS_FW.svg", plot = UBA1_FW_avg_plot,device = "svg", width=10, height=10)