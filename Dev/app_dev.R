#Fichier de développement conservé pour mémoire.
#Les chemins ayant pu changer il est susceptible de ne plus fonctionner.
library(shiny)
library(DT)
library(ggplot2)

data <- readRDS(file="prenoms_w.Rda")

ui = fluidPage(
  titlePanel("Occurence des prénoms donnés à l'Etat civil français depuis 1900",
             windowTitle = "Shiny Test"),
  fluidRow(
    column(3,textInput('prenom', label = NULL, placeholder = "Ecrivez un prénom ici")),
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
  choixw <- eventReactive(input$go, {
    req(input$prenom)
    filter(data, preusuel==toupper(input$prenom)) %>%
      select(-preusuel)
    }
    )
  choixl <- reactive(choixw() %>%
                        pivot_longer(cols = c(sex_1,sex_2),
                                     names_to = "sexe",
                                     values_to = "nombre") %>%
                        select(annais,sexe,nombre)
    )
  output$graph1 <-renderPlot(ggplot(
    data = choixl(),
    mapping = aes(
      x = annais,
      y = ifelse(test = sexe == "sex_1", yes = -nombre, no = nombre),
      fill = sexe)) +
    geom_col() +
    scale_fill_manual(values = c("#109CEF", "#EF109C"),labels=c("Hommes", "Femmes")) +
    theme(legend.position="bottom") +
    coord_flip() +
    scale_y_continuous(labels = abs, limits = max(choixl()$nombre) * c(-1,1)) +
    labs(x="Année de naissance",y = "Nombre") +
    labs(title=paste("Répartition des personnes appelées",toupper(isolate(input$prenom))),
                     subtitle="Source : Insee d'après les déclarations à l'état civil français")
    
    )

  output$tbl1 <- renderDT({ 
    dat <- datatable(choixw(),
                     options = list(paging=FALSE,
                                    searching = FALSE,
                                    info = FALSE),
                     rownames = FALSE,
                     colnames = c('Année', 'Hommes', 'Femmes')) %>%
      formatStyle('sex_1',  color = "#109CEF") %>%
      formatStyle('sex_2',  color = "#EF109C")
    return(dat)
  })
}

shinyApp(ui,server)