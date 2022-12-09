#setwd("/Users/zxy/Desktop/BIOS611/bios-611-project")

library(tidyverse)
library(dplyr)
library(ggplot2)
library(RColorBrewer)
library(ggpubr)

dat <- read.csv("derived_data/african_crises_derived.csv")

group_systemic_by_year <- dat %>% select(year, systemic_crisis) %>%
  group_by(year) %>% summarise(nsystemic_crisis = sum(as.numeric(systemic_crisis)))

nsystemic_by_year <- ggplot(data=group_systemic_by_year)+
  geom_line(aes(year, nsystemic_crisis)) +
  ylab("Number of Systemic Crisis") + xlab("Year") + 
  ggtitle("Total number of Systemic Crisis for 13 Countries in Africa")
nsystemic_by_year
ggsave(nsystemic_by_year, filename = "figures/nsystemic_by_year.png", height = 6, width = 6)

countrylist <- unique(dat$country)
datforplot <- dat
datforplot$systemic_crisis <- as.numeric(datforplot$systemic_crisis)
for (i in 1:length(countrylist)) {
  datforplot$systemic_crisis[which(datforplot$country == countrylist[i])] <- 
    datforplot$systemic_crisis[which(datforplot$country == countrylist[i])] + (i-7) * 0.01
}

systemic_crisis_by_year_country <- ggplot(data=datforplot)+geom_line(aes(year, (systemic_crisis), color = country)) +
  geom_point(aes(year, (systemic_crisis), color = country)) +
  scale_y_continuous(breaks = c(0, 1)) + 
  scale_x_continuous(breaks = c(1860, 1880, 1900, 1920, 1940, 1960, 1980, 2000, 2020)) + 
  xlab("Year") + ylab("Systemic Crisis") + 
  ggtitle("Systemic Crisis by Year and Country")
systemic_crisis_by_year_country
ggsave(systemic_crisis_by_year_country, filename = "figures/systemic_crisis_by_year_country.png", height = 6, width = 10)


my.color <- brewer.pal(8, "Set2")
dat$systemic_crisis <- as.factor(dat$systemic_crisis)
systemic_crisis_count <- ggplot(dat, aes(x = as.factor(systemic_crisis))) + 
  geom_bar() + xlab("Systemic Crisis") + ylab("Count") + 
  scale_fill_manual(values = c(my.color[3])) + 
  ggtitle("Total Number of the Occurrence of Systemic Crisis in 13 African Countries")
systemic_crisis_count
ggsave(systemic_crisis_count, filename = "figures/systemic_crisis_count.png", height = 6, width = 8)

systemic_currency <- ggplot(dat, 
                            aes(x = currency_crises, 
                                fill = as.factor(systemic_crisis))) + 
  geom_bar(position = "fill") +
  labs(y = "Proportion") + 
  xlab("Currency Crisis") + 
  scale_fill_manual(values = c(my.color[3], my.color[2]), name = "Systemic Crisis")
systemic_currency
ggsave(systemic_currency, filename = "figures/systemic_currency.png", height = 6, width = 5)


systemic_independence <- ggplot(dat, 
                                aes(x = independence, 
                                    fill = as.factor(systemic_crisis))) + 
  geom_bar(position = "fill") +
  labs(y = "Proportion") + 
  xlab("Independence") + 
  scale_fill_manual(values = c(my.color[3], my.color[2]), name = "Systemic Crisis")
ggsave(systemic_independence, filename = "figures/systemic_independence.png", height = 6, width = 5)


systemic_inflation_crises <- ggplot(dat, 
                                    aes(x = inflation_crises, 
                                        fill = as.factor(systemic_crisis))) + 
  geom_bar(position = "fill") +
  labs(y = "Proportion") + 
  xlab("Inflation Crisis") + 
  scale_fill_manual(values = c(my.color[3], my.color[2]), name = "Systemic Crisis")
ggsave(systemic_inflation_crises, filename = "figures/systemic_inflation_crises.png", height = 6, width = 5)


systemic_banking_crisis <- ggplot(dat, 
                                  aes(x = banking_crisis, 
                                      fill = as.factor(systemic_crisis))) + 
  geom_bar(position = "fill") +
  labs(y = "Proportion") + 
  xlab("Banking Crisis") + 
  scale_fill_manual(values = c(my.color[3], my.color[2]), name = "Systemic Crisis")
ggsave(systemic_banking_crisis, filename = "figures/systemic_banking_crisis.png", height = 6, width = 5)


systemic_sovereign_external_debt_default <- ggplot(dat, 
                                                   aes(x = sovereign_external_debt_default, 
                                                       fill = as.factor(systemic_crisis))) + 
  geom_bar(position = "fill") +
  labs(y = "Proportion") + 
  xlab("Occurence of Sovereign Domestic Debt Default") + 
  scale_fill_manual(values = c(my.color[3], my.color[2]), name = "Systemic Crisis")
ggsave(systemic_sovereign_external_debt_default, filename = "figures/systemic_sovereign_external_debt_default.png", height = 6, width = 5)


systemic_domestic_debt_in_default <- ggplot(dat,
                                            aes(x = domestic_debt_in_default, 
                                                fill = as.factor(systemic_crisis))) + 
  geom_bar(position = "fill") +
  labs(y = "Proportion") + 
  xlab("Occurence of Domestic Debt Default") + 
  scale_fill_manual(values = c(my.color[3], my.color[2]), name = "Systemic Crisis")
ggsave(systemic_domestic_debt_in_default, filename = "figures/systemic_domestic_debt_in_default.png", height = 6, width = 5)


systemic_exch_usd <- ggplot(dat, aes(x = systemic_crisis, y = exch_usd)) +
  geom_boxplot(fill = my.color[3], varwidth = TRUE) +
  labs(x = "Systemic Crisis", y = "Exchange Rate of the Country vis-a-vis the USD")
ggsave(systemic_exch_usd, filename = "figures/systemic_exch_usd.png", height = 6, width = 5)

p <- ggarrange(systemic_currency, systemic_independence, systemic_inflation_crises, systemic_banking_crisis, systemic_sovereign_external_debt_default, systemic_domestic_debt_in_default, nrow = 2, ncol = 3, common.legend = T)
p
ggsave(p, filename = "figures/correlation_plots.png", height = 8, width = 12)
