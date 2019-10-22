#Exemple issu de https://rstudio.github.io/DT/shiny.html
library(shiny)
library(DT)

ui = fluidPage(
  fluidRow(
    column(6,textInput('prenom', "Choix du prénom :",
                       placeholder = "EN MAJUSCULE")),
    column(6,verbatimTextOutput('txt1', placeholder = TRUE))
  ),
  fluidRow(
    column(6,DTOutput('tbl1')),
    column(6,plotOutput("orionPlot"))
  )
)  
server = function(input, output) {
  output$txt1 <- renderText(input$prenom)
  output$tbl1 = renderDT(
    orions, options = list(lengthChange = FALSE)
  )
    output$orionPlot <- renderPlot({
    barplot(orions$nombre,names.arg = orions$annais,border = NA, main = "Occurence du prénom ORION depuis 1968", xlab = "Années", ylab = "Nombre", las=2, cex.names=0.8)
  })
}
shinyApp(ui,server)