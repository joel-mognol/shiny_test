library(shiny)
library(DT)
library(ggplot2)

data <- readRDS(file="../prenoms_l2.Rda")

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


server = function(input, output) {
  choix <- eventReactive(input$go,{
    req(input$prenom)
    filter(data,preusuel==toupper(input$prenom))
    })
  prenom_choisi <- eventReactive(input$go,{
    req(input$prenom)
    input$prenom})
  output$graph1 <-renderPlot(print(ggplot(
    data = choix(),
    mapping = aes(
      x = annais,
      y = ifelse(test = sexe == "1", yes = -nombre, no = nombre),
      fill = sexe)) +
    geom_col() +
    scale_fill_manual(values = c("#109CEF", "#EF109C"),labels=c("Hommes", "Femmes")) +
    theme(legend.position="bottom") +
    coord_flip() +
    scale_y_continuous(labels = abs, limits = max(choix()$nombre) * c(-1,1)) +
    labs(x="Année de naissance",y = "Nombre") +
    labs(title=paste("Répartition des personnes appelées",prenom_choisi()),
                     subtitle="Source : Insee d'après les déclarations à l'état civil français")
    )
    )
  output$tbl1 <- renderDT(choix(), options = list(lengthChange = FALSE)  )
}

shinyApp(ui,server)