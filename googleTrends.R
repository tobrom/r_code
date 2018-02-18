#if (!require("devtools")) install.packages("devtools")
#devtools::install_github("PMassicotte/gtrendsR")


library(gtrendsR)

res.long <- gtrends(c("Hennes & Mauritz"), time = "all", geo = "SE", gprop = "web")
res.short <- gtrends(c("Handelsbanken", "SEB", "Nordea", "Swedbank"), time = "all", geo = "SE", gprop = "web")

par(mfrow = c(2,1))
plot(res.long)
plot(res.short)

####

fin <- data.frame()

for (i in paste0(rep(LETTERS[1:26],2))) {


res.cus <- gtrends(paste(i), time = "now 1-d", geo = "SE", gprop = "web")
df <- data.frame(let =paste(i), tot = sum(res.cus$interest_over_time[2])) 
fin <- rbind(fin, df)

}

plot(res.cus)

#time = "now 1-H"
#time = "now 4-H"
#time = "now 1-d"
#time = "today 3-m"