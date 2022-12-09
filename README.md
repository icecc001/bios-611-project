# README: Africa Economic, Banking and Systemic Crisis

Author: Xinyu Zhang

Last Revision Date: 2022/12/08

## Introduction

Since the last century, African countries have gained independence one after another. In their quest for economic development, some countries have also encountered systemic economic crises during certain years.

## Motivation

- Studying possible factors that generate systematic crisis is quite important. For developing countries, those study might help policy-makers implement better policies when systematic crisis is about to happen.
- Studying historical data on Africa economic, banking and systematic crisis may help us predict future crisis.

## A Quick View of Results

- This project builds a model to predict the risk of having systemic crisis based for 13 African countries and evaluate the importance of exlanatory variables. 

- This project also builds a system based on the random forest model to predict the potential systemic risk in the 13 African countries. 

![risk_prediction_system](risk_prediction_system.png)

## Using this Repository

This repository can be built by Docker. This command will create a docker container. 

```bash
docker build -t 611-project-africa .
```

Then we can start our customized container with the following command

```bash
docker run -v $(pwd):/home/rstudio\
           -p 8787:8787\
           -p 8080:8080\
           -e PASSWORD=yourpassword\
           -it 611-project-africa
```

## What to Look at

If you want to generate a specific result, you can also do so by entering the following command:

```bash
make figures/randomforest_varimp.png
```

The following command generate the final report (you need to first generate the results included in the report):

```bash
make report.pdf
```

You can use shiny to view our prediction of risk of systemic crisis in 13 African countries interactively (you can open the shiny website on [http://localhost:8080](http://localhost:8080/)):

```bash
make shiny
```

You can use the checkboxes on the left hand side to generate different predictions.

## Acknowledgement

Reinhart, C., Rogoff, K., Trebesch, C. and Reinhart, V. (2019) Global Crises Data by Country.
[online] https://www.hbs.edu/behavioral-finance-and-financial-stability/data. Available at: https://www.hbs.edu/behavioral-finance-and-financial-stability/data/Pages/global.aspx [Accessed: 17 July 2019].