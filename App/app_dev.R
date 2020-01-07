library(shiny)
library(DT)
library(ggplot2)

data <- readRDS(file="../prenoms_l2.Rda")

ui = fluidPage(
  titlePanel("Occurence des prénoms donnés à l'Etat civil français depuis 1900",
             windowTitle = "Shiny Test"),
  fluidRow(
    column(3,textInput('prenom', label = NULL,placeholder = "Ecrivez un prénom ici")),
    column(3,actionButton("go", "Afficher les statistiques"))
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
  choixw <- reactive(choix() %>%
    pivot_wider(id_cols = c(preusuel,annais),
                names_from = sexe,
                names_prefix = "sex_",
                values_from = nombre) %>%
      rename("Année" = annais,Hommes=sex_1,Femmes=sex_2) %>%
      select(-preusuel)
    )
  output$graph1 <-renderPlot(ggplot(
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
    labs(title=paste("Répartition des personnes appelées",toupper(isolate(input$prenom))),
                     subtitle="Source : Insee d'après les déclarations à l'état civil français")
    
    )

  output$tbl1 <- renderDT({ 
    dat <- datatable(choixw(),
                     options = list(paging=FALSE, searching = FALSE, info = FALSE),
                     rownames = FALSE) %>%
      formatStyle('Hommes',  color = "#109CEF") %>%
      formatStyle('Femmes',  color = "#EF109C")
    return(dat)
  })
}

shinyApp(ui,server)