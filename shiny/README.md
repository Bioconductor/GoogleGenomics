#Shiny demo

This small Shiny application demonstrates how to fetch and display
Read data from the Google Genomics API

You can run this straight from R with:
```
devtools::install_github("shiny", "rstudio")
library(shiny)
runGitHub("api-client-r", "googlegenomics", subdir = "shiny")
```