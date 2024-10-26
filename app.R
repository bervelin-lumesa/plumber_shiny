library(shiny)
library(bslib)
library(httr)

ui <- page_sidebar(
  theme = bs_theme(version = 5),
  title = tags$a(href = "", tags$image(src = "fdtk.png", height = "100px")),
  sidebar = sidebar(
    title = "Paramètres",
    width = "25%",
    
    numericInput(inputId = "sl", label = "Sepal Length", min = 0, max = 10, value = 2.5, step = 0.5),
    numericInput(inputId = "sw", label = "Sepal Width", min = 0, max = 10, value = 2.5, step = 0.5),
    numericInput(inputId = "pl", label = "Petal Length", min = 0, max = 10, value = 2.5, step = 0.5),
    numericInput(inputId = "pw", label = "Petal Width", min = 0, max = 10, value = 2.5, step = 0.5),
    
    actionButton(inputId = "run", label = "Prédire"),
    actionButton(inputId = "about", label = "Apropos de l'appli")
  ),
  "Résultats",
  layout_columns(
    row_heights = c(1, 5),
    col_widths = c(12,12),
    value_box(
      title = "Prédiction",
      value = textOutput("pred"),
      theme = "primary"
    ),
    
    #card(
      imageOutput("img")
    #  )
  )
)

server <- function(input, output) {
  
  observeEvent(input$run, {
    output$pred <- renderText({
      # Use isolate to prevent automatic reactivity until the button is clicked
      base_url <- "http://127.0.1.1:8000/species-predict"
      arg <- list(
        Sepal_Length = isolate(input$sl), 
        Sepal_Width  = isolate(input$sw), 
        Petal_Length = isolate(input$pl), 
        Petal_Width  = isolate(input$pw)
      )
      
      query_url <- modify_url(url = base_url, query = arg)
      resp <- POST(query_url)
      
      resp_raw <- content(resp, as = "text", encoding = "utf-8")
      
      response <- jsonlite::fromJSON(resp_raw)
      
      return(paste0("L'espèce prédite est ", response))
    })
  })
  
  output$img <- renderImage({
    list(src = "www/flowers.jpg",
         width = "100%",
         height = "160%",
         alt = "Bervelin")
  }, deleteFile = F)
  
  observeEvent(input$about, {
    showModal(modalDialog(
      title = "À propos",
      "Cette application utilise un modèle de forêts aléatoires déployé avec l'API",
      a(href = "https://rplumber.io", target = "_blank", "plumber"), ".",
      "À chaque prédiction, l'application envoie une requête à l'API qui retourne une réponse sous forme de chaîne de caractères contenant la classe prédite (setosa, virginica ou versicolor)", hr(),
      # Insertion de la vidéo
      #tags$iframe(
      #  width = "100%",
      #  height = "215",
      #  src = "9convert.com - Data Analytics Background 1_360P.mp4",
      #  frameborder = "0",
      #  allow = "accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture",
      #  allowfullscreen = NA
      #), hr(),
      "Bervelin Lumesa", "Statisticien/Data Scientist", br(),
      a(href = "https://www.linkedin.com/in/bervelin-lumesa/", target = "_blank", "Profil Linkedin"), br(),
      a(href = "https://bervelin-lumesa.netlify.app", target = "_blank", "Site web")
    ))
  })
  
}

shinyApp(ui, server)
