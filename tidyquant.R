library(tidyquant)
library(dplyr)
library(lubridate)

#Exchanges available
tq_exchange_options()

#Get exchange tickes
tickers.exchange <- tq_exchange("NASDAQ")

#variables available
tq_get_options()

financials <- tq_get(tickers.exchange$symbol[9:30], get = "financials")

df <- financials %>%
  filter(type == "IS") 
  
tf <- map(df$annual, ~filter(.x, group == 1)) %>% 
  bind_rows() %>%
  mutate(year = year(date)) %>%
  group_by(year) %>%
  na.exclude() %>%
  summarise(revenue = sum(value)) %>%
  ggplot(aes(x = year, y = revenue, fill = year)) + geom_bar(stat = "identity")




#Library for time series modelling
library(timetk)






