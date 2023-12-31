#
# App which calculates income tax, NI and pension contributions on an annual income.
#
#

library(shiny)
library(reactable)
library(tidyverse)
library(here)
library(gt)


fluidPage(# Application title
  titlePanel("Income tax calculator"),
  
  # Sidebar with a input fields
  sidebarLayout(
    sidebarPanel(
      selectInput("fin_year", "Financial year", c("2024-25", "2023-24")),
      numericInput(
        "annual_salary",
        "Enter your annual salary (£)",
        value = 35000,
        min = 0
      ),
      numericInput(
        "pension_contribution",
        "Enter your pension contribution percentage, expressed as a decimal value",
        value = 0.0565,
        min = 0,
        max = 1
      )
      
      
    ),
    # Show a plot of the generated distribution
    mainPanel(reactableOutput("taxTable"))
  ))
