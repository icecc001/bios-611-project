# README: Africa Economic, Banking and Systemic Crisis

Author: Xinyu Zhang

Last Revision Date: 2022/11/07

## Data

- In this project, we use data data on economic and financial crises in 13 African countries (1860 to 2014).  (It is inspired by https://www.kaggle.com/datasets/chirin/africa-economic-banking-and-systemic-crisis-data)

- This dataset is a derivative of Reinhart et. al's Global Financial Stability dataset which can be found online at: https://www.hbs.edu/behavioral-finance-and-financial-stability/data/Pages/global.aspx

- The dataset specifically focuses on the Banking, Debt, Financial, Inflation and Systemic Crises that occurred, from 1860 to 2014, in 13 African countries, including: Algeria, Angola, Central African Republic, Ivory Coast, Egypt, Kenya, Mauritius, Morocco, Nigeria, South Africa, Tunisia, Zambia and Zimbabwe.

- The dataset contains 14 variables:

  | Variable Name                   | Meaning                                                      |
  | ------------------------------- | ------------------------------------------------------------ |
  | case                            | A number which denotes a specific country                    |
  | cc3                             | A three letter country code                                  |
  | country                         | The name of the country                                      |
  | year                            | The year of the observation                                  |
  | systemetic_crisis               | "0" means that no systemic crisis occurred in the year and "1" means that a systemic crisis occurred in the year. |
  | exch_usd                        | The exchange rate of the country vis-a-vis the USD           |
  | domestic_debt_in_default        | "0" means that no sovereign domestic debt default occurred in the year and "1" means that a sovereign domestic debt |
  | sovereign_external_debt_default | "0" means that no sovereign external debt default occurred in the year and "1" means that a sovereign external debt default occurred in the |
  | gdp_weighted_default            | The total debt in default vis-a-vis the GDP                  |
  | inflation_annual_cpi            | The annual CPI Inflation rate                                |
  | independence                    | "0" means "no independence" and "1" means "independence"     |
  | currency_crises                 | "0" means that no currency crisis occurred in the year and "1" means that a currency crisis occurred in the year |
  | inflation_crises                | "0" means that no inflation crisis occurred in the year and "1" means that an inflation crisis occurred in the year |
  | banking_crisis                  | "no_crisis" means that no banking crisis occurred in the year and "crisis" means that a banking crisis occurred in the year |

- ### Acknowledgements

  Reinhart, C., Rogoff, K., Trebesch, C. and Reinhart, V. (2019) Global Crises Data by Country.
  [online] https://www.hbs.edu/behavioral-finance-and-financial-stability/data. Available at: https://www.hbs.edu/behavioral-finance-and-financial-stability/data/Pages/global.aspx [Accessed: 17 July 2019].

## Motivation

- Studying possible factors that generate systematic crisis is quite important. For developing countries, those study might help policy-makers implement better policies when systematic crisis is about to happen.
- Studying historical data on africa economic, banking and systematic crsis may help us predict future crisis.

## Using this Repository

This repository can be built by Docker. This command will create a docker container. 

```bash
docker build -t 611-project-africa .
```

Then we can start our customized container with the following command

```bash
docker run -v $(pwd):/home/rstudio\
           -p 8787:8787\
           -e PASSWORD=yourpassword\
           -it 611-project-africa
```

## What to Look at

The following command generate the final report:

```bash
make report.pdf
```

If you want to generate a specific result, you can also do so by entering the following command:

```bash
make figures/randomforest_varimp.png
```

## Result

### Random Forest

![randomforest_varimp](figures/randomforest_varimp.png)