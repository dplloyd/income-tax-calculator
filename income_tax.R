# I want to create a shiny app which will calculate income tax, NI contributions and pension contrinbutions on a employee salary.
#
#

library(tidyverse)
source("R/calculate_income_tax.R")

gross_salary <- 35000
time_period <- "annual"
scotland <- TRUE
tax_code <- "S1350M"
pension <- 0.0545


brackets <- c(12571, 14732, 25688, 43662, 125140, Inf)
rates <- c(0, 0.19, 0.20, 0.21, 0.41, 0.46)





salaries <- seq(10000, 120000, 5000)
results <-  map_df(salaries, calculate_income_tax, brackets, rates) |> pivot_longer( pension_contribution:income_tax)


ggplot(results, aes(annual_income, value , fill = name)) +
  geom_col()

library(highcharter)

results$salaries <- as.factor(results$salaries)

hc <- results %>% 
  hchart(
    'column', hcaes(x = 'annual_income', y = 'value', group = 'name'),
    stacking = "normal"
  )
hc
