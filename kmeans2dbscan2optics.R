library(dbscan)
library(ggplot2)


###simple k-means clustering

k <- kmeans(iris[,1:2], 4)
df <- data.frame(iris[,1:2], k$cluster)
ggplot(df, aes(x = Sepal.Length, y = Sepal.Width, color = as.factor(k.cluster))) + geom_point() 


##elbow method

ir <- data.frame(iris[,1:2], cluster = k$cluster)
irc <- data.frame(k$centers, cluster = rownames(k$centers))
irr <- merge(ir, irc, by = "cluster")

sum(((irr$Sepal.Length.x-irr$Sepal.Length.y)^2)+((irr$Sepal.Width.x-irr$Sepal.Width.y)^2))



###implementing a dbscan clustering algorithm

d <- iris[,1:2]

kNNdistplot(d, k = dim(d)[2]+1)   # The plot can be used to help find a suitable value for the eps, k = dim +1

db <- dbscan(d, eps = .3, minPts = dim(d)[2]+1)
df1 <- data.frame(d, db$cluster)
ggplot(df1, aes(x = Sepal.Length, y = Sepal.Width, color = as.factor(db.cluster))) + geom_point() 


###implementing the optics algorithm

d <- iris[,1:2]

kNNdistplot(d, k = dim(d)[2]+1) 

max.dist <- max(kNNdist(d, dim(d)[2]+1))

op <- optics(d, eps = max.dist, minPts = dim(d)[2]+1)  #eps is only the upper limit to reduce complexity & minPts has a different meaning

res <- extractDBSCAN(op, eps_cl = 0.3)
df2 <- data.frame(d, res$cluster)
ggplot(df2, aes(x = Sepal.Length, y = Sepal.Width, color = as.factor(res.cluster))) + geom_point() 



####



d <- iris[,1:2]

kNNdistplot(d, k = 2) 

max.dist <- max(kNNdist(d, dim(d)[2]+1))

op <- optics(d, eps = Inf, minPts = 5)  #eps is only the upper limit to reduce complexity & minPts has a different meaning
plot(op)
unique(paste(op$reachdist))

res <- extractDBSCAN(op, eps_cl = 0.4)
df2 <- data.frame(d, res$cluster)
ggplot(df2, aes(x = Sepal.Length, y = Sepal.Width, color = as.factor(res.cluster))) + geom_point() 


library(dbscan)

d <- data.frame(a = c(30, 9, 4 ,5, 4.2, 7, 8,4, 3, 2, 15, 16, 18, 17, 18, 34, 33, 32), b = 1:1)
#d <- data.frame(a = c(2, 9, 4 ,5, 4.2, 7), b = 1:1)
op <- optics(d, eps = Inf, minPts = 2) 
op$order
op$coredist
op$reachdist


df <- data.frame(data = d$a[op$order], 
           #order = op$order,
           cored = op$coredist[op$order], 
           reach = op$reachdist[op$order]) 
df




































