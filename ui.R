library(shiny)

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


shinyUI(fluidPage(
        # Application title
        titlePanel("Analyzing customer satisfaction data"),
        br(),
        br(),
        
        
        sidebarPanel(
                helpText("By selecting 1 of the 4 satisfaction levels in the list below,
                         only the data of the choosen subset will be shown in the table."),
                selectInput("var", 
                            label = "Choose a satisfaction level",
                            choices = c("Very dissatisfied", "Rather dissatisfied",
                                        "Rather satisfied", "Very satisfied"),
                            selected = "Very satisfied"),
                helpText("The resulting subset contains values on all variables, but only for subjects related to 
                         the selected satisfaction level. By using the cases below each column you can filter on specific values 
                         of that column. You can use the drop-down list in the left corner to select the number of rows 
                         you want to display. The arrows next to each variable label, you can sort the column values")),
        br(),
        br(),
        # Call Data table    
        mainPanel(dataTableOutput("Details"),
                 textOutput("text1"),
                  br(),
                  br(),
                  
                 fluidPage(
                         titlePanel("Predicting Overall satisfaction"),
                         sidebarLayout(
                                 sidebarPanel(
                                         sliderInput("sliderrides", "Choose a satisfaction score for the rides at the theme park", 
                                                     min=0, max=100, value=100),
                                         sliderInput("sliderwait", "Choose a satisfaction score for the waiting times at the theme park", 
                                                     min=0, max=100, value=100),
                                         sliderInput("slidergames", "Choose a satisfaction score for the games at the theme park", 
                                                     min=0, max=100, value=100),
                                         sliderInput("sliderclean", "Choose a satisfaction score for the cleanliness of the theme park", 
                                                     min=0, max=100, value=100),
                                         submitButton("Submit")
                                 ),
                                 mainPanel(
                                         h3("Predicted overall satisfaction from model with 4 predictors:"),
                                         textOutput("pred")  
                                         
                                         
                                 )
                                 
                                 
                                 
                         )
                 )
        )))

