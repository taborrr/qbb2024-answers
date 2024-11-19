# Image Processing
## Week 10, November 2024
## Tabor "Attila" Roderiques
### Exercise 3 - Step 3.2


library(ggplot2)
library(readr)

setwd("qbb2024-answers/week10")

# Read the CSV file
dat <- read_csv("RNAprod_nucSegmentaysh.csv")

# Define a cool color scheme
cool_colors <- c("APEX1" = "blue", "PIM2" = "steelblue", "POLR2B" = "darkturquoise", "SRSF1" = "lightcyan")


# Create violin plot for nascent RNA signal
plot_nRNA <- ggplot(dat, aes(x = gene, y = nascentRNA, fill = gene)) +
  geom_violin(trim = FALSE, color = "black") +
  scale_fill_manual(values = cool_colors) +
  labs(title = "Nascent RNA Signal per Nuclei from Gene Knockouts",
       y = "Mean Signal Intensity") +
  theme_minimal()

# Create violin plot for PCNA signal
plot_PCNA <- ggplot(dat, aes(x = gene, y = PCNA, fill = gene)) +
  geom_violin(trim = FALSE, color = "black") +
  scale_fill_manual(values = cool_colors) +
  labs(title = "PCNA Signal per Nuclei from Gene Knockouts",
       y = "Mean Signal Intensity") +
  theme_minimal()

# Create violin plot for log2 Ratio of nascent RNA/PCNA
plot_ratio <- ggplot(dat, aes(x = gene, y = log2_nRNA_PCNA, fill = gene)) +
  geom_violin(trim = FALSE, color = "black") +
  scale_fill_manual(values = cool_colors) +
  labs(title = "Log2 Ratio of nascentRNA to PCNA Signal",
       y = "Log2 Transformed Ratio") +
  theme_minimal()

# Print the plots
print(plot_nRNA)
print(plot_PCNA)
print(plot_ratio)
