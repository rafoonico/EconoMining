library(shiny)
library(rvest)
library(magrittr)
library(tm)
library(wordcloud)
#------------------------------------------------------------------ web scraping 

url <- "https://www.econlib.org/library/Smith/smWN.html?chapter_num=8#book-reader"

indexes <- read_html(url) %>% html_nodes("li a") %>% html_text() ;indexes=indexes[11:47]

new <- vector("list",length = 37); new=names(indexes)
s <- html_session(url)

for(i in indexes[1:37]){
  page <- s %>% follow_link(i) %>% read_html()
  new[[i]] <- page %>% html_nodes(".book-reader-content p") %>% html_text() %>% paste(collapse="")
}

#------------------------------------------------------------------ wordcloud

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("Wordclouds from Adam Smith's 'An Inquiry into the Nature and Causes of the Wealth of Nations (1776)' "),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
         sliderInput("words",
                     "Number of words:",
                     min = 1,
                     max = 50,
                     value = 50),
         radioButtons(inputId="chapter",
                      "Choose a chapter:",
                      choices=c("Preface"                                                                                                                
                                ,"Editor's Introduction"                                                                                                  
                                ,"B.I, Introduction and Plan of the Work"                                                                                 
                                , "B.I, Ch.1, Of the Division of Labor"                                                                                    
                                , "B.I, Ch.2, Of the Principle which gives Occasion to the Division of Labour"                                             
                                , "B.I, Ch.3, That the Division of Labour is Limited by the Extent of the Market"                                          
                                , "B.I, Ch.4, Of the Origin and Use of Money"                                                                              
                                , "B.I, Ch.5, Of the Real and Nominal Price of Commodities"                                                                
                                , "B.I, Ch.6, Of the Component Parts of the Price of Commodities"                                                          
                                , "B.I, Ch.7, Of the Natural and Market Price of Commodities"                                                              
                                , "B.I, Ch.8, Of the Wages of Labour"                                                                                      
                                , "B.I, Ch.9, Of the Profits of Stock"                                                                                     
                                , "B.I, Ch.10, Of Wages and Profit in the Different Employments of Labour and Stock"                                       
                                , "B.I, Ch.11, Of the Rent of Land"                                                                                        
                                , "B.II, Introduction"                                                                                                     
                                , "B.II, Ch.1, Of the Division of Stock"                                                                                   
                                , "B.II, Ch.2, Of Money Considered as a particular Branch of the General Stock of the Society"                             
                                , "B.II, Ch.3, Of the Accumulation of Capital, or of Productive and Unproductive Labour"                                   
                                , "B.II, Ch.4, Of Stock Lent at Interest"                                                                                  
                                , "B.II, Ch.5, Of the Different Employment of Capitals"                                                                    
                                , "B.III, Ch.1, Of the Natural Progress of Opulence"                                                                       
                                , "B.III, Ch.2, Of the Discouragement of Agriculture in the Ancient State of Europe after the Fall of the Roman Empire"    
                                , "B.III, Ch.3, Of the Rise and Progress of Cities and Towns"                                                              
                                , "B.III, Ch.4, How the Commerce of the Towns Contributed to the Improvement of the Country"                               
                                , "B.IV, Introduction"                                                                                                     
                                , "B.IV, Ch.1, Of the Principle of the Commercial or Mercantile System"                                                    
                                , "B.IV, Ch.2, Of Restraints upon the Importation from Foreign Countries"                                                  
                                , "B.IV, Ch.3, Of the extraordinary Restraints upon the Importation of Goods of almost all Kinds"                          
                                , "B.IV, Ch.4, Of Drawbacks"                                                                                               
                                , "B.IV, Ch.5, Of Bounties"                                                                                                
                                , "B.IV, Ch.6, Of Treaties of Commerce"                                                                                    
                                , "B.IV, Ch.7, Of Colonies"                                                                                                
                                , "B.IV, Ch.8, Conclusion of the Mercantile System"                                                                        
                                , "B.IV, Ch.9, Of the Agricultural Systems, or of those Systems of Political Oeconomy, which Represent the Produce of Land"
                                , "B.V, Ch.1, Of the Expences of the Sovereign or Commonwealth"                                                            
                                , "B.V, Ch.2, Of the Sources of the General or Public Revenue of the Society"                                              
                                , "B.V, Ch.3, Of Public Debts")
                      , selected="B.I, Ch.1, Of the Division of Labor")
         
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
         plotOutput("wordcloud", width = "100%", height = "800px")
      )
   )
   
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
   output$wordcloud <- renderPlot({
     
     abstracts <- new[[input$chapter]]
     
     abs_source <- VectorSource(abstracts)
     abs_corpus <- Corpus(abs_source) %>% tm_map(content_transformer(tolower)) %>% tm_map(removePunctuation) %>% tm_map(stripWhitespace) %>% tm_map(removeWords, stopwords("english"))
     
     dtm <- DocumentTermMatrix(abs_corpus)
     dtm2 <- as.matrix(dtm)
     
     frequency <- colSums(dtm2) %>% sort(decreasing = TRUE)
     words <- names(frequency)
     colfunc <- colorRampPalette(c( "orange","red"))
     wordcloud(words[0:input$words], frequency[0:input$words],scale=c(8,.25), random.order = FALSE, colors=colfunc(input$words))
     
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

