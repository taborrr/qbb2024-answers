# Week 1 Assignment 
# 2024 09 13 - 09 20
# Tabor Roderiques

# libraries
library(tidyverse)
library(dplyr)

# variables
c3x <- read.table("~/qbb2024-answers/week1/genome_coverage3x.txt", header = FALSE)
c10x <- read.table("~/qbb2024-answers/week1/genome_coverage10x.txt", header = FALSE)
c30x <- read.table("~/qbb2024-answers/week1/genome_coverage30x.txt", header = FALSE)
gsize <- 1e6

# function
distPlotter <- function(file, cov) {
  colnames(file) <- c("coverage")
  # get the range of coverages observed
  max_cov <- max(file$coverage, na.rm = TRUE)
  xs <- 0:(max_cov+1)
  # poisson pmf at each of the observed depths, scaled to sum of freq (genome size)
  pois <- dpois(xs, lambda = cov) * gsize
  # normal pdf 
  norm_ests <- dnorm(xs, mean = cov, sd = sqrt(cov)) * gsize
  # put these into a data frame 
  pois_norm_df <- data.frame(coverage = xs, poisson_prob = pois, normal_distrib = norm_ests)
  # ggploting 
  plot_title <- paste0("Coverage histogram (",as.character(cov), "x",") with Poisson and Normal Functions")
  hist_plot <- ggplot(file, aes(x = coverage)) +
    geom_histogram(binwidth = 0.5, fill = "grey", color = "black", alpha = 0.7) +
    # add poisson and normalDistrib lines to the histogram with rounded ends
    geom_line(data=pois_norm_df,
              aes(x = coverage, y = poisson_prob,color = "Poisson"),
              size = 1.5,
              lineend = "round") +
    geom_line(data=pois_norm_df,
              aes(x = coverage, y = norm_ests,color = "Normal"), 
              size = 1.5,
              lineend = "round") +
    scale_color_manual(values = c(
      'Normal' = 'green',
      'Poisson' = "yellow")) +
    labs(color = 'Function',x = "Coverage", y = "Counts") +
    ggtitle(plot_title) +
    scale_x_continuous(breaks = seq(0, max_cov, by = 1), limits = c(-0.5, max_cov)) +
    theme(legend.position = c(0.85,0.85),
          panel.background = element_blank(),
          panel.border = element_rect(fill=NA))
  OxCov <- ((sum(file$coverage == 0) / gsize) * 100)
  print(c(OxCov, "% of genome has not been sequenced, 0x coverage"))
  print(c(((pois[1]/ gsize) * 100), "% of genome pois estimated would have 0x coverage"))
  return(hist_plot)
}


# exercise 1

# step 1.3
## plot the genome coverage of reads in a histogram and overlay with two functions
plot1 <- distPlotter(c3x,3)
plot1


# step 1.5
plot2 <- distPlotter(c10x,10)
plot2

# step 1.6
plot3 <- distPlotter(c30x, 30)
plot3
