# Day 4 homework

library(tidyverse)
library(broom)

# exercise 1
dnm <- read_csv(file = "~/qbb2024-answers/d4-afternoon/aau1043_dnm.csv")
ages <- read_csv(file = "~/qbb2024-answers/d4-afternoon/aau1043_parental_age.csv")

# step 1.1
head(dnm)
length(unique(dnm$Proband_id))
length(unique(dnm$Chr))
unique(dnm$Sanger)
head(ages)
length(unique(ages$Proband_id))
length(unique(ages$Father_age))
unique(ages$Father_age)
length(unique(ages$Mother_age))
unique(ages$Mother_age)

# step 1.2
## tabulate the number of paternally and maternally inherited DNMs in each proband
dnm_sumry <- dnm %>%
  group_by(Proband_id) %>%
  summarize(n_paternal_dnm = sum(Phase_combined == "father", na.rm = TRUE),
            n_maternal_dnm = sum(Phase_combined == "mother", na.rm = TRUE))
head(dnm_sumry)

# step 1.3
## in exercise 1 section at the top, called "ages"

# step 1.4
dnm_by_parental_age <- left_join(dnm_sumry, ages, by = "Proband_id")
head(dnm_by_parental_age)

# exercise 2

# step 2.1

## step 2.1.1
### the count of maternal de novo mutations vs. maternal age
ggplot(data = dnm_by_parental_age, 
       mapping = aes(x = Mother_age, y = n_maternal_dnm)) +
  geom_point() +
  xlab("Maternal Age") +
  ylab("Maternal DNMs of Child") +
  ggtitle("Relationship between Maternal Age and count of maternal de novo mutations") 
  
  
## step 2.1.2
### the count of paternal de novo mutations vs. paternal age
ggplot(data = dnm_by_parental_age, 
       mapping = aes(x = Father_age, y = n_paternal_dnm)) +
  geom_point() +
  xlab("Paternal Age") +
  ylab("Paternal DNMs of Child") +
  ggtitle("Relationship between Paternal Age and count of paternal de novo mutations") 

# step 2.2

lm(data = dnm_by_parental_age,
   formula = n_maternal_dnm ~ 1 + Mother_age) %>%
  summary()
## step 2.2.1
### size of the relationship? for every year older the mom
### there is a 0.38 increase in DNMs in her offspring. with a 
### very small pvalue, the model has a y-int of 2.5 and positive 
### slope of 0.38 which appears representative of the general 
### shape of the scatter plot, corroborating the linear model.
### this means, the older the mom, the more DNMs are likely
### to appear, at a rate of about 38 DNMs for every 10 years
### older the mom. as seen in the 2.1.1 plot. the 0.38 slope is positive.
## step 2.2.2
### the relationship is in fact significant. Given the situation that
### the data has no relationship (no correlation between maternal age
### and maternal DNMs) the probability is very very small to have 
### the data randomly fit a linear model. in other words, the observed
### correlation is unlikely to be random. Pvalue = less than 2.2e-16

# step 2.3
lm(data = dnm_by_parental_age,
   formula = n_paternal_dnm ~ 1 + Father_age) %>%
  summary()
## step 2.3.1
### size of the relationship? every year older the dad, there is a
### 1.35 increase in DNMs. with a very small pvalue, the model
### has a y-int of 10.3 and positive slope of 1.35 which appears
### representative of the general shape of the scatter plot
### as seen in the 2.1.2 plot. the 1.35 slope is positive. For
### every 10 years older the dad, there is likely 13 DNMs to 
### appear in the proband from paternal origin. 

### This relationship is significant with a pvalue of 2.2e^-16 which
### is as significant as with the maternal age and dnm plot above.
### in other words, this is not random chance but there truly is
### a correlation between paternal age and the number of DNMs
### the proband inherited paternally. There is meaningful
### correlation between paternal age and paternally originating
### DNMs.the observed correlation is unlikely to be random.

# step 2.4
## predict number of paternal DNMs for a proband with a 50.5 years old dad
### y = b + mx
### dnms = 10.32632 + 1.35384 * X
### X = 50.5
10.32632 + 1.35384*50.5
### the number of paternal origin DNMs is = 78.7 on the proband


# step 2.5
for_hist_plot <- dnm_sumry[ ,c(2,3)]
head(for_hist_plot)
dad <- for_hist_plot$n_paternal_dnm 
mom <- for_hist_plot$n_maternal_dnm
# Create overlapping histogram
ggplot() +
  geom_histogram(aes(x = dad, fill = 'blue'), alpha = 0.4) +
  geom_histogram(aes(x = mom, fill = 'pink'), alpha = 0.4) +
  labs(title = "Multiple Overlaid Histograms", x = "DNMs", y = "Frequency")

