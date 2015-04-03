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


## To re-deploy the shiny app

Just once, follow the
[shinyapps.io instructions](http://shiny.rstudio.com/articles/shinyapps.html)
for getting your environment set up. From then on:

* Modify `ui.R` to comment out the Client ID and secret inputs.
* Modify `server.R` to comment out `google_token`
* Change the search reads request to use an API key rather than OAuth
  (OAuth doesn't work on shinyapps.io):
  ```
  res <- POST(paste(endpoint, 'reads/search', sep=''),
    body=toJSON(body, auto_unbox=TRUE), query=list(key=API_KEY),
    add_headers('Content-Type'='application/json'))
  ```
* Test that the new authentication mode works:
  ```
  library(shinyapps)
  library(shiny)
  runApp("path/to/api-client-r/shiny")
  ```
* And when everything is final, deploy it:
  ```
  deployApp("path/to/api-client-r/shiny", "reads")
  ```