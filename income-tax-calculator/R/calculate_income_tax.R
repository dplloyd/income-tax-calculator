#' Calculate income tax paid on an annual income
#'
#' calculate_income_tax returns a dataframe with the annual income supplied,
#' the income after tax is paid, the tax paid, NI contributions and pension contributions
#'
#' @param annual_income Test
#' @param tax_brackets Test
#' @param rates Test
#' @param ... Test
#'
#' @return
#' @export
#'
#' @examples
calculate_income_tax <-
  function(annual_income,
           tax_brackets,
           rates,
           pension = NULL,
           ni_brackets = NULL,
           ni_rates = NULL,
           marriage = NULL) {
    # optargs <- list(...)
    
    
    # Define optional arguemnts if not passed
    if (is.null(pension)) {
      pension <- 0
    }
    if (is.null(ni_brackets)) {
      ni_brackets <- c(12576, 50268, Inf)
    }
    if (is.null(ni_rates)) {
      ni_rates <- c(0, 0.12, 0.02)
    }
    if (is.null(marriage)) {
      marriage <- FALSE
    }
    
    
    # Adjust tax free allowance -----------------------------------------------
    
    # Adjustment 1: If marriage allowance present, then increase personal allowance by 1260
    #
    if (marriage == TRUE) {
      tax_brackets[1] <- tax_brackets[1] + 1260
    }
    
    
    # Adjustment 2: those earning more than £100,000 will see their Personal Allowance reduced by £1 for every £2 earned over £100,000.
    personal_adjustment_100k <- max(c(0, (annual_income - 100000) / 2))
    tax_brackets[1] <- tax_brackets[1] + personal_adjustment_100k
    
    
    # National Insurance ------------------------------------------------------
    
    
    ni_contribution <- sum(diff(c(0, pmin(
      annual_income, ni_brackets
    ))) * ni_rates)
    
    
    
    # Pension contributions -------------------------------------------------
    pension_contribution <- annual_income * pension
    
    annual_income_net_pension <-
      annual_income - pension_contribution
    
    
    # Income tax --------------------------------------------------------------
    
    
    income_tax <-  sum(diff(c(
      0, pmin(annual_income_net_pension, tax_brackets)
    )) * rates)
    
    
    # Arranging outputs -------------------------------------------------------
    income_after_tax <-
      annual_income - pension_contribution - ni_contribution  - income_tax
    
    output <-
      data.frame(
        annual_income,
        pension_contribution,
        ni_contribution,
        income_tax,
        income_after_tax
      )
    
    return(output)
    
  }
