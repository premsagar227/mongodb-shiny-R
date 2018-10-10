library(shiny)
library(jsonlite)
library(mongolite)

ui <- fluidPage("Mongodb query",
                   sidebarLayout(
                     sidebarPanel(
                       selectInput(inputId = "doc_id", label = "DOCUMENT TYPE:", choices = c("PATENT" , "SCIENCE")) 
                     ),
                     mainPanel(
                       verbatimTextOutput(outputId = "text1"),
                       dataTableOutput(outputId = "qry_results")
                     )
                   ))



loadData <- function(qry){
  mong <- mongo(collection = "documents", db = "entitydocuments", url = "mongodb://localhost:27017")
  
  df <- mong$find(qry , limit = 10)
  return(df)
}


server <- function(input, output) {
  
  qryResults <- reactive({
    
    ## This bit responds to the user selection 
    ## which makes it 'reactive'
    doc_type <- list(doc_type = input$doc_id)
    
    qry <- paste0('{ "doc_type" : "',doc_type , '"}')
    
    df <- loadData(qry)
    return(df)
  })
  
  output$qry_results <- renderDataTable({
    qryResults()
  })
  
  output$text1 <- renderText(nrow(qryResults()))
  
}

# Run the application 
shinyApp(ui = ui, server = server)

