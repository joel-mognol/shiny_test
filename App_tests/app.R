#espace de test des scripts trouvés en ligne
if (interactive()) {
  shinyApp(
    ui = basicPage(
      textInput("txt", "Enter the text to display below:"),
      verbatimTextOutput("default", placeholder = TRUE)
    ),
    server = function(input, output) {
      output$default <- renderText({ input$txt })
    }
  )
}