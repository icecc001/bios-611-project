setwd("/Users/zxy/Desktop/BIOS611/bios-611-project")
library(tidyverse)
library(dplyr)
library(randomForest)
dat <- read.csv("source_data/african_crises.csv")
head(dat)
summary(dat)

model <- glm(systemic_crisis~ domestic_debt_in_default + as.factor(country) + inflation_crises, data = dat, family = binomial(link = "logit"))
summary(model)
## likelihood of generating a crisis

set.seed(222)
dat$country <- as.factor(dat$country)
dat_train <- dat %>% select(-case, -cc3, -year)
rf <- randomForest(systemic_crisis~., data=dat_train, proximity=TRUE)
png(file="figures/randomforest_varimp.png",width=500, height=300)
rf_varimp <- varImpPlot(rf,
                        sort = T,
                        n.var = 10,
                        main = "Variable Importance")
dev.off()
