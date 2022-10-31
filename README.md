# README: Africa Economic, Banking and Systemic Crisis

## Data

- In this project, we use data data on economic and financial crises in 13 African countries (1860 to 2014).  (It is inspired by https://www.kaggle.com/datasets/chirin/africa-economic-banking-and-systemic-crisis-data)

- This dataset is a derivative of Reinhart et. al's Global Financial Stability dataset which can be found online at: https://www.hbs.edu/behavioral-finance-and-financial-stability/data/Pages/global.aspx

- The dataset specifically focuses on the Banking, Debt, Financial, Inflation and Systemic Crises that occurred, from 1860 to 2014, in 13 African countries, including: Algeria, Angola, Central African Republic, Ivory Coast, Egypt, Kenya, Mauritius, Morocco, Nigeria, South Africa, Tunisia, Zambia and Zimbabwe.

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