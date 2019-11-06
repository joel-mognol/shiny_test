#Exemple issu de https://rstudio.github.io/DT/shiny.html
library(shiny)
library(DT)
#rm(data)
data <- readRDS(file="../prenoms.Rda")

ui = fluidPage(
  fluidRow(
    column(6,textInput('prenom', "Choix du prénom :",
                       placeholder = "EN MAJUSCULE")),
    column(6,verbatimTextOutput('txt1', placeholder = TRUE))
  ),
  fluidRow(
    column(6,DTOutput('tbl1')),
    column(6,plotOutput("graph1"))
  )
)  
server = function(input, output) {
  choix <- reactive(filter(data,preusuel==input$prenom))
  output$txt1 <- renderText(input$prenom)
  output$tbl1 = renderDT(
    choix(), options = list(lengthChange = FALSE)
  )
  output$graph1 <- renderPlot({
    barplot(choix()$nombre,names.arg = choix()$annais,border = NA, main = paste("Occurence du prénom",input$prenom), xlab = "Années", ylab = "Nombre", las=2, cex.names=0.8)
  })
}
shinyApp(ui,server)