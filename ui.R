# csv-defined Shiny structure


source("helper.R")

shinyUI(fluidPage(titlePanel("csv-defined Shiny structure"),                               
    fluidRow(
    column(2,
           h3("Select ID"),
                    wellPanel(numericInput(inputId="num", label='Enter ID', value=NaN),
                              uiOutput("dates") 
    )),

    
    #do.call will call the navbarPage function with the arguments in the tabs list
    shinyUI(fluidRow(
      column(12,
             "", 
             do.call(navbarPage,tabs)
      )))
  
  )))