library(taskscheduleR)

taskscheduler_create(taskname = "dist_mi", rscript = "Z:/2017/2017-04-06 -- App/useR Ideas/diAnalysis.R", 
                     schedule = "MINUTE", startdate = format(Sys.Date(), "%Y/%m/%d"), starttime = "17:10", modifier = 10)

###check task status

tasks <- taskscheduler_ls()
tasks[tasks$TaskName %in% c("discrape_min"),]

###delete
taskscheduler_delete("discrape")
