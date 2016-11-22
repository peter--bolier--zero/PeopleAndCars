#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# load data once...
peoplecars <- read.csv("data/cbs_merged_traffic_people-mixed.csv", sep=";")
peoplecars$Infrastructuur.Lengte.bevaarbare.rivieren.en.kanalen.Totaal <- NULL # drop channels/boats
peoplecars <- na.omit(peoplecars) # lets drop any row with NA's in it.

colnames(peoplecars) <- c("year", "population", "roadlength", "railroadlength", "cars1jan") # rename columns for easier access, original names still in file though

population       <- max(peoplecars$population)
roadlength       <- max(peoplecars$roadlength)
railroadlength   <- max(peoplecars$railroadlength)


# Define server logic 
shinyServer(m1 <-
  function(input, output) {
    
    # just 3 simpel models to show something
    model_pop  <- lm(cars1jan ~ population, data = peoplecars)
    model_rl   <- lm(cars1jan ~ population + roadlength, data = peoplecars)
    model_rrl  <- lm(cars1jan ~ population + roadlength + railroadlength, data = peoplecars)
    
    model1.pred <- reactive(
      {
        population <- input$population
        predict(model_pop, newdata = data.frame(population))
      }
    )
    model2.pred <- reactive(
      {
        population <- input$population
        predict(model_rl, newdata = data.frame(population))
      }
    )
    model3.pred <- reactive(
      {
        population <- input$population
        predict(model_rrl, newdata = data.frame(population))
      }
    )
    
    
    output$plotmodels <- renderPlot({
      population <- input$population
      
      plot(peoplecars$population, peoplecars$cars1jan, type="l",
           xlab = "Population", ylab = "Number of cars", main="Cars in the Netherlands")
      #axis(1, 0:32,labels=0:32*10,line=3,col="blue",col.ticks="blue",col.axis="blue")
      
      if (input$model_pop) {
        # only 2 coefficients
        abline(model_pop, col = "blue", lwd="3")
      }
      
      if (input$model_rl) {
        # we have 3 coefficients, we keep the roadlength constant, not quite right. 
        abline(model_rl$coefficients[1] + model_rl$coefficients[3]*roadlength, model_rl$coefficients[2], col = "green", lwd="3")
      }
      
      if (input$model_rrl) {
        # we have 4 coefficients, we keep the roadlength and railroadlength constant, not quite right. 
        abline(model_rrl$coefficients[1] + model_rrl$coefficients[3]*roadlength + model_rrl$coefficients[4]*railroadlength, model_rrl$coefficients[2], col = "red", lwd="3")
      }
      
      #points(population, model1.pred(), col = "red" , pch = 16, cex = 2)
    })
    
    #output$cars <- renderText({32})
    
    output$predmodel1 <- renderText({model1.pred()})
    output$predmodel2 <- renderText({model2.pred()})
    output$predmodel3 <- renderText({model3.pred()})
  }
)
