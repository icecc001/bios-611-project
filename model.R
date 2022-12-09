#setwd("/Users/zxy/Desktop/BIOS611/bios-611-project")
library(tidyverse)
library(dplyr)
library(randomForest)
library(ROCit)
library(ggplot2)
library(RColorBrewer)
dat <- read.csv("derived_data/african_crises_derived.csv")
head(dat)
summary(dat)
my.color <- brewer.pal(8, "Set2")

## random forest
set.seed(222)
dat_0 <- dat %>% filter(systemic_crisis==0)
dat_1 <- dat %>% filter(systemic_crisis==1)
tts0 <- runif(nrow(dat_0)) < 0.7
tts1 <- runif(nrow(dat_1)) < 0.7

train <- rbind((dat_0 %>% filter(tts0)), (dat_1 %>% filter(tts1)))
test <- rbind((dat_0 %>% filter(!tts0)), (dat_1 %>% filter(!tts1)))

train <- train %>% select(-year)
rf <- randomForest(as.numeric(systemic_crisis)~., data=train, proximity=TRUE)
rf$importance
importance_table <- rf$importance
var <- rownames(importance_table)
importance_table <- cbind(importance_table, var)
importance_table <- as.data.frame(importance_table)
importance_table$IncNodePurity <- as.numeric(importance_table$IncNodePurity)
importance_table <- importance_table[order(importance_table$IncNodePurity, decreasing = T),]
importance_table$var = factor(importance_table$var, levels=importance_table$var[order(importance_table$IncNodePurity, decreasing = F)])
rf_var_importance_plot <- ggplot(importance_table, aes(x = var, y = (IncNodePurity))) + 
  geom_bar(stat="identity", aes(fill = "blue")) + xlab("Variables") + ylab("Importance") + 
  ggtitle("Variable Importance Plot (Random Forest)") + 
  coord_flip() +theme_bw()+ theme(legend.position = "none")
rf_var_importance_plot
ggsave(rf_var_importance_plot, filename = "figures/rf_var_importance_plot.png", height = 6, width = 8)


rf_prob <- predict(rf, newdata=test, type="response")
rf_prob_predict <- (rf_prob > 0.5)
test <- cbind(test, rf_prob_predict)
confusion <- test %>% group_by(systemic_crisis, rf_prob_predict) %>% tally()
confusion

ROCit_obj <- rocit(score=as.vector(rf_prob),class=(test$systemic_crisis))
png("figures/rf_ROCit_obj.png")
plot(ROCit_obj)
dev.off()
AUC_rf <- ROCit_obj$AUC

## time series glm
dat$systemic_crisis <- as.factor(dat$systemic_crisis)
model <- glm(systemic_crisis~ ., data = dat, family = binomial(link = "logit"))
summary(model)

countrylist <- unique(dat$country)
withlagdat <- c()
for (i in 1:length(countrylist)) {
  yeartab <- data.frame(year = 1860:2014)
  tempdat <- dat[which(dat$country == countrylist[i]),]
  tempdat <- tempdat[order(tempdat$year),]
  tempdat <- merge(yeartab, tempdat, by = 'year', all.x = T)
  tempdat$lag_systemic_crisis <- lag(tempdat$systemic_crisis)
  tempdat$lag_exch_usd <- lag(tempdat$exch_usd)
  tempdat$lag_domestic_debt_in_default <- lag(tempdat$domestic_debt_in_default)
  tempdat$lag_sovereign_external_debt_default <- lag(tempdat$sovereign_external_debt_default)
  tempdat$lag_gdp_weighted_default <- lag(tempdat$gdp_weighted_default)
  tempdat$lag_inflation_annual_cpi <- lag(tempdat$inflation_annual_cpi)
  tempdat$lag_independence <- lag(tempdat$independence)
  tempdat$lag_currency_crises <- lag(tempdat$currency_crises)
  tempdat$lag_inflation_crises <- lag(tempdat$inflation_crises)
  tempdat$lag_banking_crisis <- lag(tempdat$banking_crisis)
  withlagdat <- rbind(withlagdat, tempdat)
}
withlagdat <- withlagdat %>% select (-year)
model_lag_glm <- glm(systemic_crisis~ lag_systemic_crisis + lag_exch_usd + lag_domestic_debt_in_default
             + lag_sovereign_external_debt_default + lag_gdp_weighted_default + 
               lag_inflation_annual_cpi + lag_independence + 
               lag_currency_crises + lag_inflation_crises + 
               lag_banking_crisis + as.factor(country), data = withlagdat, family = binomial(link = "logit"))
summary(model)
summary(predict(model, type = "response"))

model_lag_cur_glm <- glm(systemic_crisis~ lag_systemic_crisis + lag_exch_usd + lag_domestic_debt_in_default
                             + lag_sovereign_external_debt_default + lag_gdp_weighted_default + 
                               lag_inflation_annual_cpi + lag_independence + 
                               lag_currency_crises + lag_inflation_crises + 
                               lag_banking_crisis + as.factor(country) + 
                          exch_usd + domestic_debt_in_default + sovereign_external_debt_default
                         + gdp_weighted_default + inflation_annual_cpi + independence + 
                           currency_crises + inflation_crises + banking_crisis
                           , data = withlagdat, family = binomial(link = "logit"))
summary(model_lag_cur_glm)
summary(predict(model, type = "response"))


dat_0 <- withlagdat %>% filter(systemic_crisis==0)
dat_1 <- withlagdat %>% filter(systemic_crisis==1)
tts0 <- runif(nrow(dat_0)) < 0.7
tts1 <- runif(nrow(dat_1)) < 0.7

train <- rbind((dat_0 %>% filter(tts0)), (dat_1 %>% filter(tts1)))
test <- rbind((dat_0 %>% filter(!tts0)), (dat_1 %>% filter(!tts1)))

model_lag_glm_train <- glm(systemic_crisis~ lag_systemic_crisis + lag_exch_usd + lag_domestic_debt_in_default
                   + lag_sovereign_external_debt_default + lag_gdp_weighted_default + 
                     lag_inflation_annual_cpi + lag_independence + 
                     lag_currency_crises + lag_inflation_crises + 
                     lag_banking_crisis + as.factor(country), data = train, family = binomial(link = "logit"))
rf_prob <- predict(model_train, newdata=test, type="response")
rf_prob_predict <- (rf_prob > 0.5)
test <- cbind(test, rf_prob_predict)
confusion <- test %>% group_by(systemic_crisis, rf_prob_predict) %>% tally()
confusion

ROCit_obj <- rocit(score=as.vector(rf_prob),class=(test$systemic_crisis))
AUC_model_lag_glm_train <- ROCit_obj$AUC

model_lag_cur_glm_train <- glm(systemic_crisis~ lag_systemic_crisis + lag_exch_usd + lag_domestic_debt_in_default
                         + lag_sovereign_external_debt_default + lag_gdp_weighted_default + 
                           lag_inflation_annual_cpi + lag_independence + 
                           lag_currency_crises + lag_inflation_crises + 
                           lag_banking_crisis + as.factor(country) + 
                           exch_usd + domestic_debt_in_default + sovereign_external_debt_default
                         + gdp_weighted_default + inflation_annual_cpi + independence + 
                           currency_crises + inflation_crises + banking_crisis
                         , data = train, family = binomial(link = "logit"))
lag_cur_glm_prob <- predict(model_lag_cur_glm_train, newdata=test, type="response")
lag_cur_glm_prob_predict <- (lag_cur_glm_prob > 0.5)
test <- cbind(test, lag_cur_glm_prob_predict)
confusion <- test %>% group_by(systemic_crisis, lag_cur_glm_prob_predict) %>% tally()
confusion

ROCit_obj_lag_cur_glm_train <- rocit(score=as.vector(lag_cur_glm_prob),class=(test$systemic_crisis))
AUC_model_lag_cur_glm_train <- ROCit_obj_lag_cur_glm_train$AUC

save.image(file = "derived_data/model.RData")

