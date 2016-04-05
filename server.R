# csv-defined Shiny structure


shinyServer(function(input, output, session) {  
  
#  Make the 'Select Date' dropdown appear, populated with what ID you select.
output$dates<-renderUI({
  selectInput('dates', 'Select Date', choices=df_ID[which(df_ID$ID == input$num), ]$Date, selectize = FALSE)
})

# Iterate through the tabs, creating ggplots and inserting them into a list.
lapply(seq(1:number_of_tabs), function(i) {

  output[[paste0("plot",i)]] <- renderPlot({  #<-- lapply will fill up each tab and create one ggplot. This names them correctly.

# Plot the first tab when Shiny boots
  if (is.null(input$dates)){
    df_plot <- df_ID[1, ]
  }else{
    df_plot <- filter(df_ID, ID==input$num, Date==input$dates)
  }
  
  validate(
    need(input$num, "Please select an ID"))
  validate(
    need(is.element(input$num, df_ID[which(df_ID$ID==input$num), ]$ID) , "No such ID")) 
          

  variable <- list_of_vars_in_tabs[[i]]
  x_axis_labels <- list_of_yaxis_labels[[i]]

  df_plot <- subset(df_plot, select = c('Date', variable))
  df_plot <- melt(df_plot)

  # Create your ggplot here.
  p <-  ggplot()
  p <- p + geom_bar(data=df_plot, aes(x=variable, y=value), stat="identity")
  p <- p + scale_y_continuous(limit=c(0,  100), breaks=c(0,10,20,30,40,50, 60, 70, 80, 90, 100))
  p <- p + scale_x_discrete(labels=x_axis_labels)  

# Any arbitrary key works for inserting the plot into the list_of_ggplots
  list_of_ggplots[["to_UI"]] <<- p 
  
  print(list_of_ggplots)  #<-- this gets sent out to UI
  })
})

})  #<-- end the shinyserver function
