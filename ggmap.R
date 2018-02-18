library(ggmap)
library(stringr)
library(dplyr)

###Get gps coordinates and additional data for Stockholm

coords <- geocode("Rio de Janeiro", source = "google", output = "more") %>% select(north, east)
coords2 <- geocode("Stockholm", source = "google", output = "more") %>% select(north, east)


###Get map of area

map <- qmap("Jeppo", zoom = 15)

###Get distance between to locations

mapdist("Paris", "Barcelona")

#df <- mapdist("Raffinaderivagen 13", "Agavagen 12")

#write.csv(df, paste0("DistData/di_news_", str_replace_all(Sys.time(), ":", "."), ".csv"), 
#          row.names = F, 
#          fileEncoding = "UTF-8")


library(geosphere)

distm(c(coords$north, coords$east), 
      c(coords2$north, coords2$east), 
      fun = distHaversine)/1000








