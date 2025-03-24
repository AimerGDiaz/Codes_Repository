my_packages <- c("ggpubr","ggplot2","plyr","pheatmap","pak")


 not_installed <- my_packages[!(my_packages %in% installed.packages()[ , "Package"])]
 if(length(not_installed)) install.packages(not_installed, repos='http://cran.us.r-project.org')

lapply(my_packages, library, character.only = TRUE)


#UBA1_UBC3536 <- read.csv("! YOUR PATH TO THE FILE ! :UPS_FW.txt", sep = "\t", header = T)
UBA1_UBC3536 <- read.csv("R_codes/UPS_FW.txt", sep = "\t", header = T)

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
#UBA1_FW_avg_plot <- ggplot(UBA1_FW_avg[UBA1_FW_avg$Genotype == "uba1",], aes(x=Infection.x      , y=Relative_Weight,fill = Genotype)) +
UBA1_FW_avg_plot <- ggplot(UBA1_FW_avg, aes(x=Infection.x  , y=Relative_Weight,fill = Genotype)) +
  geom_bar(position = position_dodge(width = 0.9), stat = 'summary' ) +
  geom_errorbar(position = position_dodge(width = 0.9),stat = 'summary', width = 0.4,alpha = 0.5) + 
  geom_jitter( stat = 'identity', shape = 16, position = position_jitterdodge(0.15), size = 1, alpha = 0.5) +
  scale_fill_manual(values = colors ) +
  labs(y = "Relative Fresh weight", x = "Infection treatment" ) + facet_grid(~Genotype) +
  theme_classic(base_size = 20) +
  scale_y_continuous(limits = c(0, 2), breaks = seq(0, 2, by = 0.5)) + 
  theme(axis.text.x = element_text(angle = 90),legend.position = "bottom") 

# Define custom comparisons for each group
comparisons <- list(
  c("Mock", "CaMV"),
  c("Mock", "CMV"),
  c("Mock", "TuMV")
)

# Add statistical comparisons using t test 
UBA1_FW_avg_sig_plot <- UBA1_FW_avg_plot + stat_compare_means(step.increase = 0.06, comparisons = comparisons, method = "t.test", label = "p.signif")

UBA1_FW_avg_sig_plot
#ggsave(filename = "C:/Users/Slaym/Downloads/UPS_FW.svg", plot = UBA1_FW_avg_plot,device = "svg", width=10, height=10)


########### DATA rearrange 

UBA1_FW_avg$Interaction <- interaction(UBA1_FW_avg$Genotype,UBA1_FW_avg$Infection.x)
UBA1_FW_avg_plot <- ggplot(UBA1_FW_avg, aes(x=Interaction      , y=Relative_Weight,fill = Genotype)) +
  geom_bar(position = position_dodge(width = 0.9), stat = 'summary' ) +
  geom_errorbar(position = position_dodge(width = 0.9),stat = 'summary', width = 0.4,alpha = 0.5) + 
  geom_jitter( stat = 'identity', shape = 16, position = position_jitterdodge(0.15), size = 1, alpha = 0.5) +
  scale_fill_manual(values = colors ) +
  labs(y = "Relative Fresh weight", x = "Infection treatment" ) +# facet_wrap(.~Genotype) +
  theme_classic(base_size = 20) +
  scale_y_continuous(limits = c(0, 2.2), breaks = seq(0, 2, by = 0.5)) + 
  theme(axis.text.x = element_text(angle = 90),legend.position = "bottom") 

# Define custom comparisons for each group
comparisons <- list(
  c("Col-0.Mock", "uba1.Mock"),
  c("Col-0.CaMV", "uba1.CaMV"),
  c("Col-0.CMV", "uba1.CMV"),
  c("Col-0.TuMV", "uba1.TuMV")
)

# Add statistical comparisons using t test 
UBA1_FW_avg_sig_plot <- UBA1_FW_avg_plot + stat_compare_means(step.increase = 0, comparisons = comparisons, method = "t.test", label = "p.signif")

UBA1_FW_avg_sig_plot
