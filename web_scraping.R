####rvest

library(tidyverse)
library(rvest)
library(stringr)


url <- read_html("http://www.di.se/")

news <- url %>% 
  html_nodes(".di_teaser__heading") %>%
  html_text() 

#html_tag() (the name of the tag), 
#html_text() (all text inside the tag), 
#html_attr() (contents of a single attribute) 
#html_attrs() (all attributes). 

#These are done after using html_nodes()

#Parse tables into data frames with html_table()


###Example 2

lego_movie <- html("http://www.imdb.com/title/tt1490017/")

rating <- lego_movie %>% 
  html_nodes("#titleCast .itemprop") %>%
  html_text() %>%
  as.numeric()
rating


html_name(rating)
html_text(rating) 
html_attr(rating) 
html_attrs(rating) 














