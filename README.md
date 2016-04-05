# a csv defined Shiny structure

This project allows you to use 2 csvs (containing IDs, variables, names, and values) to automatically generate a Shiny structure that you can further customize.

Use a csv ('chart_settings.csv') in a form similar to this:  

| variable  | x_axis_labels | tab_name |
| --------- |:-------------:| --------:|
| var1 | some_name_var1 | tab1 |
| var2 | some_name_var2 | tab1 |
| var3 | some_name_var3 | tab2 |
| var4 | some_name_var4 | tab3 |
| var5 | some_name_var5 | tab3 |
  
is used along with a csv containing variables and values ('IDs_to_examine.csv'): 

| ID  | Date   | var1 | var2 | var3 | var4 | var5 |
| --- |:------:|:----:|:----:|:----:|:----:|:----:|
| 1   | 1/1/11 | 1    |   20 |   5  |  50  |  50  |
| 1   | 1/1/11 | 15   |    3 |  45  |  88  | 100  | 
| 2   | 1/1/13 | 97   |   16 |   5  |   5  |   8  |
| 2   | 1/1/14 | 55   |   15 |  90  |  75  |  35  |
| 3   | 1/1/15 | 1    |   76 |  66  |  22  |   1  |
 
...to create a Shiny with any number of tabs; in this case, 3 ('tab1' to 'tab3').  

Each tab contains one ggplot, featuring the variables; in this case 'var1' to 'var5'.

Click [here](https://mattobriendotme.shinyapps.io/csv-defined-Shiny-structure/) to see it in action.  

---
Examine the screenshot and map trace each element back to the appropriate csv:  

![alt text][logo]

[logo]: https://github.com/mobbSF/csv-defined-Shiny-structure/blob/master/screenshot.png?raw=true "Logo Title Text 2"