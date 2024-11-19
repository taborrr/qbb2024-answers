# Image Processing
## Week 10, November 2024
## Tabor "Attila" Roderiques
### Exercise 4 


library(readr)

# Read the CSV file
data <- read_csv("RNAprod_nucSegmentaysh.csv")

# Perform T-tests comparing PIM2 to other genes for each measurement

# Function to perform T-test and summarize results
perform_ttest <- function(data, gene, measurement) {
  # Subset data for PIM2 and the specific gene
  pim2_data <- data[data$gene == "PIM2", measurement]
  gene_data <- data[data$gene == gene, measurement]
  
  # Perform the two-tailed Student's T-test
  t_test_result <- t.test(pim2_data, gene_data)
  
  return(t_test_result$p.value)
}

# Genes to compare (excluding PIM2)
genes_to_compare <- setdiff(unique(data$gene), "PIM2")

# Measurements to analyze
measurements <- c("nascentRNA", "PCNA", "log2_nRNA_PCNA")

# Create an empty data frame to store results
results <- data.frame(
  gene = character(),
  measurement = character(),
  p_value = numeric(),
  stringsAsFactors = FALSE
)

# Loop through each gene and measurement to perform the T-tests
for (gene in genes_to_compare) {
  for (measurement in measurements) {
    p_value <- perform_ttest(data, gene, measurement)
    results <- rbind(results, data.frame(gene = gene, measurement = measurement, p_value = p_value))
  }
}

# Adjust for multiple comparisons using the Bonferroni correction
results$adj_p_value <- p.adjust(results$p_value, method = "bonferroni")

# Print the results
print(results)

# Print only significant results (adjusted p-value < 0.05)
significant_results <- results[results$adj_p_value < 0.05, ]
print(significant_results)

# gene    measurement   p_value       adj_p_value
# POLR2B  nascentRNA    1.440691e-41  1.296622e-40
# POLR2B        PCNA    6.630701e-53  5.967631e-52

# The POLR2B gene knockouts were significantly different in the nascent RNA and PCNA signal
# but then not significantly different in the log2 ratio of them. 
