# Copyright 2014 Google Inc. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
library(shiny)

shinyUI(fluidPage(

  titlePanel("Google Genomics Read Viewer"),

  sidebarLayout(

    sidebarPanel(
      textInput('clientId', label = 'Client ID'),
      textInput('clientSecret', label = 'Client Secret'),
      textInput('readsetId', label = 'Readset ID', value = 'CJDmkYn8ChCh4IH4hOf4gacB'),
      textInput('chr', label = 'Sequence name', value = '19'),
      numericInput('position', label = 'Position', value = '29564500'),
      div(a(href = "http://github.com/googlegenomics/api-client-r",
          "http://github.com/googlegenomics/api-client-r"))
    ),

    mainPanel(
      plotOutput('plot')
    )
  )
))