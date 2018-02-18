library(tidyverse)
library(rvest)
library(stringr)
library(purrr)
library(tm)
library(wordcloud)
library(markovchain)

url <- read_html("http://www.di.se/")

articleRefs <- url %>% 
  html_nodes("article a") %>%
  html_attr("href")


newsOnly <- articleRefs[str_detect(articleRefs, "nyheter")] %>% 
  na.exclude() %>% 
  paste()

  
###Function to get article text

getArticles <- function(x) {

url <- read_html(paste0("http://www.di.se", x))

newsArticle <- url %>% 
  html_nodes("section.di_article-body") %>%
  html_text() %>%
  str_replace_all("\n", "") %>%
  str_replace_all("  ", " ") %>%
  str_replace_all("[\"]", "") %>%
  str_trim()

return(newsArticle)

}


###Extracting all news articles
articlesText <- newsOnly %>%
  map(getArticles) %>%
  map(function(x) {iconv(x, from = "UTF-8", to = "latin1")})
  

###Starting the text analysis

bagWords <- Corpus(VectorSource(articlesText)) %>%
  tm_map(content_transformer(tolower)) %>%                            
  tm_map(removePunctuation) %>%                                         
  tm_map(removeNumbers) %>%
  tm_map(removeWords, iconv(stopwords("sv"), from = "UTF-8", to = "latin1")) %>%
  TermDocumentMatrix(control = list(minWordLength = 1)) %>%
  as.matrix()

###Counting and sorting top words 

termFreq <- sort(apply(bagWords, 1, sum), decreasing = T)

###Creating the clous with top words

wordcloud(names(termFreq), 
          termFreq, 
          scale = c(4,0.5),
          min.freq = 10, 
          max.words= 30,
          colors=brewer.pal(8, "Dark2"))

####

wordFrame <- data.frame(keyword = names(termFreq), 
                        count = termFreq)


ggplot(head(wordFrame, 30), aes(x = reorder(keyword, -count), y = count, fill = keyword)) + 
  geom_bar(stat = "identity") + 
  labs(x  = "", y = "Word Frequenzy") +
  theme(axis.text.x = element_text(angle = 90),
        plot.background = element_blank(),
        panel.background = element_blank(),
        legend.position = "none")
 


#####Markov Chain Example

###Preparing the Data
wordVector <- articlesText %>%
  str_replace_all("[[:punct:]]", "") %>%
  str_replace_all("  ", " ") %>%
  str_split(" ") %>%
  unlist() %>%
  subset(!str_detect(., "[[:space:]]")) %>%
  subset(str_count(.) > 0) 
  
###Fittign the markov chain
mcFit <- markovchainFit(data = wordVector)

###Function for generating text
createSentence <- function(startWord, nWords) {
  
  chain <- paste(markovchainSequence(n = nWords, markovchain = mcFit$estimate, t0 = paste(startWord)), collapse = ' ')
  
  paste(startWord, chain)
  
}

createSentence("kronor", 30)









