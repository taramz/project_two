library(gtsummary)
library(ggplot2)
library(tidyverse)
library(mice)
library(corrplot)

data <- read.csv('../project2.csv')
head(data)

data <- data %>%
  mutate_at(c("bw", "weight_today.36", "inspired_oxygen.36", "p_delta.36",
               "peep_cm_h2o_modified.36", "weight_today.44", "inspired_oxygen.44", 
               "p_delta.44", "peep_cm_h2o_modified.44"), function(x) (x - mean(x, na.rm = TRUE))/sd(x, na.rm=TRUE)) %>%
  select(c("bw", "weight_today.36", "inspired_oxygen.36", "p_delta.36",
           "peep_cm_h2o_modified.36", "weight_today.44", "inspired_oxygen.44", 
           "p_delta.44", "peep_cm_h2o_modified.44"))

# Check for outliers
data %>%
  summarise_all(list(min = min, max = max), na.rm=TRUE)
  


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

data %>%
  group_by(center) %>%
  summarize(n())

length(unique(data$record_id))

# Center 2 has the largest amount of trach - maybe it is for more severe cases?
# Maybe it is just due to the larger sample size?
data %>%
  filter(!is.na(center)) %>%
  group_by(center) %>%
  summarize(n_trach = sum(Trach, na.rm = FALSE))

data %>%
  tbl_summary(include = c(-record_id)) %>%
  add_n(statistic = "{p_miss}%")

# Missing data for each column by center
# Identify differences in what data centers do/don't collect
data_na <- data %>%
  filter(!is.na(center)) %>%
  group_by(center) %>%
  summarise(across(everything(), function(x) sum(is.na(x))))

data %>%
  tbl_summary(by = center, include = (sga))

data %>%
  mutate(Death = case_when(Death == 'Yes' ~ 1,
                           Death == 'No' ~ 0)) %>%
  group_by(center) %>%
  filter(n() > 4) %>%
  summarize(Trach = sum(as.numeric(Trach), na.rm = TRUE),
            Percent_Trach = round(Trach/n(), 2) * 100) %>%
  dplyr::select(center, Percent_Trach)


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

data <- data %>%
  mutate(growth = weight_today.44 - weight_today.36)

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

data %>%
  group_by(gender) %>%
  summarise(sum(Trach, na.rm = TRUE))

# Imbalanced data - ~85% of the data has not received trach, ~15% have
data %>%
  group_by(Trach) %>%
  summarise(count = n(),
            percent = n()/nrow(data))

weight_over_time <- data %>%
  pivot_longer(c(bw, weight_today.36, weight_today.44), names_to = "time", values_to = "weight") %>%
  dplyr::select(record_id, time, weight) %>%
  mutate(time = case_when(time == 'bw' ~ 0,
                          time == 'weight_today.36' ~ 36,
                          time == 'weight_today.44' ~ 44))

# Spaghetti Plots
# Not very informative
ggplot(weight_over_time) +
  geom_line(aes(x = time, y = weight, group = record_id))


ggplot(data) +
  geom_histogram(aes(x = inspired_oxygen.36))
ggplot(data) +
  geom_histogram(aes(x = inspired_oxygen.44))


data 

ggplot(data) +
  geom_boxplot(aes(x = p_delta.36))

range(data$p_delta.36, na.rm = TRUE)
range(data$peep_cm_h2o_modified.36, na.rm = TRUE)

range(data$p_delta.44, na.rm = TRUE)
range(data$peep_cm_h2o_modified.44, na.rm = TRUE)




ggplot(data) +
  geom_histogram(aes(x = peep_cm_h2o_modified.36))

