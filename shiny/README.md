#Shiny demo

This small Shiny application demonstrates how to fetch and display
Read data from the Google Genomics API

* You can run this straight from R with:
  ```
  devtools::install_github("shiny", "rstudio")
  library(shiny)
  runGitHub("api-client-r", "googlegenomics", subdir = "shiny")
  ```

  You'll need the same client ID and secret values that you used 
  in the parent project.

* Or, view the hosted version on shinyapps.io: 
  http://googlegenomics.shinyapps.io/reads

  Note: the hosted version is using hardcoded auth, because OAuth 
  won't work in that environment. (The validate lines are unfortunately 
  also disabled until the next version of Shiny is available)
