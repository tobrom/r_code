
scrapeAndSaveDiData <- function() {
  

library(tidyverse)
library(rvest)
library(stringr)


url <- read_html("http://www.di.se/")

news <- url %>% 
  html_nodes("head") %>%
  html_text() %>%
  str_trim() %>%
  str_replace("\n", "") %>%
  str_replace_all("[\"]", "") 


newsOnly <- ifelse(str_sub(news, -5,-1) %in% c("i går", "sedan", "st nu") | 
                     !is.na(as.integer(str_sub(news, -1,-1))), 
                   str_trim(str_sub(news, 1,nchar(news)-13)), 
                   str_trim(news))

timeStamp <- ifelse(str_sub(news, -5,-1) %in% c("i går", "sedan", "st nu") | 
                      !is.na(as.integer(str_sub(news, -1,-1))), 
                    str_trim(str_sub(news, -12,-1)), NA)


df <- data.frame(news = newsOnly, time = timeStamp) %>%
  drop_na() #removes potential ads with no timestamps

df$publishDate <- ifelse(str_detect(df$time, "/"), as.Date(strptime(df$time, format = "%d/%m"), "%Y-%m-%d"), 
                         ifelse(str_sub(df$time, -5,-1) %in% c("sedan", "st nu"), Sys.Date(),
                                ifelse(str_sub(df$time, -5,-1) %in% c("i går"), Sys.Date()-1,
                                       ifelse(as.numeric(str_replace(df$time, ":", ".")) < as.numeric(format(Sys.time(), "%H.%M")), 
                                              Sys.Date(), Sys.Date()-1)))) 


class(df$publishDate) <- "Date"

timeStamp <- as.character(Sys.time())

df$timeStamp <- timeStamp



write.csv(df, paste0("DI Data/di_news_", str_replace_all(timeStamp, ":", "."), ".csv"), 
          row.names = F, 
          fileEncoding = "UTF-8")


}

#################









