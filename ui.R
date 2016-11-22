#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("People and cars in the Netherlands"),
  h3("What factors are of influence on the number of cars?"),
  ("In this small shiny application we explore just a few factors, such as the length of the roads and railroads."),
  
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      numericInput ("population", label = h3("Population")                     , value = 14000000),
      checkboxInput("model_pop" , label = "Model: population        (show/hide)", value = TRUE),
      checkboxInput("model_rl"  , label = "Model: + road length     (show/hide)", value = TRUE),
      checkboxInput("model_rrl" , label = "Model: + railroad length (show/hide)", value = FALSE),
      
      #fluidRow(column(2, ("Cars: ")), column(8, verbatimTextOutput("cars"))),

      hr(),
      #submitButton("Submit"),
      
      h3("Usage"),
      ("Determine a population, somewhere between 14 and 20 million."),
      ("Choose one of the models to predict the number of cars. See which factor influences the number of cars the most."),
      ("Click on the submit button to activate a new calculation and change the plot."),
      ("Model 1 only takes the population into account, model 2 also takes the total length of the roads into account and the third model also takes the total lenght of the railroad into account."),
      hr(),
      ("Note that the models are not quite right (yet), e.g. one might expect that the more railroad we have the less cars we need... This seems not to be the case.")
    ),
    
    # Show a plot of the generated distribution
    # Dont like the layout just yet.
    mainPanel(
       h3("Basic models"),
       plotOutput("plotmodels"),
       
       h3("Predicted #cars from Model 1:"),
       textOutput("predmodel1"),
       
       h3("Predicted #cars from Model 2:"),
       textOutput("predmodel2"),

       h3("Predicted #cars from Model 3:"),
       textOutput("predmodel3")
    )
    
  ),
  ("For this simple application, we did not take other factor such as the road condition, the availability and costs of the public transport into account."),
  hr(),
  ("Note: This data is retrieved from: http://statline.cbs.nl/. However, I had to combine several queries, so it should not be treated as reliable data."),
  ("Copyright of original data (before it was merged): Centraal bureau voor statistiek, Nederland: http://statline.cbs.nl")
  
))
