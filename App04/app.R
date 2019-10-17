#Exemple issu de https://rstudio.github.io/DT/shiny.html
library(shiny)
library(DT)

ui = fluidPage(
  fluidRow(
    column(6,DTOutput('tbl1')),
    column(6,DTOutput('tbl2'))
    )
)  
server = function(input, output) {
  output$tbl1 = renderDT(
    orions, options = list(lengthChange = FALSE)
  )
  output$tbl2 = renderDT(
    isiss, options = list(lengthChange = FALSE)
  )
}
shinyApp(ui,server)