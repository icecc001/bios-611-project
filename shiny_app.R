#setwd("/Users/zxy/Desktop/BIOS611/bios-611-project/")

library(shiny)
load("derived_data/model.RData")
# Define UI for app that draws a histogram ----
ui <- fluidPage(
  tags$head(
    tags$style(
      ".title {text-align:center;}"
    )
  ),
  
  # App title ----
  titlePanel("Predicted Probability of Systemic Crisis for 13 African Countries"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Input:  ----
      
      checkboxGroupInput("domestic_debt_in_default", label = h3("Domestic debt default"), 
                         choices = list("No" = 0, "Yes" = 1),
                         selected = 0),
      
      checkboxGroupInput("sovereign_external_debt_default", label = h3("Sovereign external debt default"), 
                         choices = list("No" = 0, "Yes" = 1),
                         selected = 0),
      
      checkboxGroupInput("independence", label = h3("Independence"), 
                         choices = list("No" = 0, "Yes" = 1),
                         selected = 0),
      
      checkboxGroupInput("currency_crises", label = h3("Currency Crises"), 
                         choices = list("No" = 0, "Yes" = 1),
                         selected = 0),
      
      checkboxGroupInput("inflation_crises", label = h3("Inflation Crises"), 
                         choices = list("No" = 0, "Yes" = 1),
                         selected = 0),
      
      checkboxGroupInput("banking_crisis", label = h3("Banking Crisis"), 
                         choices = list("No" = 0, "Yes" = 1),
                         selected = 0),
      
      numericInput("exch_usd", label = h3("Exchange rate of the country vis-a-vis the USD"), value = 1),
      
      numericInput("gdp_weighted_default", label = h3("Total debt in default vis-a-vis the GDP"), value = 1),
      
      numericInput("inflation_annual_cpi", label = h3("Annual CPI inflation rate"), value = 1),
      
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: Histogram ----
      plotOutput(outputId = "PredictedPlot")
      
    )
  )
)

# Define server logic required to draw a histogram ----
server <- function(input, output) {
  
  output$PredictedPlot <- renderPlot({
    predict_data <- data.frame(country = countrylist)
    predict_data$domestic_debt_in_default <- as.numeric(input$domestic_debt_in_default)
    predict_data$sovereign_external_debt_default <- as.numeric(input$sovereign_external_debt_default)
    predict_data$independence <- as.numeric(input$independence)
    predict_data$currency_crises <- as.numeric(input$currency_crises)
    predict_data$inflation_crises <- as.numeric(input$inflation_crises)
    predict_data$banking_crisis <- as.numeric(input$banking_crisis)
    predict_data$gdp_weighted_default <- as.numeric(input$gdp_weighted_default)
    predict_data$inflation_annual_cpi <- as.numeric(input$inflation_annual_cpi)
    predict_data$exch_usd <- as.numeric(input$exch_usd)
    predict_data$predicted_probability <- predict(rf, newdata=predict_data, response = T)
    predict_data$country = factor(predict_data$country, levels=predict_data$country[order(predict_data$predicted_probability, decreasing = T)])
    ggplot(predict_data, aes(x = country, y = (predicted_probability))) + 
      geom_bar(stat="identity", aes(fill = "blue")) + xlab("Country") + ylab("Predicted Probability") + 
      ggtitle("")  + theme_bw()+ theme(legend.position = "none", axis.text.x = element_text(angle = 20, hjust = 1))
  })
  
}

# Start the Server
shinyApp(ui=ui,server=server,
         options=list(port=8080, host="0.0.0.0"))

