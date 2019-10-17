#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

### Only run this example in interactive R sessions
if (interactive()) {
  # table example
  shinyApp(
    ui = fluidPage(
      fluidRow(
        column(12,
               tableOutput('table')
        )
      )
    ),
    server = function(input, output) {
      output$table <- renderTable(orions)
    }
  )
  
  
  # DataTables example
  shinyApp(
    ui = fluidPage(
      fluidRow(
        column(12,
               dataTableOutput('table')
        )
      )
    ),
    server = function(input, output) {
      output$table <- renderDataTable(orions)
    }
  )
}