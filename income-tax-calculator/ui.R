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
      p("Enter some basic information about your annual income and deductions:"),
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
      ),
      p("Note, this tool assumes you have a basic tax free allowance, and also applies the reduction in National Insurance announced for 2023-24, which comes into effect from 6th Jan 2024."),
      
      
      
    ),
    # Show a plot of the generated distribution
    mainPanel(
      h2("Annual and monthly net salary, deductions and net take home pay"),
      h5(
        "For the input values entered in the sidebar, these tables estimates your net take home pay, and the deduction components depending on location."
      ),
      h4("Scotland"),
      reactableOutput("taxTable"),
      div(),
      h4("England, Wales and Northern Ireland (rUK)"),
      reactableOutput("taxTable_rUK"),
      h2(
        "Scottish annual salaries: Composition of gross pay due to income tax, NI contributions and pension"
      ),
      h5(
        "For illustrative purposes, a breakdown of annual deductions and take home pay for different annual salaries in Scotland"
      ),
      highchartOutput("stackedBarchart")
    )
  ))
