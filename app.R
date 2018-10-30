
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
  titlePanel("Mongodb text search Data"),
  
  sidebarLayout(
    
    sidebarPanel(
      textInput("query_id", "Title text",""),
      
      selectInput("doc_id", "document", choices = c("PATENT", "SCIENCE"))
      
      
    ),
    
    
    
    # Show the mongodb text search output in the main panel
    mainPanel(
      dataTableOutput("mydata")
    ))
)


server <- function(input, output) {
  
  mdt <- mongo(collection = "data", db = "datadocuments", url = "mongodb://localhost:27017" )
  
  titletext <- reactive({
    
    
   mdt$index(toJSON(list("title" = "text"), auto_unbox = TRUE))
    
    q <- paste0('[{ "$match" : { "$text" : { "$search" :"',input$query_id,'" } } },

{"$match" : {"doc_type": "',input$doc_id , '"} },

 { "$group" : 

{"_id" :  {
"player_name" : "$player_name" }, 

 "number_records" : 
{ "$sum" : 1}
             }
                },

{"$sort":{"number_records" : -1}},

{"$limit" : 10}
   
   ]')
    
  
    jsonlite::validate(q)
    query <- mdt$aggregate(q)
    
    
    })
  output$mydata <-renderDataTable({
    
    titletext()
    
  })
  
}
shinyApp(ui = ui, server = server)   




