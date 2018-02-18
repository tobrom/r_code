library(visNetwork)
nodes1 <- data.frame(id = c("ol1", "ol2", "ol3", "ol4", "ol5"), 
                     shape = c("dot"),
                     size = 5,  
                     color = "#009EC2")


nodes2 <- data.frame(id = c("stark", "apple", "ale"), 
                     shape = c("square"),
                     size = 10,  
                     color = "#000000")                    

nodes <- rbind(nodes1, nodes2)

edges <- data.frame(from = c("ol1", "ol1", "ol2", "ol3", "ol4", "ol5", "ol4", "ol4"),  
                    to = c("stark", "apple", "apple", "ale", "ale", "apple", "apple", "stark"))


visNetwork(nodes, edges) %>%
  visOptions(highlightNearest = TRUE, nodesIdSelection = TRUE)







