#install.packages(c("rvest","magrittr","tm","wordcloud"))

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

#"..."

#------------------------------------------------------------------ wordcloud

abstracts <- new[[15]]

abs_source <- VectorSource(abstracts)
abs_corpus <- Corpus(abs_source) %>% tm_map(content_transformer(tolower)) %>% tm_map(removePunctuation) %>% tm_map(stripWhitespace) %>% tm_map(removeWords, stopwords("english"))

dtm <- DocumentTermMatrix(abs_corpus)
dtm2 <- as.matrix(dtm)

frequency <- colSums(dtm2) %>% sort(decreasing = TRUE)
words <- names(frequency)
colfunc <- colorRampPalette(c( "orange","red"))
wordcloud(words[0:50], frequency[0:50],scale=c(3,.6), random.order = FALSE, colors=colfunc(50))
