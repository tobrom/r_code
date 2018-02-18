library(purrr) 

#alternative to for loops (and potentially lapply())
#main motive: constanr output from map_dbl (not the same for sapply)
#key functions:

#map() -> returns list

#simplier output -> vector (similar to sapply from lapply)

#map_dbl <- double (occupies 8 bytes (64 bits))
#map_lgl() -> logical vector
#map_int() -> integer
#map_chr() -> character

#walk()

lista <- list(x = data.frame(a = 1:5, b = 1), y = data.frame(a = 2:6, b = 2))

map(lista, ~ mean(.x$a)) #returns list -> similar to lapply
map_dbl(lista, ~ mean(.x$a)) #returns vector -> similar to sapply


#to each element of .x and corresponding element of .y apply .f

#map2() -> returns list

#map2_dbl() -> vector double
#map_...() the same way as for map_
#pmap() take a single list .l and map over all its elements in parallel.

#Example with DI files 
library(tidyverse)
library(readr)

path <- "Z:/2017/2017-04-06 -- App/useR Ideas/DI Data"
files <- list.files(path)
files_long <- paste0(path, "/", files)


news_list <- map(files_long, read_csv)

extract_nr <- 1:length(news_list)

news_list_mutated <- map2(.x = news_list,
                          .y = new_vars,
                          .f = ~ mutate(.x, extract_nr = .y,
                                            position = as.numeric(row.names(.x))))


df <- bind_rows(news_list_mutated)

#all news
tf <- df %>% group_by(news) %>%
  summarise(count = length(news),
            mintime = min(timeStamp),
            maxtime = max(timeStamp)) %>%
  arrange(desc(count))
  

##top new
tf_top <- df %>% 
  filter(position < 2) %>%
  group_by(news) %>%
  summarise(count = length(news),
            mintime = min(timeStamp),
            maxtime = max(timeStamp)) %>%
  mutate(duration = maxtime-mintime) %>%
  arrange(desc(count))


tops <- tf_top %>%
  top_n(5, duration) %>%
  select(news)



pd <- df %>%
  filter(news %in% tops$news) %>%
  split(.$news)


plots <- map2(pd, tops$news,
              ~ ggplot(.x, aes( timeStamp, position)) +
                geom_bar(stat = "identity") +
                labs(title = .y))

plots[[1]]



###working with joins for DI case

a <- head(news_list[[1]], 10) 



b <- head(news_list[[4]], 10)

a$rank <- c(1, rep(2, 4), rep(3, nrow(a)-5))
b$rank <- c(1, rep(2, 4), rep(3, nrow(b)-5))

a <- select(a, news, from = timeStamp, rank)
b <- select(b, news, from = timeStamp, rank)

stamp <- unique(b$from)
active <- ymd_hms("3999-12-30 23:59:59")

a$to <- active

temp <- left_join(a, b, by = c("news", "rank"))
temp$to <- ifelse(is.na(temp$from.y), stamp, active)














