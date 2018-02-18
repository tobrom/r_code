library(tidyverse)

#The first part is to be considered as already existing
#########################################################

path <- "path1"
path.active <- "path2"

activeNews <- read_csv(path.active)

activeNews <- data_frame(news = c("allan", "gerd", "leffa", "kriss"),
                         from = as.Date("2014-01-01"),
                         to = as.Date("3999-12-30"),
                         rank = c(1, rep(2, 2), 3))

#########################################################
#Data tp be processed

rawFileNames <- list.files(path)

rawFiles <- lapply(rawFileNames, function(fn) read_csv(paste0(path, "/", fn)))



rawFiles <- lapply(rawFiles, function(n) n[,-(2:3)])


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

openTime <- ymd_hms("3999-12-30 23:59:59")

oldNews <- data_frame()

for (i in 1:length(rawFiles)) {
  
  currentDate <- unique(rawFiles[[i]]$timeStamp) 
  
  temp <- full_join(activeNews, rawFiles[[i]], by = c("text", "position")) %>%
    
    mutate(from = case_when(is.na(.$from) ~ currentDate,
                            TRUE ~ .$from)) %>% 
    
    mutate(to = case_when(is.na(.$timeStamp) ~ currentDate,
                          is.na(.$to) ~ openTime,  
                          TRUE ~ .$to))
 
  
  activeNews <- temp %>% filter(to == openTime) %>% select(-timeStamp) 
  
  oldNews <- rbind(oldNews, temp %>% filter(to != openTime)) 
  print(i)
  
} 

##Active 

activeNews

##Whole db


fulldb <- bind_rows(oldNews, activeNews)







