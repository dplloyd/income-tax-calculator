#
# App which calculates income tax, NI and pension contributions on an annual income.
#
#

library(shiny)
library(reactable)
library(tidyverse)
library(here)
library(gt)
library(highcharter)


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
    mainPanel(
      h2("Annual and monthly net salary, deductions and net take home pay"),
      h5(
        "For the input values entered in the sidebar, this table estimates your net take home pay, and the deduction components."
      ),
      reactableOutput("taxTable"),
      h2(
        "Annual salaries: Composition of gross pay due to income tax, NI contributions and pension"
      ),
      h5(
        "For illustrative purposes, a breakdown of annual deductions and take home pay for different annual salaries"
      ),
      highchartOutput("stackedBarchart")
    )
  ))
