library(ggplot2)

t <- NULL


for (i in 1:30) {


k <- kmeans(iris[,1:2], i)
df <- data.frame(iris[,1:2], k$cluster)
ggplot(df, aes(x = Sepal.Length, y = Sepal.Width, color = as.factor(k.cluster))) + geom_point() 


##elbow method

ir <- data.frame(iris[,1:2], cluster = k$cluster)
irc <- data.frame(k$centers, cluster = rownames(k$centers))
irr <- merge(ir, irc, by = "cluster")

t[i] <- sum(((irr$Sepal.Length.x-irr$Sepal.Length.y)^2)+((irr$Sepal.Width.x-irr$Sepal.Width.y)^2))

}


plot(t)