
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(nlme)
library(MultiEqOptimizer)
library(corrplot)
library(plotly)

shinyUI(fluidPage(

  # Application title
  titlePanel("Discrete Choice Experiment Planner"),
    # Show a plot of the generated distribution
  tabsetPanel(  
  tabPanel("Design Basics",
      
      #Numeric input that defines the number of basic variables
      numericInput(inputId = "varnums",
                   label = "Define the Number of Variables:",
                   value = 1,
                   min = 1),
      
      h3("Define Input Variable Characteristics"),
      # uiOutput("ui_varparams"),
      column(2,uiOutput("ui_dropdowns")),
      column(3,uiOutput("ui_varnames")),
      column(3,uiOutput("ui_varlevs")),
      column(2,uiOutput("ui_varmin")),
      column(2,uiOutput("ui_varmax")),
      
      hr(),
      h3("Specify the Models"),
      
      #Numeric input that defines the number of basic variables
      numericInput(inputId = "modelnums",
                   label = "Define the Number of Different Models to Use:",
                   value = 1,
                   min = 1),
      
      column(4,uiOutput("ui_modelnames")),
      column(4,uiOutput("ui_modelformulas")),
      column(4,uiOutput("ui_modelweights")),
      
      hr(),
      
      h3("Estimate Effect Size for Each Model"),
      
      uiOutput("ui_modeleffects")
      
    ),
  tabPanel("Single Design Optimization",
           
           #Sidebar for optimization controls
           sidebarPanel(
             
             #Options for Basic Model Creation
             h3("Basic Model Creation"),
             
             #Specify the number of model points
             numericInput(inputId = "modelquestions", label = "Number of Questions Per Survey", value = 1, min = 1),
             
             #Specify the number of alternatives per question
             numericInput(inputId = "alternatives", label = "Number of Choices Per Question", value = 2, min = 1),
             
             #Specify whether an opt-out should be included
             checkboxInput(inputId = "optout", label = "Include Opt-Out Alternative (i.e. 'None of the Above')", value = FALSE),
             
             #Specify number of blocks
             numericInput(inputId = "blocks", label = "Number of Different Surveys", value = 1, min = 1),
           
             #Specify model search procedure. Add Gibbs later once it has been implemented
             selectInput(inputId = "searchstrat", label = "Model Searching Strategy", choices = c("Federov", "Gibbs"), selected = "Federov"),
             
             #Specify number of random starts
             numericInput(inputId = "randomstarts", label = "Number of Random Starts to Find Design", value = 1, min = 1),
             
             #Action button to run design
             actionButton(inputId = "createsingledesignbutton", label = "Create Design"),
             
             
#              #Options for searching across several design sizes
#              
#              h3("Search Across Different Model Sizes"),
#              
#              #Specify the number of model points
#              numericInput(inputId = "minmodelquestions", label = "Minimum Number of Questions Per Survey", value = 1, min = 1),
#              numericInput(inputId = "maxmodelquestions", label = "Maximum Number of Questions Per Survey", value = 2, min = 1),
#              
#              #Specify the number of alternatives per question
#              numericInput(inputId = "minalternatives", label = "Minimum Number of Choices Per Question", value = 2, min = 1),
#              
#              #Specify the number of alternatives per question
#              numericInput(inputId = "maxalternatives", label = "Maximum Number of Choices Per Question", value = 2, min = 1),
#              
#              #Action button to run design
#              actionButton(inputId = "searchdesignsbutton", label = "Search for Designs"),
             
             #Options for Advanced Model Creation
             h3("Advanced Options (May Leave Unchanged)"),
             
             #Specify number of random starts
             numericInput(inputId = "randomstartsbaseline", label = "Number of Random Starts to find Optimal Reference Designs", value = 3, min = 1),
             
             #Specify tolerance for reference design optimization
             numericInput(inputId = "tolerancebaseline", label = "Optimizer Tolerance for Optimal Reference Designs", value = 0.1),

             #Specify tolerance for joint model optimization
             numericInput(inputId = "tolerance", label = "Optimizer Tolerance for Design Optimization", value = 0.001)
             
           ),
           
           #Main panel to contain design outputs
           mainPanel(
             
             
             
             #Display correlation plot selector of variables for each model
             uiOutput("ui_corrplotselect"),
             
             #Display correlation plot
             plotOutput("out_corrplot"),
             
             #Display model efficiencies
             hr(),
             h3("Model Diagnostics and Efficiencies"),
             textOutput("out_diagnostics"),
             tableOutput("out_formuladetails"),
             
             #Display power and sample size table
             hr(),
             h3("Power and Required Sample Sizes"),
             tableOutput("out_samplesizesingle"),
             
             #Display final model matrix
             hr(),
             h3("Design Matrix"),
             tableOutput("out_modelmatrix")
             
           )
           
  ),
  tabPanel("Multiple Design Search",
           
           #Sidebar for optimization controls
           sidebarPanel(
             
#              #Options for Basic Model Creation
#              h3("Basic Model Creation"),
#              
#              #Specify the number of model points
#              numericInput(inputId = "modelquestions", label = "Number of Questions Per Survey", value = 1, min = 1),
#              
#              #Specify the number of alternatives per question
#              numericInput(inputId = "alternatives", label = "Number of Choices Per Question", value = 2, min = 1),
#              
#              #Specify whether an opt-out should be included
#              checkboxInput(inputId = "optout", label = "Include Opt-Out Alternative (i.e. 'None of the Above')", value = FALSE),
#              
#              #Specify number of blocks
#              numericInput(inputId = "blocks", label = "Number of Different Surveys", value = 1, min = 1),
#              
#              #Specify model search procedure. Add Gibbs later once it has been implemented
#              selectInput(inputId = "searchstrat", label = "Model Searching Strategy", choices = c("Federov"), selected = "Federov"),
#              
#              #Specify number of random starts
#              numericInput(inputId = "randomstarts", label = "Number of Random Starts to Find Design", value = 1, min = 1),
#              
#              #Action button to run design
#              actionButton(inputId = "createsingledesignbutton", label = "Create Design"),
             
             
             #Options for searching across several design sizes
             
             h3("Search Across Different Model Sizes"),
             
             #Specify the number of model points
#              numericInput(inputId = "minmodelquestions", label = "Minimum Number of Questions Per Survey", value = 1, min = 1),
#              numericInput(inputId = "maxmodelquestions", label = "Maximum Number of Questions Per Survey", value = 2, min = 1),
             
             textInput(inputId = paste0("questionnumlist"), label = "List of Number of Questions Per Survey. Separate Multiple Values With a Comma and Space"),
             
             #Specify the number of alternatives per question
             # numericInput(inputId = "minalternatives", label = "Minimum Number of Choices Per Question", value = 2, min = 1),
             
             #Specify the number of alternatives per question
             # numericInput(inputId = "maxalternatives", label = "Maximum Number of Choices Per Question", value = 2, min = 1),
             
             textInput(inputId = paste0("altnumlist"), label = "List of Number of Choices Per Question. Separate Multiple Values With a Comma and Space"),
             
             #Specify whether an opt-out should be included
             checkboxInput(inputId = "optoutmulti", label = "Include Opt-Out Alternative (i.e. 'None of the Above')", value = FALSE),
             
             #Specify number of blocks
             numericInput(inputId = "blocksmulti", label = "Number of Different Surveys", value = 1, min = 1),
             
             #Specify model search procedure. Add Gibbs later once it has been implemented
             selectInput(inputId = "searchstratmulti", label = "Model Searching Strategy", choices = c("Federov", "Gibbs"), selected = "Federov"),
             
             #Specify number of random starts
             numericInput(inputId = "randomstartsmulti", label = "Number of Random Starts to Find Design", value = 1, min = 1),
             
             #Action button to run design
             actionButton(inputId = "searchdesignsbutton", label = "Search for Designs"),
             
             #Options for Advanced Model Creation
             h3("Advanced Options (May Leave Unchanged)"),
             
             #Specify number of random starts
             numericInput(inputId = "randomstartsbaseline", label = "Number of Random Starts to find Optimal Reference Designs", value = 3, min = 1),
             
             #Specify tolerance for reference design optimization
             numericInput(inputId = "tolerancebaseline", label = "Optimizer Tolerance for Optimal Reference Designs", value = 0.1),
             
             #Specify tolerance for joint model optimization
             numericInput(inputId = "tolerance", label = "Optimizer Tolerance for Design Optimization", value = 0.001)
             
           ),
           
           #Main panel to contain design outputs
           mainPanel(
             
             #Display correlation plot selector of variables for each model
             uiOutput("ui_effplotselect"),
             
             #Display model efficiency plot
             hr(),
             h3("Model Efficiency Plot"),
             plotlyOutput("out_effcontour_multi", height = "600px"),
             
             #Display correlation plot number of alternatives selector
             uiOutput("ui_corrmultiplotalt"),
             
             #Display correlation plot based on selected formula and number of alternatives
             h3("Correlation of Variables"),
             plotlyOutput("out_effcorr_multi", height = "600px"),
             
             #Display number of required samples based on selected formula and number of alternatives
             h3("Required Sample Sizes to Detect Specified Difference"),
             plotlyOutput("out_samplesize_multi", height = "600px"),
             
             #Display model efficiency table
             hr(),
             h3("Model Efficiencies"),
             tableOutput("out_formuladetails_multi")
             
  )
  )
)))
