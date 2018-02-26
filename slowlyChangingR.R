library(tidyverse)

#The first part is to be considered as already existing
#########################################################

activeNews <- data_frame(news = c("allan", "gerd", "leffa", "kriss"),
                     from = as.Date("2014-01-01"),
                     to = as.Date("3999-12-30"),
                     rank = c(1, rep(2, 2), 3))

#########################################################
#Data tp be processed

raw <- list(a = data_frame(news = c("allan", "bert", "challe", "david"),
                           time = as.Date("2015-01-01"),
                           rank = c(1, rep(2, 2), 3)),
            a = data_frame(news = c("ergo", "allan", "challe", "david"),
                           time = as.Date("2016-01-01"),
                           rank = c(1, rep(2, 2), 3)),
            a = data_frame(news = c("ergo", "frans", "allan", "challe"),
                           time = as.Date("2017-01-01"),
                           rank = c(1, rep(2, 2), 3)))

#########################################################

openTime = as.Date("3999-12-30")
oldNews <- data_frame()

for (i in 1:length(raw)) {
  
  currentDate <- unique(raw[[i]]$time) 
  
  temp <- full_join(activeNews, raw[[i]], by = c("news", "rank")) %>%
          
          mutate(from = case_when(is.na(.$from) ~ currentDate,
                                  TRUE ~ .$from)) %>% 
          
          mutate(to = case_when(is.na(.$time) ~ currentDate,
                                is.na(.$to) ~ openTime,  
                                TRUE ~ .$to)) %>%
          select(news:rank)
  
 activeNews <- temp %>% filter(to == "3999-12-30") 
 
 oldNews <- rbind(oldNews, temp %>% filter(to != "3999-12-30")) 
  
} 

##Active 

activeNews

##Whole db


fulldb <- bind_rows(oldNews, activeNews)




  
  

