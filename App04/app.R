#Exemple issu de https://rstudio.github.io/DT/shiny.html
library(shiny)
library(DT)

ui = fluidPage(
  fluidRow(
    column(6,DTOutput('tbl1')),
    column(6,DTOutput('tbl2'))
    ),
  fluidRow(
    column(6,plotOutput("orionPlot")),
    column(6,plotOutput("isisPlot"))
  )
)  
server = function(input, output) {
  output$tbl1 = renderDT(
    orions, options = list(lengthChange = FALSE)
  )
  output$tbl2 = renderDT(
    isiss, options = list(lengthChange = FALSE)
  )
  output$orionPlot <- renderPlot({
    barplot(orions$nombre,names.arg = orions$annais,border = NA, main = "Occurence du prénom ORION depuis 1968", xlab = "Années", ylab = "Nombre", las=2, cex.names=0.8)
  })
  output$isisPlot <- renderPlot({
    barplot(isiss$nombre,names.arg = isiss$annais,border = NA, main = "Occurence du prénom ISIS depuis 1968", xlab = "Années", ylab = "Nombre", las=2, cex.names=0.8)
  })
}
shinyApp(ui,server)