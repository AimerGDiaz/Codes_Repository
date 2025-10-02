# Run all this lines to laod / install the packages need it

my_packages <- c("stats","ggplot2")


not_installed <- my_packages[!(my_packages %in% installed.packages()[ , "Package"])]
if(length(not_installed)) install.packages(not_installed, repos='http://cran.us.r-project.org')

lapply(my_packages, library, character.only = TRUE)



######################################################## Load your data 

# Generate sample data
set.seed(123)
n <- 100
p <- 5
data <- as.data.frame( matrix(rnorm(n * p), nrow = n, ncol = p))
data$categories <- c(rep("Blue",33),rep("Red",34),rep("Green",33))
colnames(data) <- c(paste0("Var", 1:p),"categories")
row.names(data) <- data$cathegories

#### Load your data here 
# YourData <- read.csv("./", sep = "\t", header = T)
####

# Perform PCA

pca_result <- prcomp(data[,-6], center = TRUE, scale. = TRUE)
summary(pca_result)

# ---- PCA scores joined to metadata ----
scores <- as.data.frame(pca_result$x)
scores$categories <- data$categories
head(scores)

# Scores for first two PCs
scores2 <- transform(scores, PC1 = pca_result$x[,1], PC2 = pca_result$x[,2])

# Loadings scaled for plotting
loadings <- as.data.frame(pca_result$rotation[, 1:2])
loadings$var <- rownames(loadings)

# A simple scaling so arrows fit nicely
arrow_scale <- 2
loadings$PC1 <- loadings$PC1 * arrow_scale
loadings$PC2 <- loadings$PC2 * arrow_scale

ggplot(scores2, aes(x = PC1, y = PC2, color = categories)) +
  geom_point(size = 3) +
  geom_segment(data = loadings,
               aes(x = 0, y = 0, xend = PC1, yend = PC2),
               arrow = arrow(length = unit(0.02, "npc")),
               inherit.aes = FALSE) +
  geom_text(data = loadings, aes(x = PC1, y = PC2, label = var),
            vjust = -0.5, inherit.aes = FALSE) +
  labs(title = "PCA (prcomp): PC1 vs PC2", color = "Category") +
  theme_minimal()


### How mouch variance is explained here ?
# ---- Explained variance ----
eig_vals <- pca_result$sdev^2
prop_var <- eig_vals / sum(eig_vals)
cum_prop <- cumsum(prop_var)

explained <- data.frame(
  PC = paste0("PC", seq_along(eig_vals)),
  Variance = eig_vals,
  Proportion = prop_var,
  Cumulative = cum_prop
)
 
ggplot(explained, aes(x = seq_along(Proportion), y = Proportion)) +
   geom_point() + geom_line() +
   labs(x = "Principal Component", y = "Proportion of Variance (%)",
        title = "Variance explained") +
   scale_x_continuous(breaks = seq_along(explained$PC), labels = explained$PC)