###Examples with apply, lapply and sapply

a <- rep(c("a", "b", "c"), 5)
b <- 1:15
c <- rnorm(15, sd = 5)
df <- data.frame(a, b, c)



a1 <- rnorm(15, sd = 5)
b1 <- rnorm(15, sd = 5)
c1 <- rnorm(15, sd = 5)
df1 <- data.frame(a1, b1, c1)


A <-matrix(1:9, 3,3)
B <-matrix(4:15, 4,3)
C <-matrix(8:10, 3,2)
myList <- list(A,B,C)


#apply, lapply

###apply --> applies a function per row (1) or per column (2)

d <- apply(df[c(2,3)], 1 ,function(i) 
  if(min(i) > 5) { min(i)} else "No values over 5")

#sorting all rows (1) or columns (2) of a matrix 
df.sort <- apply(df1, 1, sort)



###lapply <- similar as apply but for lists (retrun list of same length back)

#Extract second column from each list and save as list with same structure as original list

lapply(myList,"[", , 2)

#Extract first row"
lapply(myList,"[", 1, )

#Extract single element

lapply(myList,"[", 1, 2)



###sapply <- similar to lapply but simplyfying the output (return a vector instead of matrix (simplyfy = T (default)))

sapply(myList,"[", 1, 2)

###lapply + apply function can be an alternative to loops!!!

test <- function(a) {apply(a, c(1,2) ,function(i) 
  if(min(i) > 5) { min(i)} else "No values over 5")}

lapply(myList, test)

###############################


aggStats <- lapply(dataList, function(x) 
  cbind(unique(x[1]), 
        uniqueNumber = nrow(x), 
        totValue = sum(x[13])))






