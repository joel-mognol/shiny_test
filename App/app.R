library(shiny)
library(DT)

data <- readRDS(file="../prenoms.Rda")

ui = fluidPage(
  titlePanel("Occurence des prénoms donnés à l'Etat civil français depuis 1900",
             windowTitle = "Shiny Test"),
  fluidRow(
    column(6,textInput('prenom', "Choix du prénom :",placeholder = "Ecrivez un prénom ici"))
  ),
  fluidRow(
    column(6,plotOutput("graph1"))
  ),
  fluidRow(
    column(6,DTOutput('tbl1'))
  )
)

server = function(input, output) {
    choix <- reactive({
      req(input$prenom)
      filter(data,preusuel==toupper(input$prenom))
      })
    output$tbl1 = renderDT(choix(), options = list(lengthChange = FALSE)  )
    output$graph1 <- renderPlot({
      barplot(choix()$nombre,names.arg = choix()$annais,border = NA,
              main = paste("Occurence du prénom",toupper(input$prenom)), xlab = "Années", ylab = "Nombre",
              las=2, cex.names=0.8)
    })
}

shinyApp(ui,server)