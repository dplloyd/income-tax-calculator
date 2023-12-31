source("R/calculate_income_tax.R")


# Hard code tax bands
income_tax <- data.frame(  year = "2024-25",
                           brackets  = c(12571, 14876, 25561, 43662, 75000, 125140, Inf),
                           rates  = c(0, 0.19, 0.20, 0.21, 0.42, 0.45 , 0.48))


income_tax <- dplyr::bind_rows(income_tax, data.frame(
  year = "2023-24",
  brackets  = c(12571, 14732, 25688, 43662, 125140, Inf),
  rates  = c(0, 0.19, 0.20, 0.21, 0.41, 0.46) ) )


# Hard code national insurance bands
nat_ins <- data.frame(year = "2023-24",
                       brackets = c(12576, 50268, Inf),
                       rates = c(0, 0.1, 0.02) )

nat_ins <- dplyr::bind_rows(nat_ins, data.frame(
  year = "2024-25",
  brackets = c(12576, 50268, Inf),
  rates = c(0, 0.1, 0.02) 
))