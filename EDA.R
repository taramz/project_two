library(gtsummary)
library(ggplot2)
library(tidyverse)
library(mice)
library(corrplot)

data <- read.csv('../project2.csv')
head(data)

# 64% of the data comes from center 2
# This could bias the results as the analysis might only be representative
# of individuals from that center. Maybe center 2 has unique characteristics
# compared to the other centers?
data %>%
  filter(!is.na(center)) %>%
  group_by(center) %>%
  summarize(n = n()) %>%
  ungroup() %>%
  mutate(percent = n/sum(n) * 100)

# Center 2 has the largest amount of trach - maybe it is for more severe cases?
# Maybe it is just due to the larger sample size?
data %>%
  filter(!is.na(center)) %>%
  group_by(center) %>%
  summarize(n_trach = sum(Trach, na.rm = FALSE))

data %>%
  tbl_summary(by = center, include = c(-record_id))

# Missing data for each column by center
# Identify differences in what data centers do/don't collect
data_na <- data %>%
  filter(!is.na(center)) %>%
  group_by(center) %>%
  summarise(across(everything(), function(x) sum(is.na(x))))

data %>%
  tbl_summary(by = center, include = (sga))


ggplot(data) +
  geom_boxplot(aes(y = bw, x = as.factor(center))) +
  ggtitle('Birth Weight by Center') +
  xlab('Center') +
  ylab('Birth Weight (g)')

ggplot(data) +
  geom_histogram(aes(x = bw, fill = as.factor(center)), alpha = 0.2, position = "identity")

# Demographic data
data %>%
  tbl_summary(include = c(mat_race, mat_ethn, gender))

# Multicollinearity
cor_mat <- data %>%
  select_if(is.numeric) %>%
  select(bw, ga, blength, birth_hc, weight_today.36, inspired_oxygen.36, p_delta.36, peep_cm_h2o_modified.36, weight_today.44, inspired_oxygen.44, p_delta.44, peep_cm_h2o_modified.44) %>%
  cor(use = "complete.obs")

colnames(cor_mat) <- c("Birth Weight", "Gestational Age", "Birth Length", "Birth Head Circumference", "Weight (36)", "Inspired O2 (36)", "Peak Inspiratory Pressure (36)", "PEEP (36)", 
                       "Weight (44)", "Inspired O2 (44)", "Peak Inspiratory Pressure (44)", "PEEP (44)")
rownames(cor_mat) <- c("Birth Weight", "Gestational Age", "Birth Length", "Birth Head Circumference", "Weight (36)", "Inspired O2 (36)", "Peak Inspiratory Pressure (36)", "PEEP (36)", 
                       "Weight (44)", "Inspired O2 (44)", "Peak Inspiratory Pressure (44)", "PEEP (44)")

corrplot(cor_mat, method = "number", type = "lower", tl.cex = 0.8, tl.col = "black", tl.srt = 45)

            