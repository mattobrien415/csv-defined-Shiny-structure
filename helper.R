# csv-defined Shiny structure


library("shiny")
library("ggplot2")
library("dplyr")
library('reshape2')
library('data.table')

options(warn = -1)

# Load up a dataframe to select ID's from.
# This Shiny was written to take in to consideration a date field as well. 
# Make sure your csv has both a column titled 'ID' and 'Date' along with the variables you want to plot,
# for example:
# ID, Date,   var1, var2,  var3, var4, var5
# 1,  1/1/11, 1,    20,    5,     50,   50
# 1,  1/1/11, 15,   3,    45,     88,  100
# 2,  1/1/13, 97,   16,    5,      5,    8
# 2,  1/1/14, 55,   15,   90,     75,   35
# 3,  1/1/15, 1,    76,   66,     22,    1


df_ID <- read.csv("IDs_to_examine.csv", stringsAsFactors=FALSE)
df_ID$Date <- as.character(df_ID$Date)

# As part of cleaning the df_ID dataframe, we must deal with the fact that Shiny won't fire if it encounters duplicates (e.g., ID 1 had 2 visits on the same day -- Shiny won't refresh) 
# We need to append a visit number (eg,  '(1)' ) to the end of the Date string to make the string unique.
# A quick way to do this is to create the enumeration using a data.table then append back to the df_ID.
dt_ID <- data.table(df_ID)
dt_ID[, .id := sequence(.N), by = "ID"]
df_ID$Date <- paste(df_ID$Date, '   (', dt_ID$.id, ')', sep='')

# chart_settings is a user-defined file that provides 3 things:
# 1) The variables you want to have access to
# 2) The x-axis labels you want to have on the ggplot
# 3) the category/tab name you want to create and which tab each of the variable is to be displayed on

# For example:
# variable  x_axis_labels   tab_name
# var1	    some_name_var1	tab1
# var2	    some_name_var2	tab1
# var3	    some_name_var3	tab2
# var4	    some_name_var4	tab3
# var5	    some_name_var5	tab3

# The headers on the csv must match the above EXACTLY.
# The column positions ARE FIXED and are accessed by index at various points.
# Disobey this template at your own peril!

chart_settings <- read.csv("chart_settings.csv", stringsAsFactors = FALSE, check.names=FALSE)

# We need to know unique tab names.
unique_tab_names <- unique(chart_settings[, 'tab_name'])

## number_of_tabs is useful to initialize the lapply in the server; the lapply will run and fill up each tab with the variables.
number_of_tabs <- length(unique_tab_names)

# We create a vector which we use later to apply the name to the tabs. Naturally, the tabs will appear in the same order as they appear on chart_settings csv.
# We make the first one blank because of a quirk in Shiny
tab_names <- c('', unique_tab_names)

# In a similar manner, we want to collect the y_axis_labs.
y_axis_labs <- c(chart_settings[, 'x_axis_labels'])

# Mext we create a list, where the key is the tab name. The value is the variables to go in that tab.
# This also is necessary for iterating through tabs and populating them.

list_of_vars_in_tabs <- as.list(unstack(chart_settings, chart_settings[, 1]~chart_settings[,3])[unique(chart_settings[,3])])

# Next, the key is the same as above but the value is the y-axis label.
list_of_yaxis_labels <- as.list(unstack(chart_settings, chart_settings[,2]~chart_settings[,3])[unique(chart_settings[,3])])

# Still organizing and extrating
vector_of_chosen_vars <- chart_settings[, 'variable']
number_of_chosen_vars <- length(vector_of_chosen_vars)

# We need to assign the correct plot to the correct tab

get_indices <- function(){
  num_vars <- seq_along(unlist(list_of_vars_in_tabs))
  alist = list()
  for (i in seq(number_of_tabs)){
    alist[[i]] <- num_vars[1:length(list_of_vars_in_tabs[[i]])]
    to_remove <- c(seq(length(alist[[i]])))
    num_vars <- num_vars[-to_remove]
  }
  return(alist)
}

# Use the function here.
indices_list <- get_indices()

# Make a list of all the arguments you want to pass to the navbarPage function.
# Look in the UI and you will see a do.call which will create the number of tabs.
tabs <- list()

# We also need a list to hold our ggplots.
list_of_ggplots <- list()

# First element will be the title, empty in our case.
tabs[[1]] <- ""

# Populate the 'tabs' list with name for the tab, and the plot.
# What this means is that you will end up with a list of tabsPanels.
# Inside the tabPanels are plots which will be named 'plotn,' where n is the tab number.
for (i in 2:(number_of_tabs+1)){
  num_vars <- length(list_of_vars_in_tabs[[i-1]])
  tabs[[i]] <- tabPanel(
    tab_names[i],
    plotOutput(paste0("plot", i-1)
               )
  )}