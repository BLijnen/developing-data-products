## Load Shiny library
library(shiny)
library(dplyr)

# Data
sat.df<-read.csv("http://goo.gl/HKnl74")
sat.df$logdist<-log(sat.df$distance)
sat.df$sat.fact[sat.df$overall>=80]<-"Very satisfied"
sat.df$sat.fact[sat.df$overall>=60 & sat.df$overall<80]<-"Rather satisfied"
sat.df$sat.fact[sat.df$overall>=40 & sat.df$overall<60]<-"Rather dissatisfied"
sat.df$sat.fact[sat.df$overall<40]<-"Very dissatisfied"
sat.df$sat.fact<-factor(sat.df$sat.fact, levels=c("Very dissatisfied", 
                                                  "Rather dissatisfied", "Rather satisfied",
                                                  "Very satisfied",
                                                  labels=levels, ordered=TRUE))


shinyServer(function(input, output) {
        # We'll render the selected columns of our dataset apply filters and search options
        output$Details <- renderDataTable({
                # We need the selected text
                output$text1 <- renderText({ 
                })
                # Read our dataset 
                sat.df<-read.csv("http://goo.gl/HKnl74")
                ## We transform the variable "distance" with the log function
                sat.df$logdist<-log(sat.df$distance)
                ## We create a categorical variable using the overall satisfaction scores in the numerical variable "overall"
                sat.df$sat.fact[sat.df$overall>=80]<-"Very satisfied"
                sat.df$sat.fact[sat.df$overall>=60 & sat.df$overall<80]<-"Rather satisfied"
                sat.df$sat.fact[sat.df$overall>=40 & sat.df$overall<60]<-"Rather dissatisfied"
                sat.df$sat.fact[sat.df$overall<40]<-"Very dissatisfied"
                sat.df$sat.fact<-factor(sat.df$sat.fact, levels=c("Very dissatisfied", 
                                                                  "Rather dissatisfied", "Rather satisfied",
                                                                  "Very satisfied",
                                                                  labels=levels, ordered=TRUE))
                # filter based on categorical satisfaction variable
               sat.df <- filter(sat.df, sat.df$sat.fact == input$var)
               sat.df
                # Implement page wise menu
        }, options = list(lengthMenu = c(5, 10, 20), pageLength = 10))
        
        
        model1<-lm(overall~rides+games+wait+clean, data=sat.df)
        
        modelpred <- reactive({
                ridesinput <- input$sliderrides
                waitinput <- input$sliderwait
                gamesinput <- input$slidergames
                cleaninput <- input$sliderclean
                predict(model1, newdata=data.frame(rides=ridesinput, wait=waitinput,
                                                   games=gamesinput, clean=cleaninput))
        })
        
        output$pred <- renderText({
                modelpred()
                
        })
        
})
