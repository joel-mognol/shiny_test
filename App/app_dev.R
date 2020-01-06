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
    column(6,actionButton("go", "Afficher les statistiques"))
  ),
  fluidRow(
    column(6,plotOutput("graph1"))
  ),
  fluidRow(
    column(6,DTOutput('tbl1'))
  )
)
# randomVals <- eventReactive(input$go, {runif(input$n)})

#  choix <- reactive({
#    req(input$prenom)
#    filter(data,preusuel==toupper(input$prenom))
#   })

server = function(input, output) {
  choix <- eventReactive(input$go,{
    req(input$prenom)
    filter(data,preusuel==toupper(input$prenom))#à remplacer par un bloc de code issu de explorations.R
    #Comment exécuter un bloc de code et affecter un résultat à choix en même temps
    })
  prenom_choisi <- eventReactive(input$go,{
    req(input$prenom)
    input$prenom})
  output$tbl1 <- renderDT(choix(), options = list(lengthChange = FALSE)  )
  output$graph1 <- renderPlot({
    barplot(choix()$nombre,names.arg = choix()$annais,border = NA,
            main = paste("Occurence du prénom",toupper(prenom_choisi())), xlab = "Années",
            ylab = "Nombre",las=2, cex.names=0.8)
    })
}

shinyApp(ui,server)