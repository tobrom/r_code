library(officer)
library(tidyverse)

setwd("Z:/ppt")

template <- "Z:/ppt/template.pptx"


#1. Initiate presentation
my_pres <- read_pptx(path = template)

#check themes
layout_summary(my_pres)
layout_properties(my_pres)

first.master <- layout_summary(my_pres) %>% 
  select(master) %>% 
  distinct() %>% 
  pull() 


#2.Manipulate slides

#add slide
my_pres <- my_pres %>% 
  add_slide(layout = "Subhead Two Content", master = first.master[1])

#remove a slide 
#my_pres <- my_pres %>% remove_slide(index = 1)

#Select slide -> slide where following content will be put 
#my_pres <- my_pres %>% on_slide(index = 2)


#3.Add content to the selected slide

#Add text 
my_pres <- my_pres %>% 
  ph_with_text(type = "title", str = "A title") %>%
  ph_with_text(type = "ftr", str = "A footer") 

#Add imgae 

img <- "Z:/ppt/ra.png"

my_pres <- my_pres %>%
  ph_with_img(type = "body", index = 1, src = img, height = 2, width = 4) 

#Add Plot


gg_plot <- ggplot(data = iris, aes(x = Sepal.Length, y = Petal.Length)) +
  geom_point(size = 3)


my_pres <- my_pres %>%
  add_slide(layout = "Title and Content", master = first.master[1]) %>%
  ph_with_gg(value = gg_plot)


#Add table

my_pres <- my_pres %>%
  add_slide(layout = "Title and Content", master = first.master[1]) %>%
  ph_with_table(type = "body", value = head(iris))



#4.Save the presnetation

#Saves the presnetation
print(my_pres, target = "my_pres.pptx")



############################################

#Case 1 - Creating everything wiht a long pipe

img <- "Z:/ppt/ra.png"

gg_plot <- ggplot(data = iris, aes(x = Sepal.Length, y = Petal.Length)) +
  geom_point(size = 3)

lorem = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, 
  sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. 
  Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris 
  nisi ut aliquip ex ea commodo consequat." 


my_pres <- read_pptx(path = template) %>%
  
  #Content on Front Page
  ph_with_text(type = "ctrTitle", str = "Company Presentation") %>%
  ph_with_text(type = "dt", str = Sys.Date()) %>%
  ph_with_img_at(src = img, height = 1, width = 2.5, left = 5, top = 5) %>%
  
  #Add Second slide
  add_slide(layout = "Subhead Two Content", master = first.master[1]) %>%
  
  #Add content on second slide    
  ph_with_text(type = "title", str = "First Content Slide") %>%  
  ph_with_gg_at(value = gg_plot, height = 4, width = 4, left = 0.5, top = 2) %>%
  ph_with_gg_at(value = gg_plot, height = 4, width = 4, left = 5, top = 2) %>%

  #Third slide
  add_slide(layout = "2_Custom Layout", master = first.master[1]) %>%
  ph_with_text(type = "title", str = "Second Content Slide") %>%
  ph_with_text(type = "body", str = lorem) %>%
  ph_with_gg_at(value = gg_plot, height = 4, width = 4, left = 5, top = 2) %>%
  
  #Save the presentation
  print(target = "my_pres.pptx")








