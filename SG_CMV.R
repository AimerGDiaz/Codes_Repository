my_packages <- c("ggpubr","ggplot2","dplyr")


not_installed <- my_packages[!(my_packages %in% installed.packages()[ , "Package"])]
if(length(not_installed)) install.packages(not_installed, repos='http://cran.us.r-project.org')

lapply(my_packages, library, character.only = TRUE)


SG_CMV <- read.csv("R_codes/SG_CMV_DCP1-5_G3BP7.csv", sep = ",", header = T)

# Define custom comparisons for each group

SG_CMV$Treatment <- factor(SG_CMV$Treatment, levels = c("Mock","CMV"))
comparisons <- list(
  c("Mock", "CMV")
)


SG_CMV$SG<- as.factor(SG_CMV$SG)
SG_CMV_plot  <-ggplot(SG_CMV, aes(x= Treatment , y=Counts,fill = Treatment)) +
  geom_bar(position = position_dodge(width = 0.9), stat = 'summary',fun.data = mean_se ) +
  geom_errorbar(position = position_dodge(width = 0.9),stat = 'summary',fun.data = mean_se, width = 0.4,alpha = 0.5) + 
  geom_jitter( stat = 'identity', shape = 16, position = position_jitterdodge(0.15), size = 1, alpha = 0.5) +
  scale_fill_manual(values = c("Mock" = "#555555", "CMV" = "#c0c0c0" ) ) +
  labs(y = "Foci count", x = "Infection treatment" ) + facet_wrap(~SG) + #, scales = "free_y") +
  theme_classic(base_size = 20) +
  theme(axis.text.x = element_text(angle = 90),legend.position = "bottom" ,legend.title = element_blank())  +
  stat_compare_means(step.increase = 0, comparisons = comparisons, method = "t.test", label = "p.signif")

SG_CMV_plot
ggsave(filename = "SG_CMV_plot.svg", plot = SG_CMV_plot,device = "svg", width=10, height=10)


#To evaluate the specific values
#results <- SG_CMV %>%
  #group_by(SG) %>%
  #summarise(
    #t_test = list(t.test(Counts ~ Treatment)),
    #.groups = "drop"
  #) %>%
  #mutate(
    #p_value = sapply(t_test, function(x) x$p.value),
    #mean_Mock = sapply(t_test, function(x) x$estimate[1]),
    #mean_CMV = sapply(t_test, function(x) x$estimate[2])
  #)

#print(results %>% select(SG, mean_Mock, mean_CMV, p_value))