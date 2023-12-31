#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#



function(input, output, session) {
  
  # There are a bunch of reactive variables which we'll likely use often
  # so define them outwith the main rendering functions. Note, these are now functions, and 
  # need to be accessed by adding () after them!
  nat_ins_selected <- reactive({nat_ins |> filter(year == input$fin_year)})
  income_tax_selected <- reactive({income_tax |> filter(year == input$fin_year)})
  tax_output <- reactive({
    calculate_income_tax(
      input$annual_salary,
      income_tax_selected()$brackets,
      income_tax_selected()$rates,
      pension = input$pension_contribution,
      ni_brackets = nat_ins_selected()$brackets,
      ni_rates = nat_ins_selected()$rates
    )})
  
  tax_output_time_period <- reactive({
    calculate_income_tax(
      input$annual_salary,
      income_tax_selected()$brackets,
      income_tax_selected()$rates,
      pension = input$pension_contribution,
      ni_brackets = nat_ins_selected()$brackets,
      ni_rates = nat_ins_selected()$rates
    ) |> 
      add_case(tax_output()/12) |> 
      rename(income = annual_income) |> 
      mutate(frequency = c("Annual","Monthly")) |> 
      select(frequency, everything())
      
    
    })
  
  tax_salary_range <- reactive({
    salaries <- seq(0, 150000, 5000)
    results <-  map_df(salaries, calculate_income_tax, income_tax_selected()$brackets,
                       income_tax_selected()$rates,
                       pension = input$pension_contribution,
                       ni_brackets = nat_ins_selected()$brackets,
                       ni_rates = nat_ins_selected()$rates) |> pivot_longer(pension_contribution:income_after_tax)
  })
  
  
  output$taxTable <- renderReactable({
  
      reactable::reactable(tax_output_time_period(),
                           columns = list(
                             frequency = colDef(name  = "Frequency"),
                             income = colDef(name = "Gross income", format = colFormat(separators = TRUE, digits = 0)),
                             pension_contribution = colDef(name = "Pension cont.", format = colFormat(separators = TRUE, digits = 0)),
                             ni_contribution = colDef(name = "NI cont.", format = colFormat(separators = TRUE, digits = 0)),
                             income_tax = colDef(name = "Income tax", format = colFormat(separators = TRUE, digits = 0)),
                             income_after_tax = colDef(name = "Net income", format = colFormat(separators = TRUE, digits = 0))
                             ))
                             
                           
  
  })
  
 output$stackedBarchart <- renderHighchart({
   hc <- tax_salary_range() %>% 
     hchart(
       'column', hcaes(x = 'annual_income', y = 'value', group = 'name'),
       stacking = "normal"
     ) |> 
     
   hc_yAxis(reversedStacks = FALSE) |> 
     
     hc_legend(
       align = "right",
       verticalAlign = "top",
       layout = "vertical",
       reversed = TRUE)
   
     
 })
  
   
}
