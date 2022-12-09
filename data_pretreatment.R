#setwd("/Users/zxy/Desktop/BIOS611/bios-611-project")

library(tidyverse)
library(dplyr)

dat <- read.csv("source_data/african_crises.csv")
summary(dat)
dat$currency_crises <- as.factor(dat$currency_crises)
dat <- dat[which(dat$currency_crises != 2),]
dat$inflation_crises <- as.factor(dat$inflation_crises)
dat$banking_crisis <- as.factor(dat$banking_crisis)
summary(dat$banking_crisis)
dat$banking_crisis <- as.factor(abs(as.integer(factor(dat$banking_crisis)) - 2))
dat$independence <- as.factor(dat$independence)
dat$country <- as.factor(dat$country)
dat$sovereign_external_debt_default <- as.factor(dat$sovereign_external_debt_default)
dat$domestic_debt_in_default <- as.factor(dat$domestic_debt_in_default)
summary(dat)
dat <- dat %>% select(-case, -cc3)
table(dat$country)
colnames(dat)

write.csv(dat, file = "derived_data/african_crises_derived.csv", row.names = F)
