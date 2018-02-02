###parallell computations

#Neded packages

library(parallel)
library(foreach)
library(doParallel)
library(tidyverse)
library(randomForest)

#creating a two level data set from iris
df <- filter(iris, Species != "setosa")
df$Species <- as.factor(as.character(df$Species))

#creating the model function
bootstrap <- function(x = NULL) {
   
  ind <- sample(nrow(df), 1000, replace = TRUE)
  
  iris.rf <- randomForest(Species ~ ., data=df[ind,])
  
  accuracy <- sum(iris.rf$predicted == df[ind,]$Species)/nrow(df)

  return(accuracy)
}


#Method1 with library(parallel)

#p <- detectCores(logical = FALSE) #only counting physical cores
p <- detectCores()-1  #counting all cores (including hyperthreads) but subtracting 1
p

cl <- makeCluster(p) #creating the cluster
#cl <- makeCluster(10)


clusterEvalQ(cl, library(randomForest)) #loading the randomForest library to workers
clusterExport(cl, "df") #exporting the iris df created earlier 

n <- 10 #number of models

time_par <- system.time(clusterApply(cl, 1:n, fun = bootstrap)) #cluster time
time_seq <- system.time(lapply(1:n, bootstrap)) #sequential computations

stopCluster(cl) #close the cluster when done


####similar but using the parApply function (similar to apply)
p <- detectCores()-1 
cl <- makeCluster(p)
parApply(cl, matrix(1:2000,  nrow = 20), 1, sum)
stopCluster(cl)


####creatign the plots
library(snow) #using the plot from the snow package (not implemented in the parallell package yet?)

ctime <- snow.time(clusterApply(cl, 1:n, fun = bootstrap))

plot(ctime)

detach(package:snow)


#Method 2 with the library(foreach) and library(doParallel) in the backend 

time_foreach_seq <- system.time(foreach(i=1:n) %do% bootstrap(i)) #sequential foreach

time_loop <- system.time(for (i in 1:n) { bootstrap(i) }) #traditional for loop



p <- detectCores()-1
cl <- makeCluster(p)
registerDoParallel(cl, cores = 2)

time_foreach_par <- system.time(foreach(i = 1:n, 
                                        .packages = "randomForest") %dopar% bootstrap(i))


stopImplicitCluster()












