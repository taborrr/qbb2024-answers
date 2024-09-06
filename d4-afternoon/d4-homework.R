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
dnm_summary <- dnm %>%
  group_by(Proband_id) %>%
  summarize(n_paternal_dnm = sum(Phase_combined == "father", na.rm = TRUE),
            n_maternal_dnm = sum(Phase_combined == "mother", na.rm = TRUE))
# step 1.3
## in exercise 1 section at the top

# step 1.4
dnm_by_parental_age <- left_join(dnm_summary, ages, by = "Proband_id")


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
### the count of maternal de novo mutations vs. paternal age
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
### there is a 0.4 increase in DNMs. with a very small pvalue, the model
### has a y-int of 2.5 and positive slope of 0.4 which appears
### representative of the general shape of the scatter plot
### as seen in the 2.1.1 plot. the 0.4 slope is positive 
## step 2.2.2
### the relationship is in fact significant. this means, that given
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
### 10.3 increase in DNMs. with a very small pvalue, the model
### has a y-int of 10.3 and positive slope of 1.4 which appears
### representative of the general shape of the scatter plot
### as seen in the 2.1.2 plot. the 1.4 slope is positive 
## step 2.3.2
## step 2.2.2
### the relationship is very significant. There is meaningful
### correlation between paternal age and paternal DNMs. the 
### probability is very very small to have the data randomly 
### fit a linear model. the observed correlation is unlikely 
### to be random. Pvalue is less than 2.2e-16

# step 2.4
### if the 




