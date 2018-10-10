#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(mongolite)
library(jsonlite)
limit <- 10L




# Define UI for application for mongodb text search
ui <- fluidPage(
  
  # Application title
  titlePanel("Mongodb Data"),
  sidebarLayout(
    sidebarPanel(
      textInput("title_id", "Title text", "")
      
    ),
    
    
    
    # Show the mongodb text search output in the main panel
    mainPanel(
      dataTableOutput("mydata")
    ))
)


server <- function(input, output) {
  
  mon <- mongo(collection = "documents", db = "entitydocuments", url = "mongodb://localhost:27017" )

   titlesearchresult <- reactive({
 
       # Defining mongodb index
   
   mon$index(toJSON(list("title" = "text"), auto_unbox = TRUE))
     text <- input$title_id
   
   #text search output
   
   mon$find(toJSON(list("$text" = list("$search" = text)), auto_unbox = TRUE))
   
   
 })
  output$mydata <-renderDataTable({
    
    titlesearchresult()
    
  
  
  })
  
}
shinyApp(ui = ui, server = server)   
  



