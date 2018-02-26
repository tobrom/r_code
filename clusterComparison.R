df <- filter(iris, Species != "setosa")
df$Species <- as.factor(as.character(df$Species))

#creating the model function
bootstrap <- function(x = NULL) {
  
  ind <- sample(nrow(df), 100, replace = TRUE)
  
  iris.rf <- randomForest(Species ~ ., data=df[ind,])
  
  accuracy <- sum(iris.rf$predicted == df[ind,]$Species)/nrow(df)
  
  return(accuracy)
}

#creating model function 2
bootstrap2 <- function(x = NULL) {
  
  res <- data.frame()
  
  for (i in 1:10) {
  
  ind <- sample(nrow(df), 10000, replace = TRUE)
  
  iris.rf <- randomForest(Species ~ ., data=df[ind,])
  
  accuracy <- sum(iris.rf$predicted == df[ind,]$Species)/nrow(df[ind,])
  
  res <- rbind(res, data.frame(iter = i, accuracy = accuracy))
  
  }
  
  return(mean(res$accuracy))
}




test <- data.frame()

for (t in 1:20) {
 
for (p in 1:10) {

cl <- makeCluster(p) #creating the cluster

clusterEvalQ(cl, library(randomForest)) #loading the ranfonForest library to workers
clusterExport(cl, "df") #exporting the df created earlier 

n <- 10 #number of models

t1 <- Sys.time()
res <- clusterApply(cl, 1:n, fun = bootstrap)
t2 <- Sys.time()

stopCluster(cl)

test <- rbind(test, data.frame(iteration = t, clusters = p, stats = as.numeric(paste(t2-t1))))


}

}


test

ggplot(test, aes(x = clusters, y = stats, group = clusters)) +geom_boxplot()
